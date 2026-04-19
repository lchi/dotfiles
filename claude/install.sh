#!/usr/bin/env bash
# Symlink Claude configs into ~/.claude
set -e

DOTFILES_CLAUDE="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

mkdir -p "$CLAUDE_DIR"

files=(CLAUDE.md settings.json statusline-command.sh)

for f in "${files[@]}"; do
  src="$DOTFILES_CLAUDE/$f"
  dst="$CLAUDE_DIR/$f"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "Backing up existing $dst -> $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -sf "$src" "$dst"
  echo "Linked $dst -> $src"
done
