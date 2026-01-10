# NixOS Configuration

Declarative system configuration using Nix flakes with Home Manager integration.

## Structure

- **Flake**: `flake.nix` - Entry point defining inputs and outputs
- **Shared Config**: `shared/configuration.nix` - Common NixOS system settings
- **Machine Configs**: `machines/{hostname}/configuration.nix` - Machine-specific settings
- **User Config**: `shared/home.nix` - Home Manager user environment
- **Hardware**: `machines/{hostname}/hardware-configuration.nix` - Hardware-specific settings per machine
- **SOPS Config**: `shared/sops.nix` - System-level secrets management
- **SOPS Home**: `shared/sops-hm.nix` - User-level secrets management
- **SSH Config**: `shared/ssh-config.nix` - SSH configuration with SOPS-managed keys
- **Secrets**: `secrets/owais.yaml` - Encrypted secrets file

## Key Features

- **Flake-based**: Reproducible builds with locked dependencies
- **Home Manager**: User environment and dotfile management
- **SOPS Integration**: Encrypted secrets management with AGE
- **Declarative**: Everything configured through Nix expressions
- **Rollbacks**: Easy system rollbacks via generations

## Quick Commands

For a comprehensive command reference, see the [Command Reference Guide](../guides/commands.md).

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
- [Command Reference Guide](../guides/commands.md#hardware-configuration)
- [Multi-Machine Configuration](./multi-machine.md)

Quick setup:
1. Generate hardware config: `nixos-generate-config --show-hardware-config`
2. Copy to `machines/{machine}/hardware-configuration.nix`
3. Deploy: `sudo nixos-rebuild switch --flake .#{hostname}`

### SOPS Secrets Management

For detailed SOPS setup and commands, see the [Command Reference Guide](../guides/commands.md#sops-commands).

#### Key Points

- **System secrets**: Available at `/run/secrets/{secret-name}` (NixOS)
- **User secrets**: Available at `~/.local/share/sops/{secret-name}` (Home Manager)
- **SSH keys**: Referenced in `shared/ssh-config.nix` for Git operations

#### Common Issues

- **"failed to decrypt" errors**: Ensure `/var/lib/sops-nix/key.txt` exists and contains the correct AGE private key
- **"infinite recursion" errors**: Verify `inherit inputs;` is passed in `home-manager.extraSpecialArgs`
- **Missing secret files**: Check that secrets are properly defined in both `sops.nix` and `sops-hm.nix`

## Reference

- [Multi-Machine Configuration](./multi-machine.md) - Setup and management of multiple machines
- [Nix Language](../notes/nix-lang.md) - Language syntax and patterns
