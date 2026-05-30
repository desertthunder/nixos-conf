#!/usr/bin/env bash
# Name: install.sh
# Date: 2026-05-30
# Author: Owais Jamil
# Description: Builds and installs dotfiler, dottools, and site into ~/.local/bin and
# ensures the pi coding agent is installed with npm.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
APP_DIR="$REPO_ROOT/app"
BIN_DIR="$HOME/.local/bin"

mkdir -p "$BIN_DIR"

if ! command -v go >/dev/null 2>&1; then
  echo "Go is required to build dotfiler and dottools." >&2
  exit 1
fi

(
  cd "$APP_DIR"
  go build -o "$BIN_DIR/dotfiler" ./cmd/dotfiler
  go build -o "$BIN_DIR/dottools" ./cmd/dottools
  go build -o "$BIN_DIR/site" ./cmd/site
)

echo "installed $BIN_DIR/dotfiler"
echo "installed $BIN_DIR/dottools"
echo "installed $BIN_DIR/site"

if command -v npm >/dev/null 2>&1; then
  export npm_config_prefix="$HOME/.npm-global"
  mkdir -p "$npm_config_prefix"
  export PATH="$npm_config_prefix/bin:$PATH"

  if ! command -v pi >/dev/null 2>&1; then
    npm install --global @earendil-works/pi-coding-agent
    echo "installed pi coding agent"
  else
    echo "pi coding agent already available at $(command -v pi)"
  fi
else
  echo "npm is not available; skipping pi coding agent install" >&2
fi
