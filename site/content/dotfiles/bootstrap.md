---
title: "Non-Nix Bootstrap"
description: "How to bring macOS, Ubuntu, or Fedora machines onto the portable dotfiles path."
section: "Dotfiles"
weight: 106
---

Non-Nix machines use the OS package manager, portable dotfiles, SOPS, and age. This path favors simple native tooling over Nix-style reproducibility.

## macOS

The macOS script builds `dotfiler`, installs Homebrew if needed, then runs package, dotfile, and secret checks.

```sh
scripts/bootstrap/setup/mac.sh
```

Manual equivalent:

```sh
cd app
go install ./cmd/dotfiler

dotfiler doctor
dotfiler packages apply
dotfiler dotfiles apply
dotfiler secrets check
```

## Ubuntu or Fedora

Build `dotfiler` and let it select `apt` or `dnf` from the host platform.

```sh
cd app
go install ./cmd/dotfiler

dotfiler doctor
dotfiler --dry-run apply
dotfiler apply
```

## Dotfiles only

If another tool manages packages:

```sh
dotfiler --dry-run dotfiles apply
dotfiler dotfiles apply
```

The shell linker is still available:

```sh
scripts/bootstrap/link-dotfiles.sh
```

## Secrets

Create or install an age key at:

```text
~/.config/sops/age/keys.txt
```

Check tooling and edit secrets:

```sh
dotfiler secrets check
dotfiler secrets edit
```

Extract SSH keys from `lib/secrets/owais.yaml`:

```sh
dotfiler secrets extract-ssh
```

`dotfiler` writes extracted keys to `~/.local/share/sops/` with `0600` permissions.
