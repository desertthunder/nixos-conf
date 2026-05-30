---
title: "Package Inventories"
description: "How Homebrew, apt, and dnf package lists are organized for non-Nix machines."
section: "Dotfiles"
weight: 107
---

Package inventories live under `lib/packages/`. The files stay close to each package manager's native format.

## Layout

```text
lib/packages/
├── apt/packages.txt
├── brew/Brewfile.common
├── brew/Brewfile.mac-mini
├── brew/Brewfile.macbook-air
└── dnf/packages.txt
```

## Homebrew

macOS uses `brew bundle`.

`dotfiler packages apply` reads the common Brewfile first:

```text
lib/packages/brew/Brewfile.common
```

If a host-specific Brewfile exists, `dotfiler` applies it next:

```text
lib/packages/brew/Brewfile.<lowercase-hostname>
```

Example:

```sh
brew bundle --file lib/packages/brew/Brewfile.common
brew bundle --file lib/packages/brew/Brewfile.mac-mini
```

## apt and dnf

Linux package lists use one package name per line. Blank lines and comments are ignored.

```text
lib/packages/apt/packages.txt
lib/packages/dnf/packages.txt
```

`dotfiler` installs them with:

```sh
sudo apt-get install -y ...
sudo dnf install -y ...
```

## Review before install

```sh
dotfiler packages plan
dotfiler --dry-run packages apply
```

## What belongs here

Add packages expected on non-Nix machines:

- package manager helpers
- SOPS and age
- shell and terminal utilities
- editors and developer tools not managed elsewhere

NixOS system packages belong in `lib/nix/modules/` or host configs.
