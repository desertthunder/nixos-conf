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
| Codex and Pi | `conf/agent`                             |

Avoid copying generated Home Manager outputs directly. Copy source config, then
let the target machine own package installation and service management.

Codex and Pi are the exception: `conf/agent/link-global-configs.sh` creates
writable symlinks from their global config paths back to this repository. This
keeps instructions and token-use defaults consistent without copying files.
