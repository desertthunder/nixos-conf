#!/bin/sh

set -eu

agent_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

mkdir -p "$HOME/.codex" "$HOME/.pi/agent" "$HOME/.claude"

ln -sfn "$agent_dir/AGENTS.md" "$HOME/.codex/AGENTS.md"
ln -sfn "$agent_dir/AGENTS.md" "$HOME/.pi/agent/AGENTS.md"
ln -sfn "$agent_dir/AGENTS.md" "$HOME/.claude/CLAUDE.md"
ln -sfn "$agent_dir/skills" "$HOME/.claude/skills"
ln -sfn "$agent_dir/claude-settings.json" "$HOME/.claude/settings.json"
ln -sfn "$agent_dir/claude-statusline.sh" "$HOME/.claude/statusline.sh"
