# Obsidian

Obsidian is installed for `owais` by Home Manager from `conf/shared.nix`.
The same configuration enables Obsidian's command-line interface. It applies to
both `nix-haxorus` and `nix-baxcalibur` after rebuild.

The Nix package provides both `obsidian` and its `obsidian-cli` helper. Do not
use **Register CLI** in Obsidian's settings. The desktop app runs through the
Nixpkgs Electron wrapper, so Obsidian mistakes the shared `electron` executable
for its launcher. Home Manager already puts the correct commands on `PATH`.

The desktop app must be running before most CLI commands can access a vault.
Verify the CLI with:

```bash
obsidian version
```

Vault sync is planned to use the private Forgejo repository on Baxcalibur over
Tailscale SSH. Keep device-local Obsidian state out of that repository with a
vault `.gitignore`.
