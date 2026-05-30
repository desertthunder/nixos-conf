# Repo Organization Plan

This repo should support three setup paths:

1. Macs without Nix, such as this machine and the Mac mini
2. Ubuntu/Fedora machines
3. NixOS machines

Core principle:

> Portable dotfiles are canonical. NixOS installs them declaratively. Non-Nix machines install them with scripts. Secrets use SOPS + age everywhere.

## Goals

- [ ] Make non-Nix macOS a first-class use case
- [ ] Make Ubuntu/Fedora bootstrap possible without Home Manager
- [ ] Keep NixOS as the fully declarative path
- [ ] Reorganize site content around platform-specific setup paths
- [ ] Decide on dragon-type naming convention for machines, including the new Dell NixOS host

## Target Top-Level Structure

```text
.
├── app/                 # Go CLIs: dotfiler, dottools, site
├── lib/dotfiles/            # Canonical portable dotfiles
├── lib/nix/                 # NixOS hosts, modules, profiles
├── lib/packages/            # brew/apt/dnf package inventories
├── scripts/             # Standalone shell utilities and bootstrap scripts
├── lib/secrets/             # SOPS-encrypted secrets
├── site/                # Custom static site source
├── dist/                # Generated site output, gitignored
├── flake.nix
├── flake.lock
├── README.md
└── todo.md
```

## Phase 1: Migration and Inventory Cleanup

Mac Mini will use the non-Nix macOS path. ASDF has been removed completely, and the Brewfiles now represent the desired package inventory.

- [ ] Test Mac Mini bootstrap with `scripts/bootstrap/setup/mac.sh`
- [ ] Move package inventory material from README/site content into the reference section

## Phase 2: Restructure Site Content

Docs have been migrated from mdBook into the custom SSG under `site/content/`. Remaining work should refine the information architecture and links.

- [ ] Add or refine platform pages: macOS without Nix, Ubuntu/Fedora, NixOS
- [ ] Add or refine dotfiles pages: overview, layout, bootstrap
- [ ] Add or refine secrets pages: SOPS + age, non-Nix usage, sops-nix
- [ ] Add or refine program pages: Neovim, Zellij, Ghostty, Ripgrep, Zathura
- [ ] Move package inventory material into `site/content/reference/`
- [ ] Convert migrated relative Markdown links to stable site URLs
- [ ] Add front matter descriptions where migrated pages need better summaries

## Suggested Order of Work

1. [ ] Test Mac Mini bootstrap with `scripts/bootstrap/setup/mac.sh`
2. [ ] Clean up migration/package inventory content
3. [ ] Refine migrated `site/content/` information architecture and links

## Parking Lot

- Alias zellij layouts in zshrc
