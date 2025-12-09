# NixOS Configuration/Dotfiles

My NixOS configuration and personal [notes/docs](./docs/src/overview.md)

![Lucy (Gleam) as Nix Logo](./docs/src/images/gleam-lucy_nix.png)

## TODO

- [ ] NixOS machines to 25.11
- [ ] Dragon-type naming convention for machines (starting with NUC -> Haxorus)

---

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

## Mac Mini (Roaring Moon) Migration

Note that anything added here should be merged into existing shared installations unless otherwise specified (like supercollider)

```sh
# All formulae and casks
brew list --formula > ./brew-formulae.txt
brew list --cask > ./brew-casks.txt

# Full Brewfile with dependencies
brew bundle dump --file=./Brewfile-existing
```

### ASDF

```sh
asdf current            # human-readable overview
cat ~/.tool-versions    # canonical list per plugin
```

### Apps

```sh
ls /Applications > ./apps-system.txt
ls ~/Applications 2>/dev/null > ./apps-user.txt
```

## Inventory

Date: 2025-12-08

Nix for dev tools, brew for GUI gaps

| Machine | Nix                       | Brew        | Drop |
| ------- | ------------------------- | ----------- | ---- |
| All     | Caddy                     | Zen Browser | -    |
| All     | Nginx                     | Tailscale   | -    |
| All     | Gleam                     | -           | -    |
| All     | Typst                     | -           | -    |
| All     | Zathura (& zathura-mupdf) | -           | -    |
| All     | MuPdf                     | -           | -    |
| All     | yt-dlp                    | -           | -    |
| All     | slides                    | -           | -    |
| Mini    | supercollider             | R, RStudio  | -    |
| Mini    | -                         | Sonic PI    | -    |
