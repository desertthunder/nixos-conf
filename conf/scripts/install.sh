#!/bin/sh
# Installs the Python commands in this directory into ~/.local/bin. Uses uv when
# it is available, and otherwise builds a virtual environment from the pinned
# requirements.txt.

set -eu

dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

if command -v uv >/dev/null 2>&1; then
  uv tool install --force --editable "$dir"
  exit 0
fi

venv="$HOME/.local/share/dotscripts"
python3 -m venv "$venv"
"$venv/bin/pip" install --quiet -r "$dir/requirements.txt" -e "$dir"
mkdir -p "$HOME/.local/bin"
ln -sf "$venv/bin/dots" "$HOME/.local/bin/dots"
echo "installed dots into $HOME/.local/bin"
