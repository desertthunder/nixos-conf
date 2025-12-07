# NixOS Configuration/Dotfiles

My NixOS configuration and personal [notes/docs](./docs/src/overview.md)

![Lucy (Gleam) as Nix Logo](./docs/src/images/gleam-lucy_nix.png)

## TODO

- [ ] VSCode Profiles
- [x] Zathura
  - [ ] Mac

### Linux

- [ ] Hyprland
  - [ ] Rofi
  - [ ] Waybar

## NixOS vs. Nix-Darwin

| Feature         | NixOS                           | nix-darwin                |
| --------------- | ------------------------------- | ------------------------- |
| Bootloader      | Managed by NixOS                | Managed by macOS          |
| Kernel          | Linux kernel                    | macOS XNU kernel          |
| Init system     | systemd                         | launchd                   |
| Display server  | X11/Wayland                     | macOS WindowServer        |
| Package manager | Only Nix                        | Nix + optional Homebrew   |
| State version   | `system.stateVersion = "25.05"` | `system.stateVersion = 5` |

### Platform-Specific Settings

**Linux only** (in `shared/configuration.nix`):

- `boot.loader.*` - Bootloader configuration
- `services.xserver.*` - X11 display server
- `services.tlp.*` - Power management
- `services.fprintd.*` - Fingerprint reader

**macOS only** (in `shared/darwin-configuration.nix`):

- `system.defaults.*` - macOS system preferences
- `security.pam.enableSudoTouchIdAuth` - Touch ID for sudo
- `homebrew.*` - Homebrew package management
