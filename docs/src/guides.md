# Guides

## Common commands

```bash
# Build, test, and switch
sudo nixos-rebuild build --flake .#$(hostname)
sudo nixos-rebuild test --flake .#$(hostname)
sudo nixos-rebuild switch --flake .#$(hostname)

# Inspect generations
nixos-rebuild list-generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Garbage collect
sudo nix-collect-garbage -d
nix store optimise

# Update inputs
nix flake update
nix flake lock --update-input nixpkgs

# Hardware config
sudo nixos-generate-config --show-hardware-config \
  > conf/machines/$(hostname)/hardware-configuration.nix
```

`conf/shared.nix` defines zsh aliases for common rebuild commands.

## Home Manager

Home Manager is wired through the NixOS flake, so normal `nixos-rebuild` applies
both system and home changes. The shared Home Manager module is
`(import ./conf/shared.nix).home` in `flake.nix`.

## Secrets

```bash
SOPS_AGE_KEY_FILE=$(pwd)/age.txt sops conf/secrets/owais.yaml
sops -d conf/secrets/owais.yaml
./conf/scripts/keys.sh
```

`./conf/scripts/keys.sh` extracts Git provider SSH keys into
`~/.local/share/sops/` for non-NixOS use.

## Check changes

When making small Nix changes (like adding packages), a quick local check flow:

```bash
# 1) Format (keeps diffs small and avoids nixfmt-related CI/lint churn)
nixfmt conf/shared.nix

# 2) Ensure the flake evaluates and outputs are well-formed
nix flake show --no-write-lock-file

# 3) Optional, stronger checks before switching
sudo nixos-rebuild build --flake .#$(hostname)
sudo nixos-rebuild test --flake .#$(hostname)
```

Notes:

- `nix flake show` only evaluates the flake; it does not build anything.
- `nixos-rebuild build/test` will actually evaluate/build the system closure and
  will catch missing packages/options earlier than `switch`.

## Troubleshooting

- Use `sudo nixos-rebuild test --flake .#host` before switching.
- If Home Manager reports file collisions, move the existing file and rebuild.
- If secrets fail, confirm `/var/lib/sops-nix/key.txt` exists on NixOS or set
  `SOPS_AGE_KEY_FILE` manually for local operations.
- If a flake path changed, search with `rg 'old/path'` and update docs, scripts,
  and Nix imports together.

## Migration checklist

- Copy hardware config into `conf/machines/{machine}/`.
- Keep host-only options in that machine's `configuration.nix`.
- Keep reusable system and home settings in `conf/shared.nix`.
- Keep host-specific desktop stacks in opt-in modules under `conf/modules/de/`.
- Rebuild with `sudo nixos-rebuild switch --flake .#{hostname}`.
