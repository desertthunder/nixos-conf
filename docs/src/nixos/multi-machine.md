# Multi-Machine Configuration

This repository is organized to support multiple NixOS machines with shared configurations and machine-specific customizations.

## Directory Structure

```sh
/home/owais/Projects/NixOS-Config/
├── flake.nix                    # Main flake with all machine configurations
├── machines/
│   ├── thinkpad/
│   │   ├── configuration.nix    # ThinkPad-specific config
│   │   └── hardware-configuration.nix
│   ├── hp/
│   │   ├── configuration.nix    # HP-specific config
│   │   └── hardware-configuration.nix
│   └── nuc/
│       ├── configuration.nix    # NUC-specific config
│       └── hardware-configuration.nix
├── shared/
│   ├── configuration.nix        # Shared base configuration
│   └── home.nix                # Shared home-manager config
└── modules/                     # Custom modules and configs
```

## Machine Profiles

### ThinkPad (`owais-nix-thinkpad`)

- **Status**: Configured
- **Current Features**:
  - Power management with TLP
  - Thermal management
  - Fingerprint reader support
  - Full desktop environment (GNOME)

### HP (`owais-nix-hp`)

TODO

### NUC (`owais-nix-nuc`)

TODO

## Configuration Philosophy

### Shared Configuration

The `shared/configuration.nix` contains common settings across all machines:

- User accounts and shell configuration
- Core system packages
- Network and security settings
- Base services (SSH, printing, etc.)

### Machine-Specific Overrides

Each machine imports the shared configuration and adds/overrides specific settings.

## Deployment Commands

### Building for Current Machine

```bash
# Switch to new configuration
sudo nixos-rebuild switch --flake .#$(hostname)

# Test without switching
sudo nixos-rebuild test --flake .#$(hostname)
```

### Building for Specific Machine

```bash
# ThinkPad
sudo nixos-rebuild switch --flake .#owais-nix-thinkpad

# HP
sudo nixos-rebuild switch --flake .#owais-nix-hp

# NUC
sudo nixos-rebuild switch --flake .#owais-nix-nuc
```

### Remote Deployment

```bash
# Build for remote machine
nixos-rebuild build --flake .#owais-nix-nuc

# Deploy to remote machine (requires SSH access)
nixos-rebuild switch --flake .#owais-nix-nuc --target-host user@remote-host
```

## Adding New Machines

1. **Create machine directory**:

   ```bash
   mkdir machines/{new-machine}
   ```

2. **Generate hardware configuration** on the target machine:

   ```bash
   nixos-generate-config --show-hardware-config > hardware-configuration.nix
   ```

3. **Create machine-specific configuration**:

   ```nix
   # machines/{new-machine}/configuration.nix
   { config, pkgs, ... }:
   {
     imports = [
       ./hardware-configuration.nix
       ../../shared/configuration.nix
     ];

     networking.hostName = "owais-nix-{new-machine}";

     # Machine-specific settings here
   }
   ```

4. **Add to flake.nix**:

   ```nix
   nixosConfigurations.owais-nix-{new-machine} = nixpkgs.lib.nixosSystem {
     system = "x86_64-linux";
     modules = [
       ./machines/{new-machine}/configuration.nix
       # ... home-manager config
     ];
   };
   ```

## Maintenance

### Updating Dependencies

```bash
# Update all flake inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs
```

### Checking Configuration

```bash
# Validate flake syntax
nix flake check

# Show available configurations
nix flake show
```

### Garbage Collection

```bash
# Clean up old generations
sudo nix-collect-garbage -d

# Clean up boot entries
sudo /run/current-system/bin/switch-to-configuration boot
```
