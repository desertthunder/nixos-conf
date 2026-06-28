# Welcome

Hi! Welcome to the documentation site for my ([Owais](https://desertthunder.dev))
dotfiles & flakes. More specifically, my NixOS workstation, dotfiles, editor setup,
terminal workflow, and the parts that can be reused outside NixOS.

The repo is written for two audiences:

- me, when I need to rebuild a machine or remember why something is configured a
  certain way
- anyone trying to copy pieces of the setup on NixOS, Fedora, Ubuntu, Debian, or
  another Linux distro

![Hyprland desktop preview](./assets/images/desktop-hero.png)
<small>Hyprland + Ghostty with fastfetch on `nix-haxorus`</small>

## Summary

### What I Use

This is the working set behind the screenshot, not a full package inventory.
The deeper pages document the behavior worth remembering.

| Area       | Current choice                                                                    |
| ---------- | --------------------------------------------------------------------------------- |
| System     | [NixOS](./nixos.md) or Fedora, flakes, Home Manager, and host-specific modules.   |
| DE         | GNOME, [Hyprland](./programs/hyprland.md), or XFCE (machine dependent)            |
| Term       | [Ghostty](./programs/ghostty.md), usually running [Zellij](./programs/zellij.md). |
| Shell      | [Zsh](./programs/zsh.md) with [Starship](./programs/starship.md).                 |
| Editor     | [Neovim](./programs/neovim.md) & [Zed](./programs/zed.md) (vim-mode)              |
| Notes      | Neovim & [Obsidian](./programs/obsidian.md)                                       |
| Reading    | [Zathura](./programs/zathura.md) with a compact dark interface.                   |
| Networking | [Tailscale](./services/tailscale.md) for stable hostnames and private services.   |

### Entrypoints

- [Guides](./guides.md): common commands, checks, secrets, and migration notes
- [Nix Concepts](./concepts.md)
- [NixOS](./nixos.md): flakes, hosts, and SOPS
- [Programs](./programs.md): Dotfiles
- [Other Distros](./other.md): how to recreate the working setup without NixOS
- [Tools](./tools.md): small command-line notes and scripts

#### Guidelines

If you are on NixOS, start with [NixOS](./nixos.md), then read [Hosts](./hosts.md)
and [Secrets](./secrets.md).

If the underlying Nix ideas are unclear, read [Nix Concepts](./concepts.md).

If you are not on NixOS, start with [Other Distros](./other.md). Then use the
program pages for the tools you want to copy.

If you are editing this repo, read [Development](./development.md) and
[Writing docs](./writing.md).

## Structure

```text
conf/
├── machines/      # host-specific NixOS config
├── modules/       # app config and focused modules
├── secrets/       # SOPS-encrypted secrets
└── shared.nix     # shared NixOS and Home Manager modules

docs/src/          # This book's source (mdBook)
shells/            # project shell helpers
```
