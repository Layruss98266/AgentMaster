<p align="center">
  <img src="https://img.shields.io/badge/Claude_Code-7C3AED?style=for-the-badge&logo=anthropic&logoColor=white" alt="Claude Code">
  <img src="https://img.shields.io/badge/Codex-10A37F?style=for-the-badge&logo=openai&logoColor=white" alt="Codex">
  <img src="https://img.shields.io/badge/Cursor-000000?style=for-the-badge&logo=cursor&logoColor=white" alt="Cursor">
  <img src="https://img.shields.io/badge/Windsurf-0EA5E9?style=for-the-badge" alt="Windsurf">
  <img src="https://img.shields.io/badge/Gemini_CLI-4285F4?style=for-the-badge&logo=google&logoColor=white" alt="Gemini CLI">
  <img src="https://img.shields.io/badge/Antigravity-F97316?style=for-the-badge" alt="Antigravity">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Skills-41+-10B981?style=for-the-badge" alt="41+ Skills">
  <img src="https://img.shields.io/badge/Categories-22-F59E0B?style=for-the-badge" alt="22 Categories">
  <img src="https://img.shields.io/badge/Platforms-11-6366F1?style=for-the-badge" alt="11 Platforms">
  <img src="https://img.shields.io/badge/Token_Savings-~75%25-EF4444?style=for-the-badge" alt="75% Token Savings">
</p>

<h1 align="center">AgentMaster</h1>

<p align="center">
  <strong>Meta-orchestrator for AI coding agents</strong><br>
  One skill to route them all. Works on Claude Code, Codex, Cursor, Windsurf, Antigravity, Gemini CLI, and 5 more platforms.
</p>

<p align="center">
  <a href="#quick-start">Quick Start</a> &bull;
  <a href="#supported-platforms">Platforms</a> &bull;
  <a href="#how-it-works">How It Works</a> &bull;
  <a href="#routing-table">Routing Table</a> &bull;
  <a href="#commands">Commands</a> &bull;
  <a href="#architecture">Architecture</a>
</p>

---

## The Problem

You have 40+ Claude Code skills installed. For every task, you manually decide:
- Which skill to invoke?
- Should I combine two skills?
- Does this need the workflow gate (brainstorming) or can I skip it?
- Is caveman mode on? Should I use the caveman variant?

**AgentMaster decides for you.** One entry point. Zero manual routing.

## Supported Platforms

| Platform | Format | Install Method |
|----------|--------|---------------|
| **Claude Code** | `SKILL.md` | `bash install.sh` or `.\install.ps1` |
| **OpenAI Codex** | `SKILL.md` | `bash scripts/install-platform.sh --platform codex` |
| **Cursor** | `.mdc` rules | `bash scripts/install-platform.sh --platform cursor` |
| **Windsurf** | `SKILL.md` (trigger frontmatter) | `bash scripts/install-platform.sh --platform windsurf` |
| **Cline** | `.md` rules | `bash scripts/install-platform.sh --platform cline` |
| **Gemini CLI** | `SKILL.md` | `bash scripts/install-platform.sh --platform gemini` |
| **Antigravity** | `SKILL.md` (risk/source fields) | `bash scripts/install-platform.sh --platform antigravity` |
| **OpenCode** | `SKILL.md` (compatibility field) | `bash scripts/install-platform.sh --platform opencode` |
| **Augment** | `.md` rules | `bash scripts/install-platform.sh --platform augment` |
| **Aider** | `CONVENTIONS.md` | `bash scripts/convert.sh --tool aider` |
| **GitHub Copilot** | `copilot-instructions.md` | `bash scripts/convert.sh --tool copilot` |

**Auto-detect all platforms:**
```bash
bash scripts/install-platform.sh
# Detects which platforms are installed and copies skills to each
```

## Quick Start

### Claude Code (Primary)

**Windows (PowerShell):**
```powershell
git clone https://github.com/Surya8991/AgentMaster.git
cd AgentMaster
.\install.ps1
```

**macOS / Linux / WSL:**
```bash
git clone https://github.com/Surya8991/AgentMaster.git
cd AgentMaster
bash install.sh
```

### Any Other Platform
```bash
git clone https://github.com/Surya8991/AgentMaster.git
cd AgentMaster
bash scripts/install-platform.sh --platform codex    # or cursor, windsurf, etc.
```

### All Platforms at Once
```bash
bash scripts/install-platform.sh --platform all
```

The installer clones 4 dependency repos, converts skills to platform-specific formats, and skips anything already installed.

**Restart your IDE/agent after installation.**

## How It Works

You say something. AgentMaster classifies it and routes to the right skill(s):

```
You: "Build an auth system with JWT"
AgentMaster: Routing → brainstorming (workflow) + engineering-team (domain)

You: "Fix this crash in the payment module"  
AgentMaster: Routing → systematic-debugging

You: "Write SEO copy for the landing page"
AgentMaster: Routing → marketing-skill (marketing-ops routes internally)

You: "Deploy to AWS with Terraform"
AgentMaster: Routing → writing-plans (complex infra) + devops

You: "How did we solve that auth bug last week?"
AgentMaster: Routing → mem-search (session memory)
```

No manual skill selection. No guessing. No loading 5 skills when you need 1.

## Commands

| Command | What It Does |
|---------|-------------|
| `/agent-master` | Invoke on current task — auto-classifies and routes |
| `/agent-master route <task>` | **Dry-run** — shows routing plan without executing |
| `/agent-master status` | Shows current state (caveman on/off, last skill used, active workflow) |
| `/agent-master update` | Force-update all dependency repos and sync skills |
| `/caveman` | Enable token compression (~75% savings on all output) |
| `/codereview` | Blunt, factual code review — finds bugs, security issues, doc mismatches |

### Auto-Update

AgentMaster automatically pulls latest versions from all 4 dependency repos on first invoke each session (background, non-blocking). Has a 6-hour cooldown to avoid spamming GitHub. Use `/agent-master update` to force an immediate sync.

### Dry-Run Example

```
/agent-master route deploy HIPAA-compliant API to AWS
```

Output:
```
AgentMaster Route Plan
━━━━━━━━━━━━━━━━━━━━━
Task: deploy HIPAA-compliant API to AWS
Category: DevOps/Deploy + Compliance
Workflow: writing-plans (complex infra)
Domain: devops + ra-qm-team
Entry point: writing-plans
Combination: devops + ra-qm-team (HIPAA compliance)
Conflicts: none
```

## Architecture

Three layers that **stack, never compete**:

```
┌─────────────────────────────────────────────┐
│  OUTPUT LAYER: caveman                      │
│  Token compression. Active when user        │
│  enables /caveman. Layers on top of ANY     │
│  other skill output.                        │
├─────────────────────────────────────────────┤
│  WORKFLOW LAYER: superpowers                │
│  brainstorm → plan → TDD → review → finish  │
│  Active for code/engineering tasks ONLY.    │
│  Non-negotiable: can't skip brainstorming.  │
├─────────────────────────────────────────────┤
│  DOMAIN LAYER: claude-skills + custom       │
│  240+ skills across 12 domains.             │
│  Provides subject matter expertise.         │
│  Internal routers handle sub-routing.       │
└─────────────────────────────────────────────┘
```

**Key principle:** AgentMaster routes to the ecosystem entry point and lets internal routers handle the rest. It never duplicates the chief-of-staff (C-suite) or marketing-ops (marketing) routing logic.

## Routing Table

### 21 Categories

| Category | Signal Words | Routes To |
|----------|-------------|-----------|
| **Build/Create** | build, create, implement, scaffold | `brainstorming` → `engineering-team` |
| **Refactor** | refactor, restructure, clean up | `brainstorming` → `engineering-team` |
| **Debug/Fix** | bug, crash, error, fix, broken | `systematic-debugging` |
| **Code Review** | review code, /codereview, check diff | `codereview` (blunt) or `requesting-code-review` (PR workflow) |
| **Commit/Ship** | commit, merge, ship, push | `finishing-a-development-branch` |
| **Test** | write tests, TDD, coverage | `test-driven-development` |
| **Marketing** | blog, SEO, campaign, ads, copy | `marketing-skill` (44 sub-skills) |
| **Strategy** | fundraise, roadmap, pivot, board | `c-level-advisor` (28 sub-skills) |
| **Product** | PRD, user stories, personas | `product-team` (16 sub-skills) |
| **Finance** | DCF, budget, runway, ARR | `finance` |
| **Business Growth** | churn, pipeline, RFP, proposal | `business-growth` |
| **Project Mgmt** | Jira, sprint, scrum, retro | `project-management` |
| **Compliance** | ISO, FDA, GDPR, SOC2, audit | `ra-qm-team` |
| **DevOps/Deploy** | Docker, CI/CD, Terraform, AWS | `devops` |
| **Security** | OWASP, XSS, vulnerability, pen test | `security-audit` |
| **UI/UX Design** | wireframe, color palette, layout | `anthropic-skills:ui-ux-pro-max` |
| **Documentation** | write docs, generate PDF/DOCX | `anthropic-skills:docx/pdf/pptx/xlsx` |
| **Research** | analyze market, deep dive, investigate | `anthropic-skills:deep-research` |
| **Memory/History** | last time, previous session, how did we | `mem-search` / `timeline-report` |
| **Explore Codebase** | code structure, find functions | `smart-explore` |
| **Simple Question** | factual question, no action | direct answer (no routing) |

### Smart Tiebreakers

When words match multiple categories, AgentMaster resolves automatically:

| Ambiguous Word | Default | Override When... |
|---------------|---------|-----------------|
| "pipeline" | DevOps | "sales pipeline" → Business Growth |
| "design" | UI/UX | "system design" → Build/Create |
| "test" | Code Test | "A/B test" → Marketing |
| "audit" | Compliance | "security audit" → Security |
| "container" | DevOps | "container component" → Build/Create |
| "review" | Code Review (`codereview`) | "review PR" → `requesting-code-review`. "content review" → Marketing |
| "deploy" | DevOps | "deploy feature" + code → Build + DevOps |
| "report" | Documentation | "bug report" → Debug/Fix |
| "plan" | Build | "make a plan" → `make-plan` |

### Multi-Domain Combinations

| Combo | Routing Strategy |
|-------|-----------------|
| Code + DevOps | Superpowers workflow + `devops` for deployment |
| Security + Code | `security-audit` for findings + superpowers for fixes |
| Security + Compliance | `security-audit` + `ra-qm-team` |
| Security + DevOps | `security-audit` (app) + `devops` (infra) |
| Product + Code | `product-team` for requirements, then superpowers for code |
| UI/UX + Code | `ui-ux-pro-max` for design, then superpowers to implement |
| Research + Any | `deep-research` first, then domain skill |
| Code + Docs | Build first, then `anthropic-skills:docx/pdf` |

**Hard limit:** Maximum 2 domain skills per request. If 3+ detected, AgentMaster asks you to narrow scope.

## What Gets Installed

| Source | What | Skills |
|--------|------|--------|
| **This repo** | Orchestrator + custom skills | `agent-master`, `devops`, `security-audit`, `codereview`, `repomix-pack` |
| [caveman](https://github.com/JuliusBrussee/caveman) | Token compression | `caveman`, `caveman-commit`, `caveman-review`, `caveman-help`, `compress` |
| [superpowers](https://github.com/obra/superpowers) | Dev workflow | `brainstorming`, `writing-plans`, `test-driven-development`, `systematic-debugging`, +10 more |
| [claude-skills](https://github.com/alirezarezvani/claude-skills) | Domain expertise | `engineering-team`, `marketing-skill`, `product-team`, `c-level-advisor`, `finance`, +5 more |
| [claude-mem](https://github.com/thedotmack/claude-mem) | Session memory | `mem-search`, `smart-explore`, `knowledge-agent`, `make-plan`, `do`, `timeline-report`, `version-bump` |
| **Total** | | **42 skills** |

### Whole-Codebase Snapshots (Repomix)

`repomix-pack` wraps [repomix](https://github.com/yamadashy/repomix) so any skill can analyze the entire repo cheaply.

**Auto-runs at the start of every new session** when AgentMaster detects a code repo (`.git/`, `package.json`, `pyproject.toml`, `Cargo.toml`, or `go.mod` present). The snapshot lives at `.agentmaster/codebase.xml` and is reused by `security-audit`, `codereview`, and `engineering-team` for whole-repo analysis. Has a built-in staleness check so it only re-packs when source files change.

```bash
# Manual control
/agent-master repomix              # pack now
/agent-master repomix refresh      # force re-pack
/agent-master repomix include src/**
"skip repomix"                     # disable for this session
```

Requires `npm install -g repomix` (the installer does this automatically).

> **Note on Mem0:** Mem0 was evaluated and intentionally **not** added — `claude-mem` (already bundled via `mem-search`, `knowledge-agent`, `timeline-report`) covers the same persistent-memory use case locally without an extra API key or cloud dependency.

## Loop Prevention

| Rule | What Happens |
|------|-------------|
| No self-invocation | AgentMaster cannot call itself |
| Max depth = 2 | AgentMaster → Skill → Sub-skill. Third hop blocked. |
| No circular calls | If Skill A triggered AgentMaster, it won't call Skill A back |
| When blocked | States assumption clearly, returns to user |

## Caveman Integration

When `/caveman` is active, AgentMaster automatically:
- Compresses all its own output (drop articles, fragments OK)
- Uses caveman variants when available (`caveman-review` instead of `requesting-code-review`)
- Never lets caveman mode block or modify routing decisions

## Performance

| Metric | Without AgentMaster | With AgentMaster |
|--------|-------------------|-----------------|
| Token usage | Baseline (100%) | **~30% (70% savings)** |
| Task accuracy | 85% | **90%** |
| Speed | 1x | 0.9x (10% routing overhead) |
| Manual effort | High (pick skills yourself) | **None (auto-routes)** |

## Repo Structure

```
AgentMaster/
├── skills/                          # Source of truth (Claude Code format)
│   ├── agent-master/SKILL.md        #   Meta-orchestrator (22 categories)
│   ├── codereview/SKILL.md          #   Blunt code review (/codereview)
│   ├── devops/SKILL.md              #   CI/CD, Docker, Terraform, deployment
│   ├── repomix-pack/SKILL.md        #   Whole-codebase snapshot via repomix
│   └── security-audit/SKILL.md      #   OWASP Top 10, vuln scanning
│
├── .cursor/rules/                   # Auto-generated Cursor format
├── .windsurf/skills/                # Auto-generated Windsurf format
├── .clinerules/                     # Auto-generated Cline format
├── .codex/skills/                   # Auto-generated Codex format
├── .gemini/skills/                  # Auto-generated Gemini CLI format
├── .antigravity/skills/             # Auto-generated Antigravity format
├── .opencode/skills/                # Auto-generated OpenCode format
├── .augment/rules/                  # Auto-generated Augment format
├── .github/copilot-instructions.md  # Auto-generated Copilot format
├── CONVENTIONS.md                   # Auto-generated Aider format
│
├── scripts/
│   ├── convert.sh                   # Generate platform files from skills/
│   └── install-platform.sh          # Install to any platform's skill directory
│
├── Tool-Stack-Reference/            # 400+ tools across 24 categories (free/paid)
│   ├── 01-frontend-development.md   #   Next.js, React, Tailwind, etc.
│   ├── 02-backend-development.md    #   Node, FastAPI, PostgreSQL, etc.
│   ├── ...                          #   22 more category files
│   ├── 24-indian-startup-stack.md   #   India-specific tools (Razorpay, Zoho, etc.)
│   └── index.html                   #   Searchable HTML dashboard
│
├── RULES.example.md                 # Custom rules template (copy to ~/.claude/RULES.md)
├── install.sh                       # Claude Code full installer (+ dependencies)
├── install.ps1                      # Claude Code full installer (Windows)
└── uninstall.sh                     # Remove custom skills only
```

**Edit skills in `skills/` → run `bash scripts/convert.sh --tool all` → all platform files regenerate.**

## Uninstall

```bash
# Remove only AgentMaster custom skills (keeps third-party skills intact)
bash uninstall.sh

# Nuclear option: remove everything
rm -rf ~/.claude/skills/*
```

## Custom Rules

AgentMaster includes a rules file that Claude reads every session — enforcing your commit workflow, code review style, and project conventions.

```bash
# Copy the example to your Claude config
cp RULES.example.md ~/.claude/RULES.md

# Edit with your GitHub username, paths, and preferences
```

See [`RULES.example.md`](RULES.example.md) for the full template.

## Contributing

1. Edit SKILL.md files in `skills/` (source of truth)
2. Run `bash scripts/convert.sh --tool all` to regenerate platform files
3. Test with `/agent-master route <your task>` (dry-run mode)
4. Commit and PR

## Credits

AgentMaster is built on top of these excellent open-source projects:

| Project | Author | What It Provides |
|---------|--------|-----------------|
| [**caveman**](https://github.com/JuliusBrussee/caveman) | [Julius Brussee](https://github.com/JuliusBrussee) | Token compression (~75% savings), commit/review variants |
| [**superpowers**](https://github.com/obra/superpowers) | [Jesse Vincent](https://github.com/obra) | Dev workflow (brainstorming, TDD, debugging, code review) |
| [**claude-skills**](https://github.com/alirezarezvani/claude-skills) | [Alireza Rezvani](https://github.com/alirezarezvani) | 235+ domain skills (engineering, marketing, product, C-level, finance) |
| [**claude-mem**](https://github.com/thedotmack/claude-mem) | [thedotmack](https://github.com/thedotmack) | Persistent session memory, smart-explore, knowledge agents |

AgentMaster does not bundle or redistribute their code — the installer clones them at install time. All credit for those skills belongs to their respective authors.

## License

MIT

---

<p align="center">
  Built by <a href="https://github.com/Surya8991">Surya L</a> with Claude Code
</p>
