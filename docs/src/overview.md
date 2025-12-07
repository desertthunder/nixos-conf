# Desert Thunder's Dotfiles

This book is a collection of notes and guides around my personal dotfiles. It's a bit
all over the place because as of writing (November 16, 2025), I've only been using NixOS
as one of my daily drivers for a day.

These reflect my habits and quirks as a developer. My `*.nix` files will likely not be
modular until I hit the 1000 line threshold. The neovim configuration is a vestige of a
time before I embraced the long file.

If you want to take a look at my specific configurations and settings, take a look at
[the repo](https://github.com/desertthunder/nixos-conf) that houses these notes. If you
have any requests or suggestions, feel free to open an issue. I haven't decided on a
license but regardless of what I pick, I hope that this ends up being a valuable
resource to anyone that gives it the time. Programming and engineering are fun, and I've
always liked messing with my setup and I hope you have fun too.

## Multi-Machine Setup

This configuration supports multiple machines with different hostnames:

- **owais-nix-thinkpad**: Currently configured with power management and fingerprint support
- **owais-nix-hp**: Template configuration - TODO: customize for HP-specific needs
- **owais-nix-nuc**: Template configuration - TODO: customize for NUC-specific needs

## Quick Commands

These commands should be run from the root of the repository (`/home/owais/Projects/NixOS-Config/`):

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
```

#### Note About Neovim

To override the neovim-config input in `flake.nix`, such that a locally updated version of the configuration is used,
override the input with a flag pointing towards the config directory.

```bashsudo nix-channel --update
sudo nixos-rebuild switch --flake .#{machine} --override-input neovim-config path:/absolute/path/to/nvim-config
```

### Development Workflow

```bash
# Check flake syntax
nix flake check

# Update all inputs
nix flake update

# Show flake metadata
nix flake metadata

# Show available configurations
nix flake show
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

More details are in the [multi-machine](./nixos/multi-machine.md) document.

## Credits

This site was inspired by isabel's dotfiles [book](https://dotfiles.isabelroses.com/)
