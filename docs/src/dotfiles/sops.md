# SOPS Without Nix

How to decrypt secrets from `secrets/owais.yaml` on machines that don't run NixOS or nix-darwin.

## Prerequisites

Your personal age key must exist at `~/.config/sops/age/keys.txt`.
This is the same key referenced in `.sops.yaml`. If it's missing, restore it from your password manager.

```bash
mkdir -p ~/.config/sops/age
# paste your age private key here
nano ~/.config/sops/age/keys.txt
```

## Install sops

**macOS:**

```bash
brew install sops
```

**One-off via nix shell:**

```bash
nix shell nixpkgs#sops
```

## Decrypt all secrets

Run from the repo root (so `.sops.yaml` is picked up automatically):

```bash
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops -d secrets/owais.yaml
```

> sops does not check `~/.config/sops/age/keys.txt` by default — you must set `SOPS_AGE_KEY_FILE` explicitly, or export it in your shell profile.

## Extract SSH keys

```bash
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
sops --extract '["keys_gh"]' -d secrets/owais.yaml > ~/.ssh/id_github
sops --extract '["keys_codeberg"]' -d secrets/owais.yaml > ~/.ssh/id_codeberg
sops --extract '["keys_tangled"]' -d secrets/owais.yaml > ~/.ssh/id_tangled
chmod 600 ~/.ssh/id_github ~/.ssh/id_codeberg ~/.ssh/id_tangled
```

Or to replicate the home-manager paths:

```bash
mkdir -p ~/.local/share/sops
for key in keys_gh keys_codeberg keys_tangled; do
  sops --extract "[\"$key\"]" -d secrets/owais.yaml > ~/.local/share/sops/$key
  chmod 600 ~/.local/share/sops/$key
done
```

> Note: `mkdir -p ~/.local/share/sops` must run before the loop — the directory doesn't exist on fresh machines.

## Edit secrets

```bash
sops secrets/owais.yaml
```
