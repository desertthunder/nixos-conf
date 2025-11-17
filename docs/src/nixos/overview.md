# NixOS Configuration

Declarative system configuration using Nix flakes with Home Manager integration.

## Structure

- **Flake**: `flake.nix` - Entry point defining inputs and outputs
- **System Config**: `conf/configuration.nix` - NixOS system settings
- **User Config**: `conf/home.nix` - Home Manager user environment
- **Hardware**: `conf/hardware-configuration.nix` - Hardware-specific settings

## Key Features

- **Flake-based**: Reproducible builds with locked dependencies
- **Home Manager**: User environment and dotfile management
- **Declarative**: Everything configured through Nix expressions
- **Rollbacks**: Easy system rollbacks via generations

## Quick Commands

- `sudo nixos-rebuild switch` - Apply system changes
- `nixos-rebuild --flake .` - Build from current flake
- `nix flake update` - Update flake lock file

## Reference

- [Nix Language](../notes/nix-lang.md) - Language syntax and patterns
