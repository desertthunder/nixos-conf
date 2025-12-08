# macOS Configuration with nix-darwin

nix-darwin is used to manage macOS system configurations using Nix expression language, with Home Manager

## Setup

### Prerequisites

**Install Nix**:

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --prefer-upstream-nix
```

### Version Compatibility Requirements

nix-darwin version must match nixpkgs version. This configuration uses:

- `nixpkgs-25.05-darwin` (Darwin-compatible branch)
- `nix-darwin-25.05` (matching nix-darwin branch)
- Separate `nixpkgs-25.05` for Linux machines (no impact on existing NixOS systems)

## Usage

### Applying Configuration Changes

After modifying configuration files:

```bash
# Switch to new configuration
darwin-rebuild switch --flake .#owais-nix-air

# Build without activating (test first)
darwin-rebuild build --flake .#owais-nix-air

# Check what would change
darwin-rebuild check --flake .#owais-nix-air
```

### Convenience Alias

This can be added to `.zshrc`

```bash
alias rebuild="darwin-rebuild switch --flake ~/Projects/nixos-conf#owais-nix-air"
```

## Configuration Files Reference

### Shared Darwin Configuration

Shared macOS settings across all Darwin machines like timezone & locale, fonts, accounts, etc. in `shared/darwin-configuration.nix`

### Hardware Configuration

**File**: `machines/mac/air/hardware-configuration.nix`

Minimal on macOS (most hardware is managed by macOS itself). Can be used for performance tuning, external displays, custom drivers, etc.

### Flake Configuration

**File**: `flake.nix`

Defines the `owais-nix-air` Darwin system in `darwinConfigurations`.

**Important**: The system architecture setting:

- `aarch64-darwin` - Apple Silicon (M1/M2/M3/M4)
- `x86_64-darwin` - Intel Macs

## Common Customizations

### System Preferences

Edit `machines/mac/air/configuration.nix` to customize macOS system settings.

For common options see [nix-darwin manual](https://nix-darwin.github.io/nix-darwin/manual/) for complete list.

### Installing Packages

**System-wide packages** (available to all users) are in `shared/darwin-configuration.nix`

**User packages** (home-manager) are in `shared/home.nix`

## Maintenance

### Updating Dependencies

For general flake commands, see [NixOS Configuration](../nixos/overview.md#development-workflow).

Darwin-specific update workflow:

```bash
# Apply updates after running nix flake update
darwin-rebuild switch --flake .#owais-nix-air
```

### Rollback

```bash
# List generations
darwin-rebuild --list-generations

# Rollback to previous generation
darwin-rebuild rollback

# Switch to specific generation
darwin-rebuild switch --rollback --generation 42
```

### Homebrew Integration

nix-darwin's `cleanup = "zap"` will remove packages not declared in your config.

## Cleanup

### Remove Old Generations

```bash
# Remove generations older than 7 days
nix-collect-garbage --delete-older-than 7d

# Remove all old generations except current
nix-collect-garbage -d

# Remove specific generation
sudo nix-env --delete-generations 42
```

### Clean Build Cache

```bash
# Clean nix store (removes unused packages)
nix-store --gc

# Optimize nix store (deduplicates identical files)
nix-store --optimise
```

### Clean Darwin Store

```bash
# Remove unused darwin-rebuild profiles
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old

# Clean up old boot entries
sudo /nix/var/nix/profiles/system/bin/switch-to-configuration boot
```

### Reset Configuration

```bash
# Uninstall nix-darwin completely
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A uninstaller
./result/bin/darwin-uninstaller
```
