# NixOS Configuration

Declarative system configuration using Nix flakes with Home Manager integration.

## Structure

- **Flake**: `flake.nix` - Entry point defining inputs and outputs
- **Shared Config**: `shared/configuration.nix` - Common NixOS system settings
- **Machine Configs**: `machines/{hostname}/configuration.nix` - Machine-specific settings
- **User Config**: `shared/home.nix` - Home Manager user environment
- **Hardware**: `machines/{hostname}/hardware-configuration.nix` - Hardware-specific settings per machine

## Key Features

- **Flake-based**: Reproducible builds with locked dependencies
- **Home Manager**: User environment and dotfile management
- **Declarative**: Everything configured through Nix expressions
- **Rollbacks**: Easy system rollbacks via generations

## Quick Commands

- `sudo nixos-rebuild switch --flake .#owais-nix-thinkpad` - Apply system changes for thinkpad
- `sudo nixos-rebuild test --flake .#owais-nix-thinkpad` - Test configuration without switching
- `nix flake update` - Update flake lock file
- `nix flake check` - Check flake syntax
- `nix flake show` - Show available configurations

### Clean up old generations

```sh
nix-env --list-generations

nix-collect-garbage  --delete-old

nix-collect-garbage  --delete-generations 1 2 3

# recommeneded to sometimes run as sudo to collect additional garbage
sudo nix-collect-garbage -d

# As a separation of concerns - you will need to run this command to clean out boot
sudo /run/current-system/bin/switch-to-configuration boot
```

## Reference

- [Nix Language](../notes/nix-lang.md) - Language syntax and patterns
