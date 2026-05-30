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

## Migration Tracking

Active migration tasks are tracked in the top-level [`todo.md`](../../../todo.md).

### Platform-Specific Notes

#### NixOS Migration

- Full system replacement
- All packages via Nix
- Hardware configuration required
- Bootloader management

#### macOS Without Nix Migration

- Keep macOS core system unmanaged by Nix
- Use Homebrew for packages and GUI applications
- Use portable dotfiles from this repo
- Use SOPS + age for secrets
- Use `dotfiler` once the installer is implemented
