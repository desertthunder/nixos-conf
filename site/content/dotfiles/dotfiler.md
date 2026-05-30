---
title: "dotfiler Usage"
description: "Command reference for the non-Nix setup orchestrator used on macOS, Ubuntu, and Fedora."
section: "Dotfiles"
weight: 105
---

`dotfiler` is the Go CLI for machines that do not run NixOS. It detects the host platform, installs packages with the native package manager, links files from `lib/dotfiles/`, and checks or extracts SOPS secrets.

## Global flags

| Flag | Purpose |
| --- | --- |
| `--dry-run` | Print changes without applying them |
| `-v`, `--verbose` | Include caller information and debug logs |

## Common flow

```sh
dotfiler doctor
dotfiler plan
dotfiler --dry-run apply
dotfiler apply
```

## Commands

| Command | Purpose |
| --- | --- |
| `dotfiler doctor` | Show OS, arch, distro, package manager, and required tools |
| `dotfiler plan` | Print the setup plan without changing the machine |
| `dotfiler apply` | Run packages, dotfiles, and secret checks |
| `dotfiler apply --only packages` | Install platform packages only |
| `dotfiler apply --only dotfiles` | Link portable dotfiles only |
| `dotfiler apply --only secrets` | Extract SSH secrets only |
| `dotfiler packages plan` | Show the selected package manager and inventory files |
| `dotfiler packages apply` | Install packages from `lib/packages/` |
| `dotfiler dotfiles plan` | Show dotfile source and target paths |
| `dotfiler dotfiles apply` | Create symlinks, backing up existing files first |
| `dotfiler secrets check` | Check `sops`, `age`, and age key availability |
| `dotfiler secrets edit` | Edit `lib/secrets/owais.yaml` with SOPS |
| `dotfiler secrets extract-ssh` | Extract configured SSH keys to `~/.local/share/sops/` |

## Platform detection

`dotfiler` supports macOS, Ubuntu/Debian, and Fedora-style systems.

| Platform | Package manager | Inventory |
| --- | --- | --- |
| macOS | Homebrew | `lib/packages/brew/Brewfile.common` plus host-specific Brewfiles |
| Ubuntu/Debian | apt | `lib/packages/apt/packages.txt` |
| Fedora | dnf | `lib/packages/dnf/packages.txt` |

## Secrets behavior

`dotfiler secrets edit` and `dotfiler secrets extract-ssh` set `SOPS_AGE_KEY_FILE`. If the environment variable is unset, they use:

```text
~/.config/sops/age/keys.txt
```
