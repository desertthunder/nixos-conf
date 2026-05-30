---
title: Start Here
description: Setup paths for NixOS and non-Nix machines.
section: Start
weight: 1
---

This repo supports three setup paths:

1. macOS without Nix through Homebrew, portable dotfiles, SOPS/age, and `dotfiler`.
2. Ubuntu/Fedora through distro package managers, portable dotfiles, SOPS/age, and `dotfiler`.
3. NixOS through the repo flake and modules under `lib/nix/`.

Use `dotfiler --help` on non-Nix machines and `nixos-rebuild` on NixOS hosts.
