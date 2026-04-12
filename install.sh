#!/bin/bash
# AgentMaster Installer
# Copies custom skills to ~/.claude/skills/ and clones dependency repos

set -e

SKILLS_DIR="$HOME/.claude/skills"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "AgentMaster Installer v1.0"
echo "=========================="
echo ""

# Create skills directory
mkdir -p "$SKILLS_DIR"

# 1. Install custom skills (agent-master, devops, security-audit)
echo "[1/5] Installing custom skills..."
for skill_dir in "$SCRIPT_DIR/skills/"*/; do
  skill_name=$(basename "$skill_dir")
  if [ -f "$skill_dir/SKILL.md" ]; then
    cp -r "$skill_dir" "$SKILLS_DIR/$skill_name"
    echo "  + $skill_name"
  fi
done

# 2. Clone and install caveman (token compression)
echo ""
echo "[2/5] Installing caveman (token compression)..."
if [ ! -d "$SKILLS_DIR/caveman" ]; then
  TMP=$(mktemp -d)
  git clone --depth 1 https://github.com/JuliusBrussee/caveman.git "$TMP" 2>/dev/null
  cp -r "$TMP/skills/"* "$SKILLS_DIR/"
  rm -rf "$TMP"
  echo "  + caveman, caveman-commit, caveman-review, caveman-help, compress"
else
  echo "  ~ caveman already installed, skipping"
fi

# 3. Clone and install superpowers (dev workflow)
echo ""
echo "[3/5] Installing superpowers (dev workflow)..."
if [ ! -d "$SKILLS_DIR/brainstorming" ]; then
  TMP=$(mktemp -d)
  git clone --depth 1 https://github.com/obra/superpowers.git "$TMP" 2>/dev/null
  cp -r "$TMP/skills/"* "$SKILLS_DIR/"
  rm -rf "$TMP"
  echo "  + brainstorming, writing-plans, test-driven-development, systematic-debugging, ..."
else
  echo "  ~ superpowers already installed, skipping"
fi

# 4. Clone and install claude-skills (domain expertise)
echo ""
echo "[4/5] Installing claude-skills (domain expertise)..."
if [ ! -d "$SKILLS_DIR/engineering-team" ]; then
  TMP=$(mktemp -d)
  git clone --depth 1 https://github.com/alirezarezvani/claude-skills.git "$TMP" 2>/dev/null
  for dir in "$TMP/"*/; do
    if [ -f "$dir/SKILL.md" ]; then
      basename_dir=$(basename "$dir")
      cp -r "$dir" "$SKILLS_DIR/$basename_dir"
    fi
  done
  rm -rf "$TMP"
  echo "  + engineering-team, marketing-skill, product-team, c-level-advisor, ..."
else
  echo "  ~ claude-skills already installed, skipping"
fi

# 5. Install claude-mem (session memory) - skills only
echo ""
echo "[5/5] Installing claude-mem skills (session memory)..."
if [ ! -d "$SKILLS_DIR/mem-search" ]; then
  TMP=$(mktemp -d)
  git clone --depth 1 https://github.com/thedotmack/claude-mem.git "$TMP" 2>/dev/null
  cp -r "$TMP/plugin/skills/"* "$SKILLS_DIR/"
  rm -rf "$TMP"
  echo "  + mem-search, smart-explore, knowledge-agent, make-plan, do, timeline-report, version-bump"
else
  echo "  ~ claude-mem skills already installed, skipping"
fi

# Done
echo ""
echo "=========================="
echo "AgentMaster installed!"
echo ""
echo "Skills installed to: $SKILLS_DIR"
echo "Total skills: $(ls -d "$SKILLS_DIR/"*/ 2>/dev/null | wc -l)"
echo ""
echo "Usage:"
echo "  /agent-master              - invoke orchestrator"
echo "  /agent-master route <task> - dry-run routing"
echo "  /agent-master status       - show current state"
echo "  /caveman                   - enable token compression"
echo ""
echo "Start a new Claude Code session to load all skills."
