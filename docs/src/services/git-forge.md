# Git Forge

Forgejo will run on Baxcalibur at `https://git.desertthunder.dev`.

Public repositories may be readable over HTTPS. Writes, admin access, private
repositories, SSH remotes, and private LFS paths stay on the tailnet.

Tracked implementation tasks stay in `TODO.md`. This page is the durable service
shape and operating model.

## Shape

Forgejo should bind locally on Baxcalibur and sit behind explicit access paths:

- HTTP app: `127.0.0.1:3030`
- canonical public URL: `https://git.desertthunder.dev/`
- database: local PostgreSQL
- persistent state: `/var/lib/forgejo`
- large files: Forgejo LFS storage on local backed-up disk
- secrets: sops-managed

Open registration should stay disabled. The first expected private repository is
the Obsidian vault.

## Boundaries

Cloudflare Tunnel is only for public HTTPS reads. It should not become the
default write, admin, SSH, or large-file path.

Tailscale is the private control plane:

- SSH remotes use Baxcalibur's tailnet name.
- Admin and private repository access stay on the tailnet.
- LFS writes stay on the tailnet to avoid Cloudflare free-tier limits.
- ACLs should distinguish Baxcalibur SSH, Forgejo SSH, and private LFS access.

MagicDNS and tailnet HTTPS are configured in the Tailscale admin console, not in
this repository.

## Client model

Desktop clients use normal Git over the private remote: pull fast-forward only,
edit, commit, and push.

Android uses Termux with `git` and `openssh` over Tailscale SSH. The Obsidian
vault repository should include its own `./sync` helper once the repository
exists.

The vault repository should ignore device-local Obsidian state such as
workspace files, trash, caches, and plugin state that should not sync across
machines.

## Reliability

Backups must cover PostgreSQL, `/var/lib/forgejo`, LFS objects, and Forgejo
secrets. A restore to a fresh machine should be tested before relying on the
service.

Health checks should cover both public HTTPS reads and private tailnet Git
access. Disk monitoring should account for repository data, LFS objects, and
dumps.

## References

- Forgejo: <https://forgejo.org/docs/latest/admin/config-cheat-sheet/>
- NixOS module:
  <https://github.com/NixOS/nixpkgs/blob/nixos-26.05/nixos/modules/services/misc/forgejo.nix>
- Cloudflare Tunnel:
  <https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/>
- Tailscale: <https://tailscale.com/docs/concepts/tailnet>
- Termux: <https://termux.dev/>
