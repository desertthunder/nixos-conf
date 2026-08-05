#!/bin/sh

set -eu

agent_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

mkdir -p "$HOME/.codex" "$HOME/.pi/agent"

case $(uname -s) in
  Darwin) codex_config="$agent_dir/codex/macos.config.toml" ;;
  *) codex_config="$agent_dir/codex/config.toml" ;;
esac

ln -sfn "$agent_dir/AGENTS.md" "$HOME/.codex/AGENTS.md"
ln -sfn "$codex_config" "$HOME/.codex/config.toml"
ln -sfn "$agent_dir/codex/cloudflare.config.toml" "$HOME/.codex/cloudflare.config.toml"
ln -sfn "$agent_dir/codex/extras.config.toml" "$HOME/.codex/extras.config.toml"
ln -sfn "$agent_dir/codex/full.config.toml" "$HOME/.codex/full.config.toml"
ln -sfn "$agent_dir/codex/handoff.config.toml" "$HOME/.codex/handoff.config.toml"
ln -sfn "$agent_dir/codex/media.config.toml" "$HOME/.codex/media.config.toml"
ln -sfn "$agent_dir/codex/hooks.json" "$HOME/.codex/hooks.json"
ln -sfn "$agent_dir/AGENTS.md" "$HOME/.pi/agent/AGENTS.md"
ln -sfn "$agent_dir/pi/settings.json" "$HOME/.pi/agent/settings.json"
