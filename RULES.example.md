# My Rules

## Git Workflow
- Always commit, never push unless explicitly told to.
- Before any push: run lint, tests, check for secrets/env vars, verify no broken imports — fix all issues first.
- Commit messages must be descriptive (what + why), conventional commits format preferred.
- Never force push. Never amend a pushed commit.

## Tools & Tech
- Always use the best tool/tech for the task — don't default to familiar, default to optimal.
- Prefer lightweight solutions: fewer dependencies, smaller bundle, less complexity.
- Reduce token usage at every step — prefer targeted reads over full-file reads, use repomix for whole-repo context.
- Full tool/tech reference: `D:/Coding/AgentMaster/Tool-Stack-Reference/hub/` (62 files, 1524 tools + 1767 tech, free-first)
  - Key refs: `tools-ai-coding.md`, `tools-ai-agents.md`, `tools-ai-infra.md`, `tools-api-dev-tools.md`
  - Tech refs: `tech-js-ts-packages.md`, `tech-python-packages.md`, `tech-databases-storage-search.md`, `tech-devops-infra.md`

## Cost & Resources
- Prefer free/open-source tools unless a paid alternative has meaningfully better quality or is industry standard.
- Flag when a paid tool is being recommended and state why it's worth it.

## Output Style
- Caveman Mode is always ON — drop articles, use fragments, short synonyms, no filler.
- No "great question", no "certainly", no padding. State facts, be direct.
- Code-only responses for pure code tasks — skip prose unless explaining a non-obvious decision.

## Security Hygiene
- Never commit .env, secrets, API keys, tokens — abort and warn if spotted.
- Always add .env to .gitignore on new projects before first commit.
- Scan for hardcoded credentials before every commit.

## Code Quality
- Before marking a task done: no console.log/print debris, no commented-out code, no untracked TODOs.
- New source/logic files (functions, classes, modules) get a test file. Scripts, configs, docs, and agent context files exempt.
- No dead imports, no unused variables left behind.
- In bash with `set -e`: never use bare `cd dir` + later `cd -`. Use `git -C dir cmd`, subshells `(cd dir && cmd)`, or pushd/popd instead.
- Scripts must use relative paths (`__dirname`, `$(dirname "$0")`, `path.join`) not hardcoded absolute paths. Absolute paths break on every other machine.
- All code/file generators must be idempotent: running twice = same result as once. Append-only generators that skip existing content are forbidden — they go stale silently.
- Any count, enum, or routing table referenced in docs/README must be updated in the same commit as the code change. Doc drift is a bug.

## Project Agents File
- Every project gets an `agents.md` at the repo root on first session.
- Contents: project overview, stack, key dirs/files, how to run/build/test, env vars needed, agent-specific notes (what to avoid, what's sensitive, known gotchas).
- Keep it updated — whenever architecture changes, add a feature, or change the stack, update agents.md in the same commit.
- If `agents.md` already exists, read it before doing anything else in that project.

## Project Context
- GitHub username: Surya8991
- Main projects dir: D:/Coding/
- Skills dir: C:/Users/surya/.claude/skills/

## Asking vs Doing
- Destructive ops (delete, reset, drop DB, overwrite, force push): confirm first, always.
- Ambiguous tasks: ask ONE focused question, don't guess and do 5 things.
- Never silently skip a step — if blocked, say so.

## Session Efficiency
- Session start: invoke /agent-master first (handles repomix + context load), then git status. /mem-search only if task might duplicate prior work.
- Task >3 steps: show plan first, wait for go-ahead.
- Reuse .agentmaster/codebase.xml — don't re-read files already in the snapshot.
- Before running any script with flags, run `--help` first. Never assume flag format.

## Verification
- Before claiming done: run the actual command, show output. Use /verification-before-completion if installed — otherwise manually confirm: tests pass, no lint errors, output matches expectation.
- No completion claims without fresh evidence. Applies to: commits, PRs, bug fixes, test passes, build success. No exceptions.
- After running any generator/converter script, verify output with grep/wc — don't trust exit 0 alone.

## Parallel Agents
- For 2+ independent subtasks (separate bugs, separate files, separate modules) — use /dispatching-parallel-agents.
- Never work sequentially when parallel is possible — wastes time and tokens.
- Each agent gets only the context it needs — don't dump full session history into subagents.

## Codebase Exploration Hierarchy
- New or unfamiliar repo → /learn-codebase (reads every file, front-loads context once)
- Targeted lookup (find a function, trace a call, locate a symbol) → /smart-explore
- Whole-repo audit (security, review, cross-cutting refactor) → repomix-pack (.agentmaster/codebase.xml)
- Never use /learn-codebase on a familiar repo mid-session — wasteful.

## Code Review Routing
- /codereview → blunt review of current code or diff, anytime
- /requesting-code-review → before merging a PR (full workflow + checklist)
- /receiving-code-review → when acting on feedback from a reviewer
- Never mix these — each has a distinct purpose.

## Git Worktrees
- For parallel feature branches or isolated experiments → use /using-git-worktrees.
- Avoids stash/checkout churn. Use when working on 2+ branches simultaneously.

## PR Monitoring
- After pushing a PR → use /babysit to monitor CI, reviews, and comments until merge-ready.
- Don't manually poll GitHub — babysit handles the loop.
- Stop only when: checks pass, no unresolved review threads, review decision is acceptable.

## AgentMaster Rules

### Session Bootstrap
- On the first message of every session, invoke /agent-master if the working directory contains a code repo (.git, package.json, pyproject.toml, Cargo.toml, or go.mod).
- This triggers repomix-pack to snapshot the codebase to .agentmaster/codebase.xml so downstream skills have whole-repo context without re-reading files.
- Only skip bootstrap if the user explicitly says "skip repomix" or the directory is not a repo.

### Routing
- Default entry point for all multi-step or ambiguous tasks is /agent-master — never pick skills manually for these.
- For simple, clearly scoped tasks (single file, direct question) invoke the skill directly.
- Never chain more than 2 domain skills without asking the user to narrow scope first.

### Repomix Snapshots
- Always use .agentmaster/codebase.xml as input for whole-repo tasks (security audit, architecture review, full code review) instead of re-reading individual files.
- Force a re-pack with /agent-master repomix refresh when code changes significantly mid-session.

### Memory
- Use /mem-search before starting any task that might duplicate prior work ("did we already solve this?").
- Use /timeline-report for project history questions, not git log.
