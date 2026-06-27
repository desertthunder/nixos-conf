# Other Linux Distributions

This repo is a NixOS workstation, but many user-level choices translate to
Fedora, Ubuntu, Debian, and other Linux distributions. Treat the Nix files as an
inventory and policy reference, not as something another distro can apply
directly.

## Target Shape

| Area         | Expected result                                                        |
| ------------ | ---------------------------------------------------------------------- |
| Desktop      | GNOME or Hyprland on Wayland, PipeWire, NetworkManager, printing, SSH. |
| Shell        | Zsh login shell with Starship and a small alias set.                   |
| Editors      | Neovim and Zed with language servers available on `PATH`.              |
| Terminal     | Ghostty, usually launching Zsh and sometimes Zellij.                   |
| Dev services | Docker, PostgreSQL, and Redis for local development.                   |
| CLI tools    | ripgrep, fd, jq/yq, fzf, bat, direnv, just, and common compilers.      |
| Fonts        | Nerd fonts plus Inter, Open Sans, Noto, and other UI/code fonts.       |
| Secrets      | SOPS-extracted SSH keys under a normal user-owned path.                |

## Translation Map

| NixOS source                      | Portable equivalent                                            |
| --------------------------------- | -------------------------------------------------------------- |
| `environment.systemPackages`      | Distro packages, language installers, or Nix profile packages. |
| `home.packages`                   | Distro packages or Home Manager outside NixOS.                 |
| `programs.*` Home Manager options | Dotfiles under `~/.config` or app-native settings.             |
| `services.*` NixOS options        | Native systemd units and distro service packages.              |
| `sops.secrets.*`                  | Decrypt with SOPS to files under `~/.local/share/sops`.        |
| `conf/modules/*`                  | Copy selected app config directories into `~/.config`.         |

## What Copies Cleanly

| Component | Portable approach                                               |
| --------- | --------------------------------------------------------------- |
| Zellij    | Copy `conf/modules/zellij` to `~/.config/zellij`.               |
| Neovim    | Clone `github:desertthunder/nvim` to `~/.config/nvim`.          |
| Starship  | Copy `conf/modules/starship.toml` to `~/.config/starship.toml`. |
| Zathura   | Copy `conf/modules/zathura/zathurarc`.                          |
| Fastfetch | Copy `conf/modules/fastfetch`.                                  |
| ripgrep   | Recreate the small config from the program page or source.      |
| SSH keys  | Use `conf/scripts/keys.sh` after placing the age key.           |

## What Needs Native Distro Setup

| Area            | Notes                                                                    |
| --------------- | ------------------------------------------------------------------------ |
| Desktop session | Install GNOME, Hyprland, portals, and login-manager pieces natively.     |
| System services | Enable Docker, PostgreSQL, Redis, SSH, CUPS, and Tailscale with systemd. |
| Fonts           | Prefer distro packages; use user font installs for missing Nerd Fonts.   |
| Language tools  | Use upstream installers where distro versions lag too far.               |
| Secrets         | There is no `/run/secrets` unless you recreate that pattern yourself.    |
| NixOS aliases   | Do not copy aliases that call `nixos-rebuild`.                           |

## Recommended Path

1. Start from the distro’s GNOME edition or another well-supported desktop.
2. Install baseline CLI tools, editors, fonts, and development services.
3. Enable Docker, PostgreSQL, Redis, SSH, printing, and Tailscale.
4. Copy only app configs you actually use.
5. Extract SSH keys with SOPS if this machine should use repo-managed keys.
6. Add Nix or Home Manager later only if native packages become too divergent.

## Package Strategy

Use native packages for the OS layer: desktop, printing, Bluetooth, networking,
Docker, PostgreSQL, Redis, OpenSSH, and Tailscale.

Use language-native installers for fast-moving ecosystems when needed:

| Toolchain       | Typical source                                                        |
| --------------- | --------------------------------------------------------------------- |
| Rust            | `rustup`                                                              |
| Bun             | upstream installer                                                    |
| uv              | upstream installer                                                    |
| Node/TypeScript | distro package, pnpm, or project-local tooling                        |
| Zed             | upstream package                                                      |
| Claude Code     | Nix, upstream package, or npm-style install depending on availability |

Use Nix outside NixOS only when it clearly reduces drift. This repo does not
currently expose a standalone `homeConfigurations.<user>` output, so Home
Manager outside NixOS would need a small extra flake entry.

## Secrets And SSH

NixOS uses SOPS-Nix to mount secrets at `/run/secrets`. Other distros should use
normal user-owned files. The intended portable flow is:

| Step                                             | Result                                         |
| ------------------------------------------------ | ---------------------------------------------- |
| Put the age key at `~/.config/sops/age/keys.txt` | SOPS can decrypt locally.                      |
| Run `./conf/scripts/keys.sh`                     | Git SSH keys land under `~/.local/share/sops`. |
| Point SSH identities at those files              | GitHub, Codeberg, and Tangled work.            |

See [Secrets](./secrets.md) and [SSH](./programs/ssh.md) for current key names
and host aliases.

## Sanity Checks

After setup, confirm the shape rather than exact package parity:

| Check                                 | Why                                           |
| ------------------------------------- | --------------------------------------------- |
| Shell is Zsh                          | Login environment matches the dotfiles.       |
| Starship loads                        | Prompt integration works.                     |
| Neovim and Zed start                  | Editors can see expected language tools.      |
| Zellij validates config               | Terminal workspace config is compatible.      |
| Docker runs a test container          | User is in the Docker group and daemon works. |
| PostgreSQL accepts a local connection | Local dev database is ready.                  |
| Redis returns `PONG`                  | Local cache service is ready.                 |
| SSH reaches Git hosts                 | SOPS-extracted keys and aliases are correct.  |

Expect package substitutions. The goal is the same working environment, not an
exact reproduction of NixOS internals.
