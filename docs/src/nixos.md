# NixOS

This repo builds two NixOS hosts from one flake and a shared baseline.

| Host             | Machine directory         | Notes                               |
| ---------------- | ------------------------- | ----------------------------------- |
| `nix-haxorus`    | `conf/machines/thinkpad/` | ThinkPad with Umbriel and Noctalia. |
| `nix-baxcalibur` | `conf/machines/hp/`       | HP host for shared services.        |

## Repository layout

| Path                                         | Purpose                                        |
| -------------------------------------------- | ---------------------------------------------- |
| `flake.nix`                                  | Host outputs, inputs, and Home Manager wiring. |
| `flake.lock`                                 | Exact upstream revisions.                      |
| `conf/shared.nix`                            | Shared NixOS and Home Manager modules.         |
| `conf/machines/*/configuration.nix`          | Host-specific system choices.                  |
| `conf/machines/*/hardware-configuration.nix` | Generated hardware facts.                      |
| `conf/modules/`                              | App config assets and focused local modules.   |
| `conf/services/`                             | Reusable service modules.                      |
| `conf/secrets/owais.yaml`                    | SOPS-encrypted secrets.                        |

For the concepts behind flakes and modules, see [Nix concepts](./concepts.md).

## Rebuilds

Use the hostname as the flake target:

```bash
sudo nixos-rebuild test --flake .#$(hostname)
sudo nixos-rebuild switch --flake .#$(hostname)
```

Prefer `test` before `switch` when touching boot, display managers, shells,
networking, secrets, or Home Manager activation.

## Inputs

Keep `flake.lock` stable unless the task is intentionally updating packages or
modules. For targeted updates:

```bash
nix flake lock --update-input nixpkgs-unstable
```

For a broad refresh:

```bash
nix flake update
```

Evaluate at least one host after lock changes.

## Secrets

SOPS-Nix decrypts configured secrets to `/run/secrets/` on NixOS hosts. See
[Secrets](./secrets.md) for the active secret names and local edit commands.

## Services

Shared service policy and host-specific service pages live under
[Services](./services.md).

## Adding hosts

Use [Adding a new machine](./adding-a-new-machine.md) for the operational
checklist.
