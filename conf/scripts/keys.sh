#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SECRETS_FILE="$REPO_ROOT/conf/secrets/owais.yaml"
DEST="$HOME/.local/share/sops"
SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"
export SOPS_AGE_KEY_FILE

mkdir -p "$DEST"

for key in keys_gh keys_codeberg keys_tangled; do
  [[ -L "$DEST/$key" ]] && rm "$DEST/$key"
  sops --extract "[\"$key\"]" -d "$SECRETS_FILE" > "$DEST/$key"
  chmod 600 "$DEST/$key"
  echo "wrote $DEST/$key"
done
