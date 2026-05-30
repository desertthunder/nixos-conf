#!/usr/bin/env bash
##########################################################################
# Name: link-dotfiles.sh                                                 #
# Date: 2026-05-30                                                       #
# Author: Owais J.                                                       #
# Description: Symlinks this repo's portable dotfiles into the current   #
#              user's home directory, backing up existing files first.   #
##########################################################################

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DOTFILES_DIR="$REPO_ROOT/lib/dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

link_path() {
  local source="$1"
  local target="$2"

  if [[ ! -e "$source" ]]; then
    echo "missing source: $source" >&2
    return 1
  fi

  mkdir -p "$(dirname "$target")"

  if [[ -L "$target" ]]; then
    rm "$target"
  elif [[ -e "$target" ]]; then
    mkdir -p "$BACKUP_DIR/$(dirname "${target#$HOME/}")"
    mv "$target" "$BACKUP_DIR/${target#$HOME/}"
    echo "backed up $target"
  fi

  ln -s "$source" "$target"
  echo "linked $target -> $source"
}

link_path "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_path "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
link_path "$DOTFILES_DIR/ghostty/.config/ghostty/config" "$HOME/.config/ghostty/config"
link_path "$DOTFILES_DIR/ripgrep/.config/ripgrep/config" "$HOME/.config/ripgrep/config"
link_path "$DOTFILES_DIR/zellij/.config/zellij" "$HOME/.config/zellij"
link_path "$DOTFILES_DIR/oh-my-posh/.config/oh-my-posh/theme.json" "$HOME/.config/oh-my-posh/theme.json"
