# Migration Guide

## Mac Mini (Roaring Moon) Migration

Note that anything added here should be merged into existing shared installations unless otherwise specified (like supercollider)

### Homebrew Migration

```sh
# All formulae and casks
brew list --formula > ./brew-formulae.txt
brew list --cask > ./brew-casks.txt

# Full Brewfile with dependencies
brew bundle dump --file=./Brewfile-existing
```

### ASDF Version Management

```sh
asdf current            # human-readable overview
cat ~/.tool-versions    # canonical list per plugin
```

### Applications Inventory

```sh
ls /Applications > ./apps-system.txt
ls ~/Applications 2>/dev/null > ./apps-user.txt
```

## Package Inventory

Date: 2025-12-08

Strategy: Nix for dev tools, brew for GUI gaps

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

## Migration Checklist

### Before Migration
- [ ] Export Homebrew packages
- [ ] Document ASDF versions
- [ ] List installed applications
- [ ] Backup configuration files
- [ ] Note machine-specific packages

### After Migration
- [ ] Install Nix packages from inventory
- [ ] Restore Homebrew GUI applications
- [ ] Configure ASDF versions
- [ ] Test development environment
- [ ] Verify application functionality

### Platform-Specific Notes

#### NixOS Migration
- Full system replacement
- All packages via Nix
- Hardware configuration required
- Bootloader management

#### nix-darwin Migration
- Hybrid approach recommended
- Keep macOS core system
- Use Nix for development tools
- Homebrew for GUI applications