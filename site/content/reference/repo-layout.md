---
title: "Repository Layout"
description: "Where the app, Nix modules, portable dotfiles, package inventories, secrets, and site source live."
section: "Reference"
weight: 115
---

Reusable machine config lives under `lib/`. Tooling and docs stay at the top level.

```text
.
├── app/                  # Go CLIs: dotfiler, dottools, site
├── lib/
│   ├── dotfiles/         # Portable user config linked into $HOME
│   ├── nix/              # NixOS hosts, modules, and profiles
│   ├── packages/         # Homebrew, apt, and dnf inventories
│   └── secrets/          # SOPS-encrypted secrets
├── scripts/              # Bootstrap and maintenance shell scripts
├── site/                 # Static site source
├── dist/                 # Generated site output
├── flake.nix
└── flake.lock
```

## `app/`

Go commands live here:

| Command | Purpose |
| --- | --- |
| `dotfiler` | Non-Nix machine setup |
| `dottools` | Maintenance helpers |
| `site` | Static site build, preview, and Pagefind indexing |

## `lib/dotfiles/`

Portable user config: shell, Git, Ghostty, ripgrep, Zellij, and Oh My Posh files.

NixOS reads these through Home Manager. Non-Nix machines link them with `dotfiler dotfiles apply` or `scripts/bootstrap/link-dotfiles.sh`.

## `lib/nix/`

NixOS config is split into:

- `hosts/` for machine-specific config
- `modules/nixos/` for shared system config
- `modules/home-manager/` for user config
- `profiles/` for profile notes

The top-level `flake.nix` points at host files under `lib/nix/hosts/`.

## `lib/packages/`

Package inventories for non-Nix machines:

- Homebrew Brewfiles for macOS
- apt package list for Ubuntu/Debian
- dnf package list for Fedora

## `lib/secrets/`

Encrypted SOPS files. `.sops.yaml` matches `lib/secrets/*.yaml`.

## `site/`

Markdown content, Go templates, CSS, and vendored browser JavaScript for this documentation site.
