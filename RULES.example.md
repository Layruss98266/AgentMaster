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

## Tips

- **Be specific** — "use 2-space indentation" works better than "format code nicely"
- **Use checklists** — "before committing, check: lint, secrets, docs" is enforceable
- **Set paths** — tell Claude where your projects live so it doesn't ask every time
- **Add preferences** — username, default tools, coding style saves repeated instructions
- **Keep it short** — long rule files eat context window tokens every session
