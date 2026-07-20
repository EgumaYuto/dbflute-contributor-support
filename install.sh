#!/usr/bin/env bash
# Symlink this repo's skills into ~/.claude/skills/ so `git pull` keeps them current.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

mkdir -p "$DEST"

for skill in "$REPO_DIR"/skills/*/; do
  name="$(basename "$skill")"
  target="$DEST/$name"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "skip  $name (a real directory already exists at $target)"
    continue
  fi
  ln -sfn "$skill" "$target"
  echo "link  $target -> $skill"
done

echo
echo "Done. Restart Claude Code to pick up new skills."
