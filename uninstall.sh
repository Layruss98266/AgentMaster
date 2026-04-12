#!/bin/bash
# AgentMaster Uninstaller — removes only custom skills (agent-master, devops, security-audit)
# Does NOT remove third-party skills (caveman, superpowers, claude-skills, claude-mem)

SKILLS_DIR="$HOME/.claude/skills"

echo "Removing AgentMaster custom skills..."
for skill in agent-master devops security-audit; do
  if [ -d "$SKILLS_DIR/$skill" ]; then
    rm -rf "$SKILLS_DIR/$skill"
    echo "  - $skill"
  fi
done

echo ""
echo "AgentMaster custom skills removed."
echo "Third-party skills (caveman, superpowers, claude-skills, claude-mem) left intact."
echo "To remove everything: rm -rf $SKILLS_DIR/*"
