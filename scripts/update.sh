#!/bin/bash
# AgentMaster Auto-Updater
# Pulls latest from all dependency repos and syncs skills
# Designed to run in background on session start
#
# Usage:
#   bash scripts/update.sh              # foreground
#   bash scripts/update.sh --quiet      # suppress output (background mode)

set -e

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "Usage: bash scripts/update.sh [--quiet]"
  echo "Pulls latest from all dependency repos and syncs skills to ~/.claude/skills/"
  echo "  --quiet   Suppress output (for background mode)"
  exit 0
fi

SKILLS_DIR="$HOME/.claude/skills"
CACHE_DIR="$HOME/.claude/.agentmaster-cache"
LOCK_FILE="$CACHE_DIR/.update-lock"
LAST_UPDATE_FILE="$CACHE_DIR/.last-update"
QUIET="${1:-}"

log() { [ "$QUIET" != "--quiet" ] && echo "$@" || true; }

# Prevent concurrent updates
if [ -f "$LOCK_FILE" ]; then
  lock_age=$(( $(date +%s) - $(date -r "$LOCK_FILE" +%s 2>/dev/null || echo 0) ))
  if [ "$lock_age" -lt 300 ]; then
    log "Update already running. Skipping."
    exit 0
  fi
  rm -f "$LOCK_FILE"
fi

# Skip if updated within last 6 hours
mkdir -p "$CACHE_DIR"
if [ -f "$LAST_UPDATE_FILE" ]; then
  last=$(cat "$LAST_UPDATE_FILE" 2>/dev/null || echo 0)
  now=$(date +%s)
  diff=$(( now - last ))
  if [ "$diff" -lt 21600 ]; then
    log "Updated $(( diff / 3600 ))h ago. Skipping (6h cooldown)."
    exit 0
  fi
fi

touch "$LOCK_FILE"
trap 'rm -f "$LOCK_FILE"' EXIT

log "AgentMaster: Checking for skill updates..."

update_repo() {
  local name="$1" repo_url="$2" skill_source="$3"
  local cache_path="$CACHE_DIR/$name"

  if [ -d "$cache_path/.git" ]; then
    # Pull latest (use git -C to avoid cd + set -e interaction)
    local before=$(git -C "$cache_path" rev-parse HEAD 2>/dev/null || echo "none")
    git -C "$cache_path" pull --ff-only --quiet 2>/dev/null || git -C "$cache_path" fetch --quiet 2>/dev/null
    local after=$(git -C "$cache_path" rev-parse HEAD 2>/dev/null || echo "none")

    if [ "$before" = "$after" ]; then
      log "  $name: up to date"
      return 0
    fi
    log "  $name: updated ($before -> $after)"
  else
    # Fresh clone
    log "  $name: cloning..."
    rm -rf "$cache_path"
    git clone --depth 1 --quiet "$repo_url" "$cache_path" 2>/dev/null
  fi

  # Sync skills
  local src="$cache_path/$skill_source"
  if [ -d "$src" ]; then
    for skill_dir in "$src"/*/; do
      [ ! -d "$skill_dir" ] && continue
      local skill_name=$(basename "$skill_dir")
      # Only copy if SKILL.md exists (for claude-skills repo) or always (for others)
      if [ -f "$skill_dir/SKILL.md" ] || [ "$skill_source" = "skills" ]; then
        cp -r "$skill_dir" "$SKILLS_DIR/$skill_name" 2>/dev/null || true
      fi
    done
  fi

  return 0
}

mkdir -p "$SKILLS_DIR"

# Update each dependency repo
update_repo "caveman" \
  "https://github.com/JuliusBrussee/caveman.git" \
  "skills"

update_repo "superpowers" \
  "https://github.com/obra/superpowers.git" \
  "skills"

update_repo "claude-skills" \
  "https://github.com/alirezarezvani/claude-skills.git" \
  "."

update_repo "claude-mem" \
  "https://github.com/thedotmack/claude-mem.git" \
  "plugin/skills"

# Update AgentMaster itself
if [ -d "$CACHE_DIR/agent-master/.git" ]; then
  local_before=$(git -C "$CACHE_DIR/agent-master" rev-parse HEAD 2>/dev/null || echo "none")
  git -C "$CACHE_DIR/agent-master" pull --ff-only --quiet 2>/dev/null || true
  local_after=$(git -C "$CACHE_DIR/agent-master" rev-parse HEAD 2>/dev/null || echo "none")
  if [ "$local_before" != "$local_after" ]; then
    cp -r "$CACHE_DIR/agent-master/skills/"* "$SKILLS_DIR/" 2>/dev/null || true
    log "  agent-master: self-updated"
  else
    log "  agent-master: up to date"
  fi
else
  git clone --depth 1 --quiet "https://github.com/Surya8991/AgentMaster.git" "$CACHE_DIR/agent-master" 2>/dev/null || true
  cp -r "$CACHE_DIR/agent-master/skills/"* "$SKILLS_DIR/" 2>/dev/null || true
  log "  agent-master: installed from remote"
fi

# Record update timestamp
date +%s > "$LAST_UPDATE_FILE"

log ""
log "All skills synced. Total: $(ls -d "$SKILLS_DIR/"*/ 2>/dev/null | wc -l) skills"
