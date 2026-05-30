#!/usr/bin/env bash
# Name: mac.sh
# Date: 2026-05-30
# Author: Owais Jamil
# Description: Bootstraps a non-Nix macOS machine with Homebrew, dotfiler, packages, dotfiles, and SOPS checks.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "mac.sh must be run on macOS." >&2
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed. Install it first:"
  echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  exit 1
fi

"$REPO_ROOT/scripts/bootstrap/install.sh"
"$HOME/.local/bin/dotfiler" doctor
"$HOME/.local/bin/dotfiler" packages apply
"$HOME/.local/bin/dotfiler" dotfiles apply
"$HOME/.local/bin/dotfiler" secrets check
