---
title: "NixOS Configuration"
description: "An overview of the flake, host modules, Home Manager layer, and NixOS maintenance flow."
section: "Nix"
weight: 160
---

Declarative system configuration using Nix flakes with Home Manager integration.

## Structure

- **Flake**: `flake.nix` - Entry point defining inputs and outputs
- **NixOS Modules**: `lib/nix/modules/nixos/` - Common NixOS system settings
- **Host Configs**: `lib/nix/hosts/{hostname}/configuration.nix` - Host-specific settings
- **Home Manager Modules**: `lib/nix/modules/home-manager/` - User environment and dotfile management
- **Hardware**: `lib/nix/hosts/{hostname}/hardware-configuration.nix` - Hardware-specific settings per machine
- **SOPS Config**: `lib/nix/modules/nixos/sops.nix` - System-level secrets management
- **SOPS Home**: `lib/nix/modules/home-manager/sops.nix` - User-level secrets management
- **SSH Config**: `lib/nix/modules/home-manager/ssh-config.nix` - SSH configuration with SOPS-managed keys
- **Secrets**: `lib/secrets/owais.yaml` - Encrypted secrets file

## Key Features

- **Flake-based**: Reproducible builds with locked dependencies
- **Home Manager**: User environment and dotfile management
- **SOPS Integration**: Encrypted secrets management with AGE
- **Declarative**: Everything configured through Nix expressions
- **Rollbacks**: Easy system rollbacks via generations

## Quick Commands

For a comprehensive command reference, see the [Command Reference Guide](/reference/commands/).

### Essential Commands

```bash
# Build and switch configuration
sudo nixos-rebuild switch --flake .#hostname

# Test configuration without switching
sudo nixos-rebuild test --flake .#hostname

# Check flake syntax
nix flake check

# Update all inputs
nix flake update
```

### Setup New Machine

For detailed setup commands and multi-machine configuration, see:
- [Command Reference Guide](/reference/commands/#hardware-configuration)
- [Multi-Machine Configuration](/nix/hosts/)

Quick setup:
1. Generate hardware config: `nixos-generate-config --show-hardware-config`
2. Copy to `lib/nix/hosts/{machine}/hardware-configuration.nix`
3. Deploy: `sudo nixos-rebuild switch --flake .#{hostname}`

### SOPS Secrets Management

For detailed SOPS setup and commands, see the [Command Reference Guide](/reference/commands/#sops-commands).

#### Key Points

- **System secrets**: Available at `/run/secrets/{secret-name}` (NixOS)
- **User secrets**: Available at `~/.local/share/sops/{secret-name}` (Home Manager)
- **SSH keys**: Referenced in `lib/nix/modules/home-manager/ssh-config.nix` for Git operations

#### Common Issues

- **"failed to decrypt" errors**: Ensure `/var/lib/sops-nix/key.txt` exists and contains the correct AGE private key
- **"infinite recursion" errors**: Verify `inherit inputs;` is passed in `home-manager.extraSpecialArgs`
- **Missing secret files**: Check that secrets are properly defined in both `sops.nix` and `sops-hm.nix`

## Reference

- [Multi-Machine Configuration](/nix/hosts/) - Setup and management of multiple machines
- [Repository Layout](/reference/repo-layout/) - Where the Nix modules and related files live
- [Daily Maintenance](/reference/maintenance/) - Routine update and rebuild commands
