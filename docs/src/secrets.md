# Secrets

Secrets are stored in `conf/secrets/owais.yaml` and encrypted with SOPS. NixOS
hosts decrypt them with SOPS-Nix; non-NixOS machines can extract selected files
with the helper script.

## Active Secrets

| Secret          | NixOS path                   | Used by               |
| --------------- | ---------------------------- | --------------------- |
| `keys_gh`       | `/run/secrets/keys_gh`       | GitHub SSH            |
| `keys_codeberg` | `/run/secrets/keys_codeberg` | Codeberg SSH          |
| `keys_tangled`  | `/run/secrets/keys_tangled`  | Tangled and Knot SSH  |
| `umans_key`     | `/run/secrets/umans_key`     | Claude Code Umans API |

Files are owned by `owais:users` with mode `0600`.

## NixOS Model

| Piece                       | Role                                                       |
| --------------------------- | ---------------------------------------------------------- |
| `conf/secrets/owais.yaml`   | Encrypted secret values.                                   |
| `.sops.yaml`                | Recipient and file encryption policy.                      |
| `/var/lib/sops-nix/key.txt` | Age key used by NixOS during activation.                   |
| `conf/shared.nix`           | Declares which secrets should appear under `/run/secrets`. |

SSH and Claude Code reference `/run/secrets` paths directly.

## Local Editing

Use the local age key when editing from the repo:

```bash
SOPS_AGE_KEY_FILE=$(pwd)/age.txt nix shell nixpkgs#sops -c sops conf/secrets/owais.yaml
```

Validate decryptability without printing values:

```bash
SOPS_AGE_KEY_FILE=$(pwd)/age.txt nix shell nixpkgs#sops -c sops -d conf/secrets/owais.yaml >/dev/null
```

Update recipients after changing `.sops.yaml`:

```bash
nix shell nixpkgs#sops -c sops updatekeys conf/secrets/owais.yaml
```

## Non-NixOS Extraction

`conf/scripts/keys.sh` extracts Git SSH keys for machines that do not use
SOPS-Nix.

| Expected input                      | Output           |
| ----------------------------------- | ---------------- |
| `~/.config/sops/age/keys.txt`       | Local age key    |
| `conf/secrets/owais.yaml`           | Encrypted source |
| `~/.local/share/sops/keys_gh`       | GitHub key       |
| `~/.local/share/sops/keys_codeberg` | Codeberg key     |
| `~/.local/share/sops/keys_tangled`  | Tangled key      |

Run:

```bash
mkdir -p ~/.config/sops/age
cp age.txt ~/.config/sops/age/keys.txt
./conf/scripts/keys.sh
```

The script sets key file permissions to `0600`.

## Common Failure Modes

| Symptom                         | Likely cause                                       |
| ------------------------------- | -------------------------------------------------- |
| SOPS cannot decrypt locally     | `SOPS_AGE_KEY_FILE` points at the wrong key.       |
| NixOS rebuild cannot decrypt    | `/var/lib/sops-nix/key.txt` is missing or wrong.   |
| SSH ignores a key               | File permissions or `IdentityFile` path are wrong. |
| Claude Code cannot authenticate | `/run/secrets/umans_key` is missing after rebuild. |
