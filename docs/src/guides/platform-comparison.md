# Platform Comparison

## NixOS vs. Nix-Darwin

| Feature         | NixOS                           | nix-darwin                |
| --------------- | ------------------------------- | ------------------------- |
| Bootloader      | Managed by NixOS                | Managed by macOS          |
| Kernel          | Linux kernel                    | macOS XNU kernel          |
| Init system     | systemd                         | launchd                   |
| Display server  | X11/Wayland                     | macOS WindowServer        |
| Package manager | Only Nix                        | Nix + optional Homebrew   |
| State version   | `system.stateVersion = "25.05"` | `system.stateVersion = 5` |

## Platform-Specific Settings

### Linux only (in `shared/configuration.nix`)

- `boot.loader.*` - Bootloader configuration
- `services.xserver.*` - X11 display server
- `services.tlp.*` - Power management
- `services.fprintd.*` - Fingerprint reader

### macOS only (in `shared/darwin-configuration.nix`)

- `system.defaults.*` - macOS system preferences
- `security.pam.enableSudoTouchIdAuth` - Touch ID for sudo
- `homebrew.*` - Homebrew package management

## Package Management Strategy

### NixOS
- Use Nix for all packages
- Declarative configuration
- System-wide package management

### nix-darwin
- Nix for development tools and CLI packages
- Homebrew for GUI applications and gaps
- Hybrid approach for maximum compatibility

## Configuration Differences

### System Configuration
- **NixOS**: Full system control including kernel, bootloader, services
- **nix-darwin**: User-space configuration only, relies on macOS core

### User Environment
- **Both**: Use Home Manager for dotfiles and user packages
- **NixOS**: System-level user management
- **nix-darwin**: Integration with macOS user accounts

### Development Workflow
- **NixOS**: `nixos-rebuild switch` for system changes
- **nix-darwin**: `darwin-rebuild switch` for system changes
- **Both**: `home-manager switch` for user environment changes