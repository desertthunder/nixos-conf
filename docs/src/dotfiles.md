# Dotfiles

This repo can be used as a dotfile source outside NixOS, but only selected
pieces are portable. Prefer copying app-native config directories and using
[Secrets](./secrets.md) for key extraction.

| Config | Portable source |
| ------ | --------------- |
| Zellij | `conf/modules/zellij` |
| Fastfetch | `conf/modules/fastfetch` |
| Starship | `conf/modules/starship.toml` |
| Zathura | `conf/modules/zathura/zathurarc` |
| Neovim | `github:desertthunder/nvim` |
| SSH keys | `conf/scripts/keys.sh` plus SOPS age key |

Avoid copying generated Home Manager outputs directly. Copy source config, then
let the target machine own package installation and service management.
