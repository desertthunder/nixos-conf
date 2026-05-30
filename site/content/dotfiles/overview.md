---
title: "Dotfiles"
description: "Portable shell, Git, terminal, and tool config shared by NixOS and non-Nix machines."
section: "Dotfiles"
weight: 100
---

Portable dotfiles live under `lib/dotfiles/`. Edit these files when user-level config should apply to more than one machine.

NixOS installs them through Home Manager. macOS, Ubuntu, and Fedora machines link them with `dotfiler` or the bootstrap scripts.

## Layout

```text
lib/dotfiles/
├── ghostty/.config/ghostty/config
├── git/.gitconfig
├── oh-my-posh/.config/oh-my-posh/theme.json
├── ripgrep/.config/ripgrep/config
├── zellij/.config/zellij/
└── zsh/.zshrc
```

## Install paths

| Source | Target |
| --- | --- |
| `lib/dotfiles/zsh/.zshrc` | `~/.zshrc` |
| `lib/dotfiles/git/.gitconfig` | `~/.gitconfig` |
| `lib/dotfiles/ghostty/.config/ghostty/config` | `~/.config/ghostty/config` |
| `lib/dotfiles/ripgrep/.config/ripgrep/config` | `~/.config/ripgrep/config` |
| `lib/dotfiles/zellij/.config/zellij` | `~/.config/zellij` |
| `lib/dotfiles/oh-my-posh/.config/oh-my-posh/theme.json` | `~/.config/oh-my-posh/theme.json` |

## Non-Nix install

Preview links before changing the machine:

```sh
dotfiler dotfiles plan
dotfiler --dry-run dotfiles apply
```

Apply links:

```sh
dotfiler dotfiles apply
```

`dotfiler` moves existing files into `~/.dotfiles-backup/<timestamp>/` before creating symlinks.

## NixOS install

Home Manager reads from `${root}/lib/dotfiles/...` in `lib/nix/modules/home-manager/home.nix`.

After editing `lib/dotfiles/`, rebuild the NixOS host:

```sh
sudo nixos-rebuild switch --flake .#$(hostname)
```

## Related

- [dotfiler usage](/dotfiles/dotfiler/)
- [Non-Nix bootstrap](/dotfiles/bootstrap/)
- [Package inventories](/dotfiles/packages/)
