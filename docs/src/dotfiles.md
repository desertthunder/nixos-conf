# Dotfiles

This repo can be used as a dotfile source outside NixOS, but only selected
pieces are portable. Prefer copying app-native config directories and using
[Secrets](./secrets.md) for key extraction.

| Config       | Portable source                          |
| ------------ | ---------------------------------------- |
| Zellij       | `conf/modules/zellij`                    |
| Fastfetch    | `conf/modules/fastfetch`                 |
| Starship     | `conf/modules/starship.toml`             |
| Zathura      | `conf/modules/zathura/zathurarc`         |
| Neovim       | `github:desertthunder/nvim`              |
| SSH keys     | `conf/scripts/keys.sh` plus SOPS age key |

Avoid copying generated Home Manager outputs directly. Copy source config, then
let the target machine own package installation and service management.

Reusable agent instructions and skills live under `conf/agent`. Codex and Pi
settings live in their native global directories because they contain
machine-specific paths and application state. See [Agent Skills](./agent-skills.md)
for the split and the reconstruction notes.
