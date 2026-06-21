# Git Forge

Forgejo runs on Baxcalibur at `https://git.desertthunder.dev`.

Public repositories may be readable over HTTPS. Writes, admin access, private
repositories, SSH remotes, and private LFS paths stay on the tailnet.

Tracked implementation tasks stay in `TODO.md`. This page is the durable service
shape and operating model.

## Current State

Forgejo is enabled from `conf/services/forgejo.nix` and imported by Baxcalibur.

- Local URL: `127.0.0.1:3030`
- Public URL: `https://git.desertthunder.dev/`
- Database: local PostgreSQL
- State: `/var/lib/forgejo`
- Forgejo LFS storage on local backed-up disk
- secrets: sops-managed
- public ingress: Cloudflare Tunnel

Open registration is disabled.

## Boundaries

Cloudflare Tunnel is only for public HTTPS reads.

The Cloudflare tunnel maps `git.desertthunder.dev` to `http://127.0.0.1:3030` and returns `404` for unmatched hostnames.

Tailscale is the private control plane:

- SSH remotes use Baxcalibur's tailnet name.
- Admin and private repository access stay on the tailnet.
- LFS writes stay on the tailnet to avoid Cloudflare free-tier limits.
- ACLs should distinguish Baxcalibur SSH, Forgejo SSH, and private LFS access.

MagicDNS and tailnet HTTPS are configured as well.

## Customization

Most customization happens through `services.forgejo.settings` in `conf/services/forgejo.nix`.
Those settings render to Forgejo's `app.ini` and are the supported customization surface.

After changing `services.forgejo.settings`, remember to rebuild/redeploy.

NixOS will restart `forgejo.service` when the generated service configuration or
referenced config files change. If the rebuild succeeds but the UI still shows
old text, restart it explicitly:

```bash
sudo systemctl restart forgejo
```

Then check:

```bash
systemctl status forgejo
```

## Client model

Desktop clients use normal Git over the private remote: pull fast-forward only,
edit, commit, and push.

Android uses Termux with `git` and `openssh` over Tailscale SSH. The Obsidian
vault repository should include its own `./sync` helper once the repository
exists.

The vault repository should ignore device-local Obsidian state such as
workspace files, trash, caches, and plugin state that should not sync across
machines.

## SSH Keys

Forgejo is configured to advertise SSH clone URLs with:

- SSH host: `nix-baxcalibur`
- SSH port: `22`
- SSH user: the Forgejo run user, normally `forgejo`

That means repository remotes should look like:

```bash
git remote set-url origin forgejo@nix-baxcalibur:USERNAME/REPO.git
```

Use Tailscale on each client so `nix-baxcalibur` resolves over MagicDNS.

On any machine, create a dedicated key if one does not already exist:

```bash
ssh-keygen -t ed25519 -a 100 -f ~/.ssh/id_ed25519_forgejo -C "$(whoami)@$(hostname)-forgejo"
```

Add a client-side SSH config entry:

```sshconfig
Host nix-baxcalibur-forgejo
  HostName nix-baxcalibur
  User forgejo
  Port 22
  IdentityFile ~/.ssh/id_ed25519_forgejo
  IdentitiesOnly yes
```

Then print the public key and add it in Forgejo under `Settings -> SSH / GPG Keys -> Add Key`:

```bash
cat ~/.ssh/id_ed25519_forgejo.pub
```

After the key is saved, test authentication:

```bash
ssh -T nix-baxcalibur-forgejo
```

For repositories that should use the SSH config alias, set remotes like:

```bash
git remote set-url origin nix-baxcalibur-forgejo:OWAIS_OR_ORG/REPO.git
```

Do not copy a private SSH key between devices unless you intentionally want one
shared device identity. Per-device keys are easier to revoke from Forgejo when a
laptop, phone, or Termux install is retired.

## References

- Forgejo: <https://forgejo.org/docs/latest/admin/config-cheat-sheet/>
- NixOS module:
  <https://github.com/NixOS/nixpkgs/blob/nixos-26.05/nixos/modules/services/misc/forgejo.nix>
- Forgejo interface customization:
  <https://forgejo.org/docs/latest/admin/advanced/customization/>
- Cloudflare Tunnel:
  <https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/>
- Cloudflare locally-managed tunnel:
  <https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/do-more-with-tunnels/local-management/create-local-tunnel/>
- Cloudflare tunnel configuration:
  <https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/do-more-with-tunnels/local-management/configuration-file/>
- Tailscale: <https://tailscale.com/docs/concepts/tailnet>
- Termux: <https://termux.dev/>
