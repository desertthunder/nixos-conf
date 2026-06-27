# NixOS And Home Manager

NixOS owns system state. Home Manager owns user state. This repo wires Home
Manager into each NixOS host, so one rebuild applies both.

| Layer          | Owns                                                                      |
| -------------- | ------------------------------------------------------------------------- |
| NixOS          | boot, users, system services, hardware, system packages, secrets          |
| Home Manager   | dotfiles, user packages, editor config, shell config, desktop user config |
| Host modules   | machine-specific hardware and opt-in services                             |
| Shared modules | baseline system and user behavior for every host                          |

This split keeps the source of truth clear:

- If it needs root, systemd system units, hardware, or `/run/secrets`, it is
  usually NixOS.
- If it writes files under `/home/owais`, starts user services, or configures
  applications, it is usually Home Manager.
- If only one machine should have it, keep it out of `conf/shared.nix`.

## Rebuild Flow

`test` activates a generation without making it the boot default:

```bash
sudo nixos-rebuild test --flake .#$(hostname)
```

`switch` activates it and makes it the boot default:

```bash
sudo nixos-rebuild switch --flake .#$(hostname)
```

Use `test` first for changes that can affect boot, networking, login shells,
display managers, secrets, or Home Manager activation.
