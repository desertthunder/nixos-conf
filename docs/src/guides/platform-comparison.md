# Platform Comparison

This repo now has two active platform strategies:

1. **NixOS** — fully declarative system configuration through `flake.nix`.
2. **Non-Nix systems** — macOS, Ubuntu, and Fedora managed by the planned `dotfiler` installer, package-manager-native package lists, portable dotfiles, and SOPS + age.

## NixOS vs. Non-Nix macOS/Linux

| Feature | NixOS | Non-Nix macOS | Non-Nix Ubuntu/Fedora |
| ------- | ----- | ------------- | --------------------- |
| System management | NixOS modules | OS defaults + Homebrew | OS defaults + apt/dnf |
| Dotfiles | Home Manager | `dotfiler` symlinks/copies | `dotfiler` symlinks/copies |
| Secrets | `sops-nix` / Home Manager | SOPS + age CLI | SOPS + age CLI |
| Packages | Nix | Homebrew | apt/dnf, plus manual gaps |
| Reproducibility | High | Deterministic-ish | Deterministic-ish |
| Main command | `nixos-rebuild switch` | `dotfiler apply` | `dotfiler apply` |

## Platform-Specific Settings

### NixOS

Linux system settings live in `shared/configuration.nix` for now and may later move to `nix/modules/nixos/`.

Examples:

- `boot.loader.*` — bootloader configuration
- `services.xserver.*` — display server and desktop session
- `services.tlp.*` — power management
- `services.fprintd.*` — fingerprint reader
- `users.users.*` — system users

### macOS without Nix

macOS should use:

- Homebrew for packages and GUI apps
- portable dotfiles from this repo
- SOPS + age for secrets
- `dotfiler` once implemented

### Ubuntu/Fedora without Nix

Ubuntu/Fedora should use:

- apt or dnf package lists
- portable dotfiles from this repo
- SOPS + age for secrets
- `dotfiler` once implemented

## Package Management Strategy

### NixOS

- Use Nix for system packages and user packages.
- Keep machine-specific hardware and service settings in host configs.
- Use Home Manager for user-level config.

### Non-Nix macOS

- Use Homebrew-native `Brewfile`s.
- Prefer Homebrew casks for GUI apps.
- Use `dotfiler` for orchestration, not for replacing Homebrew.

### Non-Nix Ubuntu/Fedora

- Use distro-native package managers first.
- Keep explicit package lists in the repo.
- Let `dotfiler` orchestrate installs and dotfile linking.
