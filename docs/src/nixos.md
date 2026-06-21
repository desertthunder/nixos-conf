# NixOS

## Layout

Configuration lives under `conf/`:

```text
conf/
├── machines/
│   ├── hp/
│   └── thinkpad/
├── modules/
│   └── de/
├── secrets/
└── shared.nix
```

- `conf/shared.nix`: shared NixOS and Home Manager modules.
- `conf/machines/{machine}/configuration.nix`: host-specific settings.
- `conf/machines/{machine}/hardware-configuration.nix`: generated hardware.
- `conf/modules/`: extra modules and config assets used by Home Manager.
- `conf/modules/de/`: desktop-environment modules such as Hyprland.
- `conf/secrets/owais.yaml`: encrypted SOPS secrets.

## Rebuild

```bash
sudo nixos-rebuild switch --flake .#$(hostname)
sudo nixos-rebuild test --flake .#$(hostname)
nix flake update
```

Configurations currently provided by the flake:

- `nix-haxorus`: ThinkPad
- `nix-baxcalibur`: HP

## Add a machine

See [Adding a New Machine](./adding-a-new-machine.md) for the full workflow and
the concepts behind it.

## SOPS

The system imports `sops-nix` from `conf/shared.nix` and exposes secrets under
`/run/secrets/`.

Useful commands:

```bash
SOPS_AGE_KEY_FILE=$(pwd)/age.txt sops conf/secrets/owais.yaml
SOPS_AGE_KEY_FILE=$(pwd)/age.txt sops -d conf/secrets/owais.yaml
sops updatekeys conf/secrets/owais.yaml
```

The personal age key is documented in `age.txt`. `.sops.yaml` controls which
files are encrypted and which recipients can decrypt them.
