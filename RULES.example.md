# Custom Rules for Claude

Define rules that Claude follows every session. Rules are read from `~/.claude/RULES.md` automatically.

## Setup

```bash
# Create your rules file
touch ~/.claude/RULES.md

# Open and add your rules
nano ~/.claude/RULES.md
```

## How It Works

- Claude reads `~/.claude/RULES.md` at the start of every session
- Rules persist across all conversations
- Add, remove, or edit rules anytime — changes apply on next session
- Rules override default behavior

## Writing Rules

Rules are plain markdown. Write them as clear instructions. Be specific — vague rules get ignored.

### Example Rules File

```markdown
# My Rules

## Git Workflow
- Never push to remote. Only commit.
- No AI co-author lines in commits.
- Run tests before every commit.

## Code Style
- Use TypeScript strict mode.
- Prefer functional components over class components.
- Max file length: 300 lines.

## Reviews
- Be direct. No filler. State problems with file:line references.
- Rate issues by severity: Critical, High, Medium, Low.

## Project Paths
- Main projects: ~/dev/
- Skills folder: ~/dev/skills/

## Preferences
- GitHub username: your-username
- Default language: Python
- Preferred framework: Next.js
```

## AgentMaster

Copy this block into your `~/.claude/RULES.md` to enforce consistent AgentMaster behavior across all sessions:

```markdown
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
```

## Project Agents File

Add this rule to ensure every project gets an `agents.md` context file:

```markdown
## Project Agents File
- Every project gets an `agents.md` at the repo root on first session.
- Contents: project overview, stack, key dirs/files, how to run/build/test, env vars needed, agent-specific notes (what to avoid, what's sensitive, known gotchas).
- Keep it updated — whenever architecture changes, add a feature, or change the stack, update agents.md in the same commit.
- If `agents.md` already exists, read it before doing anything else in that project.
```

## Tips

- **Be specific** — "use 2-space indentation" works better than "format code nicely"
- **Use checklists** — "before committing, check: lint, secrets, docs" is enforceable
- **Set paths** — tell Claude where your projects live so it doesn't ask every time
- **Add preferences** — username, default tools, coding style saves repeated instructions
- **Keep it short** — long rule files eat context window tokens every session
