# Welcome

This site documents my NixOS workstation, dotfiles, editor setup, terminal
workflow, and the parts that can be reused outside NixOS.

The repo is written for two audiences:

- me, when I need to rebuild a machine or remember why something is configured a
  certain way
- anyone trying to copy pieces of the setup on NixOS, Fedora, Ubuntu, Debian, or
  another Linux distro

## What is here

- [Guides](./guides.md): common commands, checks, secrets, and migration notes
- [NixOS](./nixos.md): flake layout, rebuilds, hosts, and SOPS wiring
- [Programs](./programs.md): portable config notes for Ghostty, Zellij, Zed,
  Zathura, Neovim, Git, Zsh, Starship, ripgrep, and SSH
- [Other Distros](./other.md): how to recreate the working setup without NixOS
- [Tools](./tools.md): small command-line notes and scripts

## How to use it

If you are on NixOS, start with [NixOS](./nixos.md), then read
[Hosts](./hosts.md) and [Secrets](./secrets.md).

If you are not on NixOS, start with [Other Distros](./other.md). Then use the
program pages for the tools you want to copy.

If you are editing this repo, read [Development](./development.md) and
[Writing docs](./writing.md).

## Repo shape

```text
conf/
├── machines/      # host-specific NixOS config
├── modules/       # app config copied by Home Manager
├── secrets/       # SOPS-encrypted secrets
└── shared.nix     # shared NixOS and Home Manager modules

docs/src/          # mdBook source
shells/            # project shell helpers
```

The generated book lives in `docs/book/`. Edit `docs/src/` instead.
