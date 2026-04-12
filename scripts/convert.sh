#!/bin/bash
# AgentMaster Multi-Platform Converter
# Converts SKILL.md files to platform-specific formats
#
# Usage:
#   bash scripts/convert.sh --tool cursor|windsurf|cline|codex|gemini|antigravity|augment|opencode|aider|copilot|all

set -e

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "Usage: bash scripts/convert.sh --tool <platform|all>"
  echo "Converts skills/ to platform-specific formats."
  echo "Platforms: cursor, windsurf, cline, codex, gemini, antigravity, opencode, augment, aider, copilot, all"
  exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
SKILLS_DIR="$REPO_DIR/skills"

# Parse arguments
TOOL="${1#--tool=}"
TOOL="${TOOL#--tool }"
[ "$1" = "--tool" ] && TOOL="$2"
[ -z "$TOOL" ] && TOOL="all"

# Extract YAML frontmatter field
extract_field() {
  local file="$1" field="$2"
  sed -n '/^---$/,/^---$/p' "$file" | grep "^${field}:" | sed "s/^${field}:[[:space:]]*//" | sed 's/^"\(.*\)"$/\1/' | head -1
}

# Extract body (everything after second ---)
extract_body() {
  local file="$1"
  awk 'BEGIN{c=0} /^---$/{c++; next} c>=2{print}' "$file"
}

# Process each skill
for skill_dir in "$SKILLS_DIR"/*/; do
  [ ! -f "$skill_dir/SKILL.md" ] && continue
  skill_name=$(basename "$skill_dir")
  skill_file="$skill_dir/SKILL.md"

  name=$(extract_field "$skill_file" "name")
  desc=$(extract_field "$skill_file" "description")
  body=$(extract_body "$skill_file")

  echo "Converting: $skill_name"

  # ---- Claude Code (source format, already correct) ----

  # ---- Cursor (.mdc rules) ----
  if [ "$TOOL" = "cursor" ] || [ "$TOOL" = "all" ]; then
    mkdir -p "$REPO_DIR/.cursor/rules"
    cat > "$REPO_DIR/.cursor/rules/${skill_name}.mdc" <<CURSOR_EOF
---
description: "${desc}"
globs:
alwaysApply: false
---
$body
CURSOR_EOF
    echo "  + .cursor/rules/${skill_name}.mdc"
  fi

  # ---- Windsurf ----
  if [ "$TOOL" = "windsurf" ] || [ "$TOOL" = "all" ]; then
    mkdir -p "$REPO_DIR/.windsurf/skills/${skill_name}"
    cat > "$REPO_DIR/.windsurf/skills/${skill_name}/SKILL.md" <<WINDSURF_EOF
---
name: "${name}"
description: "${desc}"
trigger: always_on
---
$body
WINDSURF_EOF
    echo "  + .windsurf/skills/${skill_name}/SKILL.md"
  fi

  # ---- Cline (.clinerules) ----
  if [ "$TOOL" = "cline" ] || [ "$TOOL" = "all" ]; then
    mkdir -p "$REPO_DIR/.clinerules"
    echo "$body" > "$REPO_DIR/.clinerules/${skill_name}.md"
    echo "  + .clinerules/${skill_name}.md"
  fi

  # ---- Codex (OpenAI) ----
  if [ "$TOOL" = "codex" ] || [ "$TOOL" = "all" ]; then
    mkdir -p "$REPO_DIR/.codex/skills/${skill_name}"
    cp "$skill_file" "$REPO_DIR/.codex/skills/${skill_name}/SKILL.md"
    echo "  + .codex/skills/${skill_name}/SKILL.md"
  fi

  # ---- Gemini CLI ----
  if [ "$TOOL" = "gemini" ] || [ "$TOOL" = "all" ]; then
    mkdir -p "$REPO_DIR/.gemini/skills/${skill_name}"
    cp "$skill_file" "$REPO_DIR/.gemini/skills/${skill_name}/SKILL.md"
    echo "  + .gemini/skills/${skill_name}/SKILL.md"
  fi

  # ---- Antigravity ----
  if [ "$TOOL" = "antigravity" ] || [ "$TOOL" = "all" ]; then
    mkdir -p "$REPO_DIR/.antigravity/skills/${skill_name}"
    cat > "$REPO_DIR/.antigravity/skills/${skill_name}/SKILL.md" <<ANTI_EOF
---
name: "${name}"
description: "${desc}"
risk: low
source: community
date_added: $(date +%Y-%m-%d)
---
$body
ANTI_EOF
    echo "  + .antigravity/skills/${skill_name}/SKILL.md"
  fi

  # ---- OpenCode ----
  if [ "$TOOL" = "opencode" ] || [ "$TOOL" = "all" ]; then
    mkdir -p "$REPO_DIR/.opencode/skills/${skill_name}"
    cat > "$REPO_DIR/.opencode/skills/${skill_name}/SKILL.md" <<OC_EOF
---
name: "${name}"
description: "${desc}"
compatibility: opencode
---
$body
OC_EOF
    echo "  + .opencode/skills/${skill_name}/SKILL.md"
  fi

  # ---- Augment ----
  if [ "$TOOL" = "augment" ] || [ "$TOOL" = "all" ]; then
    mkdir -p "$REPO_DIR/.augment/rules"
    cat > "$REPO_DIR/.augment/rules/${skill_name}.md" <<AUG_EOF
---
type: auto
description: "${desc}"
---
$body
AUG_EOF
    echo "  + .augment/rules/${skill_name}.md"
  fi

  # ---- Aider (appends to CONVENTIONS.md) ----
  if [ "$TOOL" = "aider" ] || [ "$TOOL" = "all" ]; then
    if [ ! -f "$REPO_DIR/CONVENTIONS.md" ] || ! grep -q "## ${name}" "$REPO_DIR/CONVENTIONS.md" 2>/dev/null; then
      cat >> "$REPO_DIR/CONVENTIONS.md" <<AIDER_EOF

---

## ${name}
> ${desc}

$body
AIDER_EOF
      echo "  + CONVENTIONS.md (appended ${skill_name})"
    fi
  fi

  # ---- GitHub Copilot (appends to copilot-instructions.md) ----
  if [ "$TOOL" = "copilot" ] || [ "$TOOL" = "all" ]; then
    mkdir -p "$REPO_DIR/.github"
    if [ ! -f "$REPO_DIR/.github/copilot-instructions.md" ] || ! grep -q "## ${name}" "$REPO_DIR/.github/copilot-instructions.md" 2>/dev/null; then
      cat >> "$REPO_DIR/.github/copilot-instructions.md" <<COPILOT_EOF

## ${name}
${desc}

$body
COPILOT_EOF
      echo "  + .github/copilot-instructions.md (appended ${skill_name})"
    fi
  fi

done

echo ""
echo "Conversion complete for: $TOOL"
echo "Platform files generated in repo root."
