# Flakes

A flake is a pinned project interface. It declares inputs, records exact input
revisions in `flake.lock`, and exposes outputs that commands can build or
inspect.

| Part                          | Role                                                        |
| ----------------------------- | ----------------------------------------------------------- |
| `inputs.nixpkgs`              | Main Nixpkgs channel for systems and packages.              |
| `inputs.nixpkgs-unstable`     | Fast-moving packages, currently used for Zed & Claude Code. |
| `inputs.home-manager`         | User environment as part of each NixOS system.              |
| `inputs.sops-nix`             | Secret material decrypted onto NixOS hosts.                 |
| `outputs.nixosConfigurations` | Buildable NixOS hosts.                                      |

The important command target is:

```text
.#nixosConfigurations.<hostname>
```

`nixos-rebuild --flake .#<hostname>` is shorthand for selecting one of those
host outputs.

## Lock File

`flake.lock` is part of the system definition. Rebuilding without changing it
uses the same upstream source graph. Updating it changes package and module
inputs, so treat lock updates as intentional system changes.

Use targeted updates when possible:

```bash
nix flake lock --update-input nixpkgs-unstable
```

Use broad updates when the task is a full system refresh:

```bash
nix flake update
```

After changing inputs, evaluate or test one host before switching every host.
