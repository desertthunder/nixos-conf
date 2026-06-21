# Services

Self-hosted service planning lives here. Machine-specific NixOS wiring still
belongs under `conf/machines/`; reusable service modules should live under
`conf/modules/services/`.

## Shared baseline

`conf/shared.nix` enables baseline services and client tools for every host.

Tailscale is enabled with its firewall port open for direct tailnet
connections. The shared desktop package set installs Trayscale as a GUI wrapper
around the Tailscale CLI.

After a fresh install or rebuild on a new machine, authenticate the node:

```bash
sudo tailscale up
tailscale status
```

The Tailscale admin console owns tailnet policy such as MagicDNS, HTTPS, ACLs,
and device approval.

Home Manager installs shared desktop applications for `owais`, including
Obsidian. See [Obsidian](./programs/obsidian.md) for the note-taking workflow.

## Services

- [Git Forge](./services/git-forge.md): Forgejo on Baxcalibur.
- [Kavita](./services/kavita.md): comics, manga, ebooks, and PDFs on
  Baxcalibur.
