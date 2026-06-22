# Dotfiles

## SOPS without NixOS

Use the local age key with the encrypted file under `conf/secrets/`:

```bash
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
nix shell nixpkgs#sops -c sops -d conf/secrets/owais.yaml
```

Extract Git SSH keys manually:

```bash
mkdir -p ~/.local/share/sops
for key in keys_gh keys_codeberg keys_tangled; do
  nix shell nixpkgs#sops -c sops --extract "[\"$key\"]" -d conf/secrets/owais.yaml \
    > ~/.local/share/sops/$key
done
chmod 600 ~/.local/share/sops/keys_*
```

Or run:

```bash
./conf/scripts/keys.sh
```

For NixOS, the same secrets are exposed through `/run/secrets/` by `sops-nix`.
