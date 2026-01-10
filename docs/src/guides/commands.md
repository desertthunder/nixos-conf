# Command Reference

## NixOS Commands

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

### System Maintenance

```bash
# List all generations
nix-env --list-generations

# Clean up old generations
nix-collect-garbage --delete-old

# Delete specific generations
nix-collect-garbage --delete-generations 1 2 3

# Recommended: run as sudo to collect additional garbage
sudo nix-collect-garbage -d

# Clean boot entries (run after garbage collection)
sudo /run/current-system/bin/switch-to-configuration boot
```

## nix-darwin Commands

```bash
# Build darwin configuration
darwin-rebuild switch --flake .#mac-mini

# Test configuration
darwin-rebuild test --flake .#mac-mini

# Build for remote deployment
darwin-rebuild build --flake .#mac-mini
```

## Home Manager Commands

```bash
# Switch user configuration
home-manager switch --flake .#username

# Test configuration
home-manager test --flake .#username

# Build configuration
home-manager build --flake .#username
```

## SOPS Commands

### Initial Setup

```bash
# Generate new key pair
age-keygen -o ~/.config/sops/age/keys.txt

# View public key for SOPS file configuration
age-keygen -y ~/.config/sops/age/keys.txt

# Copy user AGE key to system location (after rebuilding)
sudo mkdir -p /var/lib/sops-nix
sudo cp ~/.config/sops/age/keys.txt /var/lib/sops-nix/key.txt
sudo chmod 600 /var/lib/sops-nix/key.txt
sudo chown root:root /var/lib/sops-nix/key.txt
```

### Managing Secrets

```bash
# Edit encrypted secrets file
sops secrets/owais.yaml

# Add new secret key
sops -s secrets/owais.yaml

# Test decryption (requires proper key setup)
sops -d secrets/owais.yaml
```

## Migration Commands

### Homebrew Export

```bash
# All formulae and casks
brew list --formula > ./brew-formulae.txt
brew list --cask > ./brew-casks.txt

# Full Brewfile with dependencies
brew bundle dump --file=./Brewfile-existing
```

### ASDF Management

```bash
# Show current versions
asdf current

# View canonical list per plugin
cat ~/.tool-versions
```

### Application Inventory

```bash
# System applications
ls /Applications > ./apps-system.txt

# User applications
ls ~/Applications 2>/dev/null > ./apps-user.txt
```

## Hardware Configuration

```bash
# Generate hardware configuration on new machine
nixos-generate-config --show-hardware-config

# Copy output to appropriate location
# machines/{machine}/hardware-configuration.nix
```

## Troubleshooting Commands

### SOPS Issues

```bash
# Check if key file exists
ls -la /var/lib/sops-nix/key.txt

# Test decryption
sops -d secrets/owais.yaml

# Verify file permissions
sudo ls -la /var/lib/sops-nix/
```

### Flake Issues

```bash
# Check flake syntax
nix flake check

# Show flake metadata
nix flake metadata

# Show available outputs
nix flake show
```