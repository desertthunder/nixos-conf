#!/bin/sh

set -eu

agent_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

mkdir -p "$HOME/.codex" "$HOME/.pi/agent"

ln -sfn "$agent_dir/AGENTS.md" "$HOME/.codex/AGENTS.md"
ln -sfn "$agent_dir/AGENTS.md" "$HOME/.pi/agent/AGENTS.md"
