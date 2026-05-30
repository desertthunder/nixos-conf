# Changelog

## Unreleased

- Dropped nix-darwin from the active codebase so macOS uses the non-Nix Homebrew,
  portable dotfiles, and SOPS/age path.
- Completed the portable dotfiles layer by moving shell, Git, Ghostty, ripgrep, Zellij,
  and Oh My Posh config under `lib/dotfiles/` and wiring Home Manager plus a non-Nix linker
  script to consume it.
- Go installer with platform detection, dry-run command execution, package installation,
  dotfile linking, SOPS checks, and bootstrap scripts.
- Removed remaining Darwin conditionals from the Nix/Home Manager code and added pi coding
  agent installation for NixOS Home Manager activation and non-Nix bootstrap installs.
- Replaced Alacritty with Ghostty across the NixOS system and Home Manager config.
- Reorganized NixOS into `lib/nix/hosts`, `lib/nix/modules`, and `lib/nix/profiles`, added Dell
  as a NixOS host, and moved the NUC to the Fedora/non-Nix path.
- Completed the SOPS/age strategy with `dotfiler secrets edit`, documented age key
  restore and recipient policy, and kept git-crypt out of the default workflow.
- Kept existing utility scripts as standalone documented tools instead of porting them
  into the Go binaries.
- Added the custom `site` static site generator with Go templates, Markdown/front matter,
  preview serving, exposed Pagefind search UI, Alpine.js hooks, Iceberg colors, IBM Plex
  Serif prose, JetBrains Mono code styling, flat backgrounds, and tighter border radii.
- Migrated documentation content from mdBook under `docs/` into `site/content/` and
  removed mdBook-specific project files.
