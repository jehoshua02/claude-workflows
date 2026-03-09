#!/bin/bash
# Install claude-workflows commands by symlinking into ~/.claude/commands/workflow/

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/commands/workflow"
TARGET_DIR="$HOME/.claude/commands/workflow"

mkdir -p "$TARGET_DIR"

for file in "$SOURCE_DIR"/*.md; do
  name="$(basename "$file")"
  target="$TARGET_DIR/$name"

  if [ -L "$target" ]; then
    rm "$target"
  elif [ -e "$target" ]; then
    echo "Warning: $target exists and is not a symlink, skipping"
    continue
  fi

  ln -s "$file" "$target"
  echo "Linked $name"
done

echo "Done. Commands available as /workflow:<name> in Claude Code."
