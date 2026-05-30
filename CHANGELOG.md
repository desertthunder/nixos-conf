# Changelog

## Unreleased

- Dropped nix-darwin from the active codebase so macOS uses the non-Nix Homebrew,
  portable dotfiles, and SOPS/age path.
- Completed the portable dotfiles layer by moving shell, Git, Ghostty, ripgrep, Zellij,
  and Oh My Posh config under `dotfiles/` and wiring Home Manager plus a non-Nix linker
  script to consume it.
- Go installer with platform detection, dry-run command execution, package installation,
  dotfile linking, SOPS checks, and bootstrap scripts.
- Removed remaining Darwin conditionals from the Nix/Home Manager code and added pi coding
  agent installation for NixOS Home Manager activation and non-Nix bootstrap installs.
- Replaced Alacritty with Ghostty across the NixOS system and Home Manager config.
