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

See [NixOS Configuration](./overview.md) for all build and deployment commands.

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

See [NixOS Configuration](./overview.md) for maintenance commands including updates, validation, and garbage collection.
