---
title: "SOPS Without Nix"
description: "SOPS and age workflows for decrypting, editing, and extracting secrets outside NixOS."
section: "Secrets"
weight: 110
---

How to decrypt and edit `lib/secrets/owais.yaml` on machines that are not managed by NixOS.

## Prerequisites

Your personal age key must exist at:

```text
~/.config/sops/age/keys.txt
```

This is the same personal key referenced in `.sops.yaml`. Restore it from your password manager on a fresh machine.

```bash
mkdir -p ~/.config/sops/age
chmod 700 ~/.config/sops/age
# paste the age private key from your password manager
nano ~/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt
```

## Install tools

On non-Nix machines, install through the platform package lists and `dotfiler`:

```bash
dotfiler packages apply
dotfiler secrets check
```

Manual macOS fallback:

```bash
brew install age sops
```

## Decrypt all secrets

Run from the repo root:

```bash
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops -d lib/secrets/owais.yaml
```

## Extract SSH keys

Preferred:

```bash
dotfiler secrets extract-ssh
```

Manual equivalent:

```bash
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
mkdir -p ~/.local/share/sops
for key in keys_gh keys_codeberg keys_tangled; do
  sops --extract "[\"$key\"]" -d lib/secrets/owais.yaml > ~/.local/share/sops/$key
  chmod 600 ~/.local/share/sops/$key
done
```

## Edit secrets

Preferred:

```bash
dotfiler secrets edit
```

Manual equivalent:

```bash
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops lib/secrets/owais.yaml
```

## Recipient policy

- Keep `.sops.yaml` as the source of recipient configuration.
- Keep `lib/secrets/owais.yaml` encrypted with SOPS.
- Add machine recipients only when needed.
- Do not add git-crypt unless this repo later needs encrypted binary files or encrypted private directories.
