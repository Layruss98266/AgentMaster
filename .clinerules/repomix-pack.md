
# Repomix Pack — Whole-Codebase Snapshot

You are the repomix bridge skill. Your job: produce a single compact file representing the current repo state, then hand off to the next skill in the chain.

ARGUMENTS: {{ARGUMENTS}}

## When to Use

Invoke this skill when ANY of these signal words appear:
- "entire codebase", "whole repo", "across the project", "all files"
- "full audit", "full security scan", "architecture review"
- "onboard me to this repo", "understand this codebase"
- "refactor X across the codebase", "find all usages of"
- Whenever `security-audit` or `codereview` is invoked on the repo as a whole (not a diff)

Do NOT use for:
- Single-file tasks (Read the file directly)
- Diff-based code review (use `codereview` on the diff)
- Targeted exploration (use `smart-explore` instead — AST-based, cheaper)

## Preflight Check

```bash
# 1. Confirm repomix is installed
which repomix || npm install -g repomix

# 2. Confirm we're in a git repo (repomix works best with one)
git rev-parse --show-toplevel 2>/dev/null || echo "WARN: not a git repo"
```

If `repomix` is missing and `npm` is unavailable, abort and tell the user: "Install Node + repomix: `npm install -g repomix`".

## Default Pack Command

```bash
# Pack to a stable path under the repo's .agentmaster/ dir
mkdir -p .agentmaster
repomix --style xml -o .agentmaster/codebase.xml \
  --ignore "**/node_modules/**,**/dist/**,**/build/**,**/.next/**,**/coverage/**,**/*.lock,**/*.log,**/.agentmaster/**,**/.git/**"
```

If a `.repomixignore` exists in the repo, repomix picks it up automatically — do not pass `--ignore` in that case.

## Argument Handling

| ARGUMENTS pattern | Action |
|-------------------|--------|
| empty | Pack the whole repo with default ignores (above) |
| `include <glob>` | `repomix --include "<glob>" -o .agentmaster/codebase.xml --style xml` |
| `remote <url>` | `repomix --remote <url> --style xml -o .agentmaster/codebase.xml` |
| `refresh` | Delete `.agentmaster/codebase.xml` first, then re-pack |
| `stdout` | Run `repomix --stdout --style xml` and stream directly into the next skill |

## Staleness Rule

Before re-packing, check if `.agentmaster/codebase.xml` is fresh enough:

```bash
# Skip re-pack if file exists AND newer than the most recently modified source file
if [ -f .agentmaster/codebase.xml ]; then
  newest=$(git ls-files | xargs -I{} stat -c '%Y' {} 2>/dev/null | sort -n | tail -1)
  packed=$(stat -c '%Y' .agentmaster/codebase.xml 2>/dev/null)
  if [ "$packed" -ge "$newest" ]; then
    echo "Pack is fresh, skipping."
    exit 0
  fi
fi
```

User can force a re-pack with `/agent-master repomix refresh`.

## Output

After packing, announce:

```
Repomix snapshot ready
━━━━━━━━━━━━━━━━━━━━━
File:   .agentmaster/codebase.xml
Size:   <bytes>
Files:  <count from repomix summary>
Tokens: <estimate from repomix summary>
```

Then **hand off** to the calling skill (security-audit, codereview, etc.). The calling skill should read `.agentmaster/codebase.xml` as its input rather than re-reading individual files.

## .gitignore Hygiene

On first run in a repo, append `.agentmaster/` to `.gitignore` if not already present:

```bash
grep -qxF '.agentmaster/' .gitignore 2>/dev/null || echo '.agentmaster/' >> .gitignore
```

## What This Skill Does NOT Do

- Does NOT analyze the code — that's the calling skill's job
- Does NOT call other skills directly — it returns control to AgentMaster
- Does NOT replace `smart-explore` for targeted lookups
- Does NOT pack on every invocation — uses staleness check
