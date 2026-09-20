# Welcome

Hi! Welcome to the documentation site for my ([Owais](https://desertthunder.dev))
dotfiles & flakes. More specifically, my NixOS workstation, dotfiles, editor setup,
terminal workflow, and the parts that can be reused outside NixOS.

The repo is written for two audiences:

- me, when I need to rebuild a machine or remember why something is configured a
  certain way
- anyone trying to copy pieces of the setup on NixOS, Fedora, Ubuntu, Debian, or
  another Linux distro

## Summary

### What I use

The working set, not a full package inventory. The program pages cover the
settings and failure modes I think are worth remembering.

| Area       | Current choice                                                                     |
| ---------- | ---------------------------------------------------------------------------------- |
| System     | [NixOS](./nixos.md) or Fedora, flakes, Home Manager, and host-specific modules     |
| Desktop    | GNOME, or [Umbriel](./programs/umbriel.md) with [Noctalia](./programs/noctalia.md) |
| Terminal   | [Ghostty](./programs/ghostty.md), usually running [Zellij](./programs/zellij.md)   |
| Shell      | [Zsh](./programs/zsh.md) with [Starship](./programs/starship.md)                   |
| Editor     | [Neovim](./programs/neovim.md) and [Zed](./programs/zed.md) in vim mode            |
| Notes      | Neovim and [Obsidian](./programs/obsidian.md)                                      |
| Reading    | [Zathura](./programs/zathura.md) with a compact dark interface                     |
| Networking | [Tailscale](./services/tailscale.md) for stable hostnames and private services     |

### Entrypoints

- [Guides](./guides.md): common commands, checks, secrets, and migration notes
- [Nix concepts](./concepts.md): flakes, modules, and the language itself
- [NixOS](./nixos.md): hosts, rebuilds, and SOPS
- [Programs](./programs.md): per-application config and dotfiles
- [Other distros](./other.md): how to recreate the setup without NixOS
- [Tools](./tools.md): small command-line notes and scripts

### Where to start

If you are on NixOS, start with [NixOS](./nixos.md), then read [Hosts](./hosts.md)
and [Secrets](./secrets.md).

If the underlying Nix ideas are unclear, read [Nix concepts](./concepts.md).

If you are not on NixOS, start with [Other distros](./other.md). Then use the
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
