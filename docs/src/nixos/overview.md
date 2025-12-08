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

### Building Configurations

```bash
# Build specific machine configuration
sudo nixos-rebuild switch --flake .#owais-nix-thinkpad
sudo nixos-rebuild switch --flake .#owais-nix-hp
sudo nixos-rebuild switch --flake .#owais-nix-nuc

# Test configuration without switching
sudo nixos-rebuild test --flake .#owais-nix-thinkpad

# Build configuration for remote deployment
nixos-rebuild build --flake .#owais-nix-nuc

# Build for current machine (uses hostname)
sudo nixos-rebuild switch --flake .#$(hostname)

# Override neovim-config input for local development
sudo nixos-rebuild switch --flake .#{machine} --override-input neovim-config path:/absolute/path/to/nvim-config
```

### Development Workflow

```bash
# Check flake syntax
nix flake check

# Update all inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs

# Show flake metadata
nix flake metadata

# Show available configurations
nix flake show
```

### Remote Deployment

```bash
# Deploy to remote machine (requires SSH access)
nixos-rebuild switch --flake .#owais-nix-nuc --target-host user@remote-host
```

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

### Setup New Machine

1. Generate hardware configuration on new machine:

   ```bash
   nixos-generate-config --show-hardware-config
   ```

2. Copy output to appropriate `machines/{machine}/hardware-configuration.nix`

3. Deploy configuration:

   ```bash
   sudo nixos-rebuild switch --flake .#{hostname}
   ```

For detailed multi-machine setup, see [Multi-Machine Configuration](./multi-machine.md).

## Reference

- [Multi-Machine Configuration](./multi-machine.md) - Setup and management of multiple machines
- [Nix Language](../notes/nix-lang.md) - Language syntax and patterns
