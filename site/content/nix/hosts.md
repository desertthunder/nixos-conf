---
title: "Multi-Machine Configuration"
description: "How host-specific NixOS configs are organized under lib/nix and wired into the flake."
section: "Nix"
weight: 170
---

This repository supports NixOS machines with shared modules and host-specific overrides. Non-Nix macOS, Ubuntu, and Fedora machines use the `dotfiler` path instead.

## Directory Structure

```text
.
├── flake.nix
└── lib/nix/
    ├── hosts/
    │   ├── thinkpad/
    │   │   ├── configuration.nix
    │   │   └── hardware-configuration.nix
    │   ├── hp/
    │   │   ├── configuration.nix
    │   │   └── hardware-configuration.nix
    │   └── dell/
    │       ├── configuration.nix
    │       └── hardware-configuration.nix
    ├── modules/
    │   ├── nixos/
    │   │   ├── base.nix
    │   │   └── sops.nix
    │   └── home-manager/
    │       ├── home.nix
    │       ├── sops.nix
    │       └── ssh-config.nix
    └── profiles/
```

## Machine Profiles

### ThinkPad (`owais-nix-thinkpad`)

- **Status**: Configured NixOS host
- **Current Features**:
    - Power management with TLP
    - Thermal management
    - Fingerprint reader support
    - Full desktop environment (GNOME)

### HP (`owais-nix-hp`)

- **Status**: Configured NixOS host
- **Current Features**:
    - Shared NixOS base configuration
    - Generated hardware configuration
    - Full desktop environment (GNOME)

### Dell (`owais-nix-dell`)

- **Status**: New NixOS host target
- **Current Features**:
    - Shared NixOS base configuration
    - Dell host entry in `flake.nix`
    - Placeholder hardware configuration until generated on the target machine

### NUC

- **Status**: No longer a NixOS host in this repo
- **Target OS**: Fedora, managed through the non-Nix `dotfiler` path

## Configuration Philosophy

### Shared NixOS Modules

`lib/nix/modules/nixos/base.nix` contains common system settings:

- User accounts and shell configuration
- Core system packages
- Network and security settings
- Desktop environment
- Base services such as SSH and printing

`lib/nix/modules/home-manager/home.nix` contains shared user environment settings and installs canonical files from `lib/dotfiles/`.

### Host-Specific Overrides

Each host imports the shared NixOS base module and adds hardware- or machine-specific settings.

## Deployment Commands

See [NixOS Configuration](/nix/overview/) for build and deployment commands.

## Adding New NixOS Machines

1. **Create host directory**:

   ```bash
   mkdir -p lib/nix/hosts/{new-machine}
   ```

2. **Generate hardware configuration** on the target machine:

   ```bash
   sudo nixos-generate-config --show-hardware-config > lib/nix/hosts/{new-machine}/hardware-configuration.nix
   ```

3. **Create host configuration**:

   ```nix
   # lib/nix/hosts/{new-machine}/configuration.nix
   { config, pkgs, ... }:
   {
     imports = [
       ./hardware-configuration.nix
       ../../modules/nixos/base.nix
     ];

     networking.hostName = "owais-nix-{new-machine}";
   }
   ```

4. **Add to `flake.nix`**:

   ```nix
   nixosConfigurations.owais-nix-{new-machine} =
     mkNixosHost ./lib/nix/hosts/{new-machine}/configuration.nix;
   ```

## Maintenance

See [NixOS Configuration](/nix/overview/) for maintenance commands including updates, validation, and garbage collection.
