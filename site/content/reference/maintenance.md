---
title: "Daily Maintenance"
description: "Common update, validation, secret editing, dotfile linking, and site publishing tasks."
section: "Reference"
weight: 125
---

Use this checklist for routine repo work.

## NixOS rebuild

```sh
nix flake check
sudo nixos-rebuild switch --flake .#$(hostname)
```

For a named host:

```sh
sudo nixos-rebuild switch --flake .#owais-nix-thinkpad
sudo nixos-rebuild switch --flake .#owais-nix-hp
sudo nixos-rebuild switch --flake .#owais-nix-dell
```

## Update flake inputs

```sh
nix flake update
nix flake check
```

Update one input:

```sh
nix flake lock --update-input nixpkgs
```

## Non-Nix machines

```sh
dotfiler doctor
dotfiler --dry-run apply
dotfiler apply
```

Limit the run to one area:

```sh
dotfiler apply --only packages
dotfiler apply --only dotfiles
dotfiler apply --only secrets
```

## Edit secrets

```sh
dotfiler secrets edit
```

Or run SOPS directly:

```sh
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops lib/secrets/owais.yaml
```

After changing secrets for NixOS, rebuild the host. After changing secrets for non-Nix machines, extract keys if needed:

```sh
dotfiler secrets extract-ssh
```

## Update Neovim docs source

The Neovim pages describe [neovim-conf](https://github.com/desertthunder/nvim). After changing that repo, update `site/content/programs/neovim/`.

## Build the docs site

Build HTML and assets only:

```sh
site build --static
```

Build and run the Pagefind index:

```sh
site build
```

Preview locally:

```sh
site preview
```

## Clean generated output

```sh
site clean
```
