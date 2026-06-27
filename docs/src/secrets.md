# Secrets

This repo stores secrets in `conf/secrets/owais.yaml` and decrypts them with
SOPS.

## NixOS

`conf/shared.nix` imports `sops-nix` and reads the age key from:

```text
/var/lib/sops-nix/key.txt
```

It exposes these secrets:

- `/run/secrets/keys_gh`
- `/run/secrets/keys_codeberg`
- `/run/secrets/keys_tangled`
- `/run/secrets/umans_key`

The files belong to user `owais`, group `users`, with mode `0600`.

SSH and Claude Code use those paths in the Home Manager config.

## Local SOPS commands

Use the local age key when editing or reading the encrypted file from the repo:

```bash
SOPS_AGE_KEY_FILE=$(pwd)/age.txt nix shell nixpkgs#sops -c sops conf/secrets/owais.yaml
SOPS_AGE_KEY_FILE=$(pwd)/age.txt nix shell nixpkgs#sops -c sops -d conf/secrets/owais.yaml
nix shell nixpkgs#sops -c sops updatekeys conf/secrets/owais.yaml
```

## Non-NixOS key extraction

`conf/scripts/keys.sh` extracts Git SSH keys to:

```text
~/.local/share/sops/
```

It expects the age key at:

```text
~/.config/sops/age/keys.txt
```

Run:

```bash
mkdir -p ~/.config/sops/age
cp age.txt ~/.config/sops/age/keys.txt
./conf/scripts/keys.sh
```

The script writes:

- `~/.local/share/sops/keys_gh`
- `~/.local/share/sops/keys_codeberg`
- `~/.local/share/sops/keys_tangled`

It also sets file mode `0600`.

## SSH config outside NixOS

Use normal home-directory paths outside NixOS:

```sshconfig
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.local/share/sops/keys_gh
  IdentitiesOnly yes

Host codeberg.org
  HostName codeberg.org
  User git
  IdentityFile ~/.local/share/sops/keys_codeberg
  IdentitiesOnly yes

Host tangled.sh
  HostName tangled.org
  User git
  IdentityFile ~/.local/share/sops/keys_tangled
  IdentitiesOnly yes
```

Set permissions:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config ~/.local/share/sops/keys_*
```

## Check secrets

```bash
SOPS_AGE_KEY_FILE=$(pwd)/age.txt nix shell nixpkgs#sops -c sops -d conf/secrets/owais.yaml >/dev/null
ls -l /run/secrets/keys_*
ls -l /run/secrets/umans_key
ssh -T git@github.com
```

On non-NixOS, check the extracted key path instead of `/run/secrets/`.

## Common failure modes

If SOPS cannot decrypt, check that `SOPS_AGE_KEY_FILE` points at the right age
key.

If NixOS rebuild fails on secrets, check that `/var/lib/sops-nix/key.txt` exists
on that machine.

If SSH ignores a key, check file permissions and confirm that the `IdentityFile`
path matches the distro.
