# Git Forge

Forgejo runs on Baxcalibur at `https://git.desertthunder.dev`.

Public repositories may be readable over HTTPS. Writes, admin access, private
repositories, SSH remotes, and private LFS paths stay on the tailnet.

Tracked implementation tasks stay in `TODO.md`. This page is the durable
service shape and operating model.

## Current Shape

| Area                  | Value                            |
| --------------------- | -------------------------------- |
| Module                | `conf/services/forgejo.nix`      |
| Host                  | `nix-baxcalibur`                 |
| Local URL             | `127.0.0.1:3030`                 |
| Public URL            | `https://git.desertthunder.dev/` |
| Database              | Local PostgreSQL                 |
| State                 | `/var/lib/forgejo`               |
| Public ingress        | Cloudflare Tunnel                |
| Private control plane | Tailscale                        |
| Registration          | Disabled                         |

## Boundaries

| Path                       | Policy                                             |
| -------------------------- | -------------------------------------------------- |
| Public HTTPS reads         | Cloudflare Tunnel to local Forgejo.                |
| Writes                     | SSH over the tailnet.                              |
| Admin/private repositories | Tailnet first.                                     |
| LFS writes                 | Tailnet path to avoid Cloudflare free-tier limits. |
| SSH port                   | Shared system port `22`, separated by SSH user.    |

The Cloudflare tunnel should only route the intended hostname and return `404`
for unmatched hostnames.

## Client Model

| Client         | Expected path                                            |
| -------------- | -------------------------------------------------------- |
| Desktop        | Normal Git over SSH to Baxcalibur’s tailnet name.        |
| Android/Termux | Git and OpenSSH over Tailscale.                          |
| Obsidian vault | Repository-local sync helper once the vault repo exists. |

Use per-device SSH keys. They are easier to revoke than copied private keys
when a device or Termux install is retired.

## SSH Remotes

Forgejo advertises SSH clone URLs with:

| Field | Value            |
| ----- | ---------------- |
| Host  | `nix-baxcalibur` |
| Port  | `22`             |
| User  | `forgejo`        |

Repository remotes should look like:

```bash
git remote set-url origin forgejo@nix-baxcalibur:USER/REPO.git
```

If using a client-side SSH alias, keep the alias device-local and point it at
the same tailnet hostname.

## Checks

| Check        | Command                         |
| ------------ | ------------------------------- |
| Service      | `systemctl status forgejo`      |
| Recent logs  | `journalctl -u forgejo -e`      |
| Tailnet SSH  | `ssh -T nix-baxcalibur-forgejo` |
| Remote shape | `git remote -v`                 |

NixOS restarts `forgejo.service` when generated service configuration changes.
If a rebuild succeeds but the UI still shows old customization, restart the
service explicitly.

## References

- Forgejo: <https://forgejo.org/docs/latest/admin/config-cheat-sheet/>
- NixOS module:
  <https://github.com/NixOS/nixpkgs/blob/nixos-26.05/nixos/modules/services/misc/forgejo.nix>
- Forgejo customization:
  <https://forgejo.org/docs/latest/admin/advanced/customization/>
- Cloudflare Tunnel:
  <https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/>
- Tailscale: <https://tailscale.com/docs/concepts/tailnet>
- Termux: <https://termux.dev/>
