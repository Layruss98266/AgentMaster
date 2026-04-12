# AgentMaster

Meta-orchestrator for Claude Code that classifies tasks and routes to the right combination of skills across 5 repos.

## What It Does

AgentMaster sits on top of your installed skills and automatically picks the best combination for any task:

- **"Build auth system"** → brainstorming + engineering-team
- **"Fix this crash"** → systematic-debugging
- **"Write a blog post"** → marketing-skill
- **"Deploy to AWS"** → devops + writing-plans
- **"Scan for vulnerabilities"** → security-audit
- **"How did we fix that bug?"** → mem-search
- **"Design the dashboard UI"** → ui-ux-pro-max

## Architecture

Three layers that stack, never compete:

| Layer | Source | Role |
|-------|--------|------|
| **Output** | caveman | Token compression (~75% savings) |
| **Workflow** | superpowers | brainstorm → plan → TDD → review → finish |
| **Domain** | claude-skills + devops + security-audit + anthropic built-ins | Subject matter expertise |

## Install

### Windows (PowerShell)
```powershell
.\install.ps1
```

### macOS / Linux / WSL
```bash
bash install.sh
```

### What Gets Installed

| Source | Skills | Count |
|--------|--------|-------|
| **AgentMaster** (this repo) | agent-master, devops, security-audit | 3 |
| **caveman** | caveman, caveman-commit, caveman-review, caveman-help, compress | 5 |
| **superpowers** | brainstorming, writing-plans, TDD, debugging, code-review, ... | 14 |
| **claude-skills** | engineering-team, marketing-skill, product-team, c-level, finance, ... | 10 |
| **claude-mem** | mem-search, smart-explore, knowledge-agent, make-plan, do, timeline-report, version-bump | 7 |
| **Total** | | **39** |

## Usage

```
/agent-master              # invoke on current task
/agent-master route <task>  # dry-run: see routing plan without executing
/agent-master status        # show current state
/caveman                    # enable token compression
```

## Routing Categories (21)

| Category | Routes To |
|----------|-----------|
| Build/Create | brainstorming → engineering-team |
| Refactor | brainstorming → engineering-team |
| Debug/Fix | systematic-debugging |
| Code Review | requesting-code-review |
| Commit/Ship | finishing-a-development-branch |
| Test | test-driven-development |
| Marketing | marketing-skill (44 sub-skills) |
| Strategy | c-level-advisor (28 sub-skills) |
| Product | product-team (16 sub-skills) |
| Finance | finance |
| Business Growth | business-growth |
| Project Mgmt | project-management |
| Compliance | ra-qm-team |
| DevOps/Deploy | devops |
| Security | security-audit |
| UI/UX Design | anthropic-skills:ui-ux-pro-max |
| Documentation | anthropic-skills:docx/pdf/pptx/xlsx |
| Research | anthropic-skills:deep-research |
| Memory/History | mem-search / timeline-report |
| Explore Codebase | smart-explore |
| Simple Question | direct answer (no routing) |

## Dependencies

These repos are cloned automatically by the installer:

- [caveman](https://github.com/JuliusBrussee/caveman) — token compression
- [superpowers](https://github.com/obra/superpowers) — dev workflow
- [claude-skills](https://github.com/alirezarezvani/claude-skills) — domain expertise
- [claude-mem](https://github.com/thedotmack/claude-mem) — session memory

## Uninstall

```bash
bash uninstall.sh  # removes only AgentMaster custom skills
```

## License

MIT
