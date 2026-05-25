---
name: agentmaster-logger
description: "Maintain a handoff-ready session log (AGENTMASTER_LOG.md) tracking every state-changing action, decision, and pending task. Append-only, multi-session, status-tagged. The log is structured so a different LLM (Claude in a new session, GPT, Gemini, anything) can resume work cold by reading only the latest session block. Use when work is non-trivial, multi-step, may be paused, or needs to survive context-window resets. Not for one-shot questions."
---

# Skill: AgentMaster Session Logger

A structured, append-only session log so LLM coding work survives interruptions and handoffs. Sibling to the `agent-master` orchestrator: orchestrator routes work, logger preserves it.

## Why

LLM coding sessions are fragile:

- Context window resets.
- A crash mid-task leaves no trail.
- Switching from Claude to another LLM means re-explaining everything.
- "What did we do last week?" requires scrolling chat history.

The logger solves all four with one append-only markdown file maintained as you work.

## File location and storage model

`AGENTMASTER_LOG.md` lives in the **project root** (alongside `CLAUDE.md` and the project's top-level docs). Never put it in `.claude/` — other LLMs won't look there.

**Multi-session append.** Every new session appends a new `## Session:` block at the bottom. Earlier blocks are **never** overwritten, edited, or deleted.

**New-session detection** (deterministic, no heuristics):
- If no `## Session:` block in this conversation has been edited by you yet → append a new one.
- Otherwise → keep editing the current (last) block.

This eliminates fragile "fresh chat" / ">1hr idle" guessing. It's a conversation-scoped rule the LLM can actually evaluate.

**Concurrency.** If parallel sessions need separate logs (e.g. two terminals on different branches), suffix the filename: `AGENTMASTER_LOG_<branch-or-tag>.md`. Don't share one log across simultaneous sessions — last-write-wins corrupts state.

**Archive trigger.** When the file exceeds ~500 lines OR the user says "archive the log":
1. Create `AGENTMASTER_LOG_ARCHIVE.md` if missing (same header as main file).
2. Move every `## Session:` block except the latest 3 into the archive.
3. Confirm: "Archived N sessions to `AGENTMASTER_LOG_ARCHIVE.md`. Latest 3 remain."

Never delete. Archive only.

## Session block structure

```markdown
## Session: <ISO 8601 timestamp> — <one-line summary>

- **Started**: <ISO 8601 with timezone, e.g. 2026-05-25T14:30+05:30>
- **Status**: in_progress | checkpointed | complete | interrupted
- **Model**: <model id>
- **User goal (verbatim)**: <quote user's opening message>

### Changes made
- <relative/path.py:line> — <one-line why>

### Commands run
- `<command>` — <what it produced>

### Decisions and rationale
- <decision> — <why this, not the alternative>

### Pending / Incomplete
- [ ] <unfinished task with enough context to resume>

### Resume instructions for next LLM
- <plain-English: open file X at line Y, do Z, then run command W>
- **Next action if interrupted now**: <one sentence>
```

### Status field semantics

| Value | When to set |
|---|---|
| `in_progress` | On session creation. Remains until session ends. |
| `checkpointed` | User invoked the logger slash command mid-session OR said "checkpoint". Resume instructions are current and complete. |
| `complete` | User confirmed all work done ("done", "ship it", "all good", or natural end). |
| `interrupted` | NEVER set by the assistant. If a next LLM sees `in_progress` AND the session is older than the current conversation, treat it as `interrupted` and start a new block. |

The next LLM's heuristic: read the latest block. If status is `complete` or `checkpointed`, the work is in a clean state. If `in_progress` and it's not your conversation, the previous session was cut off — your job is the `Pending / Incomplete` list.

## Lifecycle

### On first state-changing action

1. Read `AGENTMASTER_LOG.md` if it exists; create with header if not.
2. **Append** a new `## Session:` block. Do NOT modify any existing block.
3. Fill header: ISO 8601 start time, `Status: in_progress`, model id, user goal verbatim.
4. Initialize all 5 subsections (`(nothing yet)` placeholder is fine).
5. Tell user once: "AgentMaster log opened at `AGENTMASTER_LOG.md`."

A "state-changing action" = `Edit`, `Write`, `Bash` that mutates files / runs generators / runs verifiers / changes config. Read-only ops (Read, Grep, Glob, file inspection, dry-run greps) are NOT state-changing.

### During the session

Update the current session block **incrementally** — not at the end:

- After each state-changing action → append a bullet to the relevant subsection.
- After each non-obvious judgment call → append to `Decisions and rationale`.
- After each scoped-down or unfinished request → unchecked checkbox in `Pending / Incomplete`.
- **Continuously maintain `Resume instructions`.** Update the "Next action if interrupted now" line after every significant change. If the assistant crashes mid-session, this line is the only thing that lets the next LLM continue.

### On checkpoint

1. Bring all 5 subsections fully current.
2. Fill in the one-line summary at the top of the session block.
3. Fully populate `Resume instructions for next LLM`.
4. Set `Status: checkpointed`.
5. Confirm: "Log checkpointed — safe to hand off."

### On session end / handoff

Same as checkpoint, plus:
- Mark completed items `- [x]`, leave unfinished as `- [ ]`.
- Set `Status: complete` if all work is done; leave `checkpointed` if user is pausing.
- Write `Resume instructions` to brief a stranger: exact file paths, exact commands, expected output.

## What counts as a "tracked file"

Any file under the project root **except**:
- Generated content (`output/`, `dist/`, `build/`, etc.)
- Build artifacts (`__pycache__/`, `*.pyc`, `node_modules/`, `target/`)
- `AGENTMASTER_LOG.md` itself (don't log edits to the log)

## What to log

✅ **DO log**:
- File creations, edits, deletions (path + one-line why)
- Generator / verifier / build / test runs
- Database / schema changes
- Configuration / setting changes
- Non-obvious decisions (chose X over Y because Z)
- Unfinished tasks, scoped-down work, blocked items

❌ **DO NOT log**:
- Read-only operations (Read, Grep, Glob, file inspection)
- Internal reasoning or chain-of-thought
- Diff contents (git has those)
- Conversational acknowledgements
- Tool-permission prompts
- Edits to `AGENTMASTER_LOG.md` itself

## Bullet format rules

- **One change per bullet** — unless you're making the same change repeatedly to one file. In that case, merge: `databases/foo.py — added 3 country entries (Japan, France, Brazil)`.
- **Relative paths**, with `:line` when localised — `src/api/checkout.py:145`.
- **Short "why", not "what".** The file path already says what; the bullet says why.
- **Past tense, verb first**: "Added Malaysia entry..." not "Was adding..."
- **No emojis** unless the user explicitly asks.
- **ISO 8601 timestamps** in headers: `2026-05-25T14:30+05:30` not `2026-05-25 14:30 local`.

## Handoff quality bar

A different LLM, reading only `AGENTMASTER_LOG.md` with no chat context, should be able to:

1. Identify the active session (latest `## Session:` block).
2. Read its `Status` and decide if work is clean (`complete`/`checkpointed`) or interrupted (`in_progress` from a prior conversation).
3. See what was done (`Changes made` + `Commands run`).
4. Know what's still open (`Pending / Incomplete`).
5. Execute the next action without asking the user (`Resume instructions` — especially the "Next action if interrupted now" line).

If the next LLM must ask the user something to proceed, write that question down explicitly: "Ask the user whether they want X or Y before continuing."

## Anti-patterns to avoid

| Anti-pattern | Why it's wrong | Do instead |
|---|---|---|
| Updating the log at session end | Crash = no log | Update after every state-changing action |
| Empty `Resume instructions` mid-session | Next LLM has nothing to act on | Keep the "Next action if interrupted now" line current |
| Editing earlier session blocks | Loses history | Append-only; archive when file gets long |
| Logging Read / Grep / Glob | Noise | Only state-changing actions |
| Multiple changes per bullet | Hard to scan | One per bullet (except repeated edits to one file) |
| Vague "why" ("misc fixes", "cleanup") | Useless for handoff | Specific cause ("removed unused import flagged by ruff E501") |
| Re-reading the log to verify | Edit/Write errors on failure | Trust silent success |

## How it pairs with `agent-master`

| Skill | Role |
|---|---|
| `agent-master` | Routes incoming task to the right combination of skills |
| `agentmaster-logger` | Persists what was done so the work survives across sessions / LLMs |

Both are loadable independently. If both are active, `agent-master` handles routing decisions and `agentmaster-logger` handles persistence. No coupling.

## Example session block (filled in)

```markdown
## Session: 2026-05-25T14:30+05:30 — Added feature flag + migration

- **Started**: 2026-05-25T14:30+05:30
- **Status**: complete
- **Model**: claude-opus-4-7
- **User goal (verbatim)**: "Add a feature flag for the new checkout flow and write the migration."

### Changes made
- `src/flags.py:42` — added `CHECKOUT_V2_ENABLED`, defaults to False
- `migrations/0042_checkout_v2.sql` — adds `checkout_v2_opted_in` boolean column
- `tests/test_flags.py:88` — unit test for the new flag default
- `README.md:120` — documented the flag in env-vars table

### Commands run
- `pytest tests/test_flags.py -v` — 14 passed, 0 failed
- `alembic upgrade head` — applied migration on local dev DB

### Decisions and rationale
- Defaulted flag to False — opt-in rollout per safety policy.
- Used a real column, not a JSON blob in `feature_flags` — keeps it queryable/indexable for analytics.

### Pending / Incomplete
- [x] Add flag, migration, default test
- [ ] Wire flag into `src/api/checkout.py:145` (`post_checkout`)
- [ ] Integration test against staging DB
- [ ] Runbook update with rollout steps

### Resume instructions for next LLM
1. Open `src/api/checkout.py:145` — entry is `def post_checkout(request)`.
2. Import `CHECKOUT_V2_ENABLED` from `src/flags.py`. Branch on flag + `user.checkout_v2_opted_in`.
3. New flow handler doesn't exist yet — create `src/api/checkout_v2.py` with a stub.
4. Add test in `tests/api/test_checkout.py` covering flag on/off paths.
- **Next action if interrupted now**: Wire `CHECKOUT_V2_ENABLED` into `src/api/checkout.py:145`. Stub `src/api/checkout_v2.py` calling legacy under the hood; real Stripe v2 charge flow is a separate ticket.
```
