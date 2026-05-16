# Tool-Stack-Reference

1524 AI tools + 1767 dev tech items, organized as markdown tables. Free/OSS listed first. Browser extensions excluded.

## Using the Reference

The `hub/` directory contains ready-to-use markdown files — no setup needed.

| Directory | Contents |
|-----------|----------|
| `hub/tools-*.md` | 32 AI tool category files |
| `hub/tech-*.md` | 29 dev tech category files |
| `hub/README.md` | Index of all 61 files |

Key files for agent stack decisions:
- `hub/tools-ai-coding.md` — 143 AI coding tools
- `hub/tools-ai-agents.md` — 53 AI agent frameworks
- `hub/tools-ai-infra.md` — 42 AI infra tools (LLM APIs, vector DBs, observability)
- `hub/tools-api-dev-tools.md` — 49 API & developer tools
- `hub/tech-js-ts-packages.md` — 210 JS/TS packages
- `hub/tech-python-packages.md` — 200 Python packages
- `hub/tech-databases-storage-search.md` — 86 database/storage/search options
- `hub/tech-devops-infra.md` — DevOps & infrastructure tech

## Regenerating the Hub

Only needed when you have an updated `master-hub.html` from the Master Dev Hub.

```bash
# Step 1: Place master-hub.html in this directory (gitignored)
# Step 2: Extract data to JSON intermediates
node Tool-Stack-Reference/scripts/extract.js

# Step 3: Generate markdown files
node Tool-Stack-Reference/scripts/generate-md.js

# Step 4: Commit the updated hub/ directory
git add Tool-Stack-Reference/hub/
git commit -m "chore: regenerate tool/tech hub from updated master-hub.html"
```

Intermediates (`hub-tools-out.json`, `hub-tech-out.json`, `hub-summary.json`, `master-hub.html`) are gitignored — only `hub/*.md` is committed.
