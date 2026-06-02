# SSH

## What this config does

Home Manager writes SSH host entries for GitHub, Codeberg, and Tangled. On NixOS
the keys come from `/run/secrets/` through `sops-nix`.

## Nix location

- `conf/shared.nix`: `programs.ssh`
- `conf/shared.nix`: `sops.secrets`
- `conf/secrets/owais.yaml`: encrypted key material

## NixOS paths

```sshconfig
Host github.com
  HostName github.com
  User git
  IdentityFile /run/secrets/keys_gh
  IdentitiesOnly yes

Host codeberg.org
  HostName codeberg.org
  User git
  IdentityFile /run/secrets/keys_codeberg
  IdentitiesOnly yes

Host tangled.sh
  HostName tangled.org
  User git
  IdentityFile /run/secrets/keys_tangled
  IdentitiesOnly yes
```

The config sets `AddKeysToAgent no` for all hosts.

## Portable setup

Extract the keys first. See [Secrets](../secrets.md).

Use home-directory paths outside NixOS:

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

## Check it

```bash
ssh -T git@github.com
ssh -T git@codeberg.org
ssh -T git@tangled.sh
```

If SSH ignores a key, run:

```bash
ssh -vT git@github.com
```

Check the `Offering public key` lines and confirm the path matches your config.
