# Obsidian

Obsidian is installed for `owais` by Home Manager from `conf/shared.nix`.

The shared package set applies to every NixOS host in this flake, so both
`nix-haxorus` and `nix-baxcalibur` receive the desktop app after rebuild.

Verify:

```bash
obsidian --version
```

Vault sync is planned to use the private Forgejo repository on Baxcalibur over
Tailscale SSH. Keep device-local Obsidian state out of that repository with a
vault `.gitignore`.
