# TODOs

## Parking Lot

- [ ] Switch Zed to unstable channel

## Machines

- [ ] Setup Dragonite & make sure it uses Alacritty instead of Ghostty

## Services

### Git Forge

Forgejo on Baxcalibur at `https://git.desertthunder.dev`.

Public repos may be readable over HTTPS; writes/admin/private repos stay on the tailnet.

References:

- Forgejo: <https://forgejo.org/docs/latest/admin/config-cheat-sheet/>
- NixOS module: <https://github.com/NixOS/nixpkgs/blob/nixos-26.05/nixos/modules/services/misc/forgejo.nix>
- Cloudflare Tunnel: <https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/>
- Tailscale: <https://tailscale.com/docs/concepts/tailnet>
- Termux: <https://termux.dev/>

Build:

- [x] Add `conf/services/forgejo.nix`; import it from Baxcalibur.
- [x] Run Forgejo on `127.0.0.1:3030` with `ROOT_URL = "https://git.desertthunder.dev/"`.
  - [x] Use local PostgreSQL
  - [x] Enable LFS with local backed-up storage and sops-managed secrets.
  - [x] Disable open registration.
  - [ ] Create the admin user and private Obsidian vault repo.
- [x] Publish HTTPS through Cloudflare Tunnel only.
  - [x] Create a locally-managed Cloudflare Tunnel.
  - [x] Add the tunnel credentials JSON to sops as `cloudflare_git_forge_tunnel_credentials`.
  - [x] Set `cloudflareTunnel.enable = true` and `cloudflareTunnel.tunnelId`.
  - [x] Route `git.desertthunder.dev` to the tunnel.
- [ ] Keep SSH/admin/write paths on Tailscale only.
- [ ] Enable MagicDNS; use Baxcalibur's tailnet name for SSH remotes.
- [ ] Add Tailscale ACLs for Baxcalibur SSH, Forgejo SSH, and private LFS paths.

Client workflow:

- [ ] Desktop: `git pull --ff-only`, edit, commit, push.
- [ ] Android: use Termux + `git` + `openssh`; sync over Tailscale SSH.
  - Add `./sync` shell script to the obsidian repo
- [ ] Add vault `.gitignore` for `.obsidian/workspace*.json`, `.trash/`, caches, and device-local plugin state.
- [ ] Test clone/edit/push/pull on macOS, Linux (Fedora), & Android

LFS:

- [ ] Do not send large LFS writes through Cloudflare free tier.
- [ ] Test LFS over the tailnet.
  - [ ] Override `git config lfs.url` if Forgejo advertises the public Cloudflare URL.

Operations:

- [ ] Back up PostgreSQL, `/var/lib/forgejo`, LFS objects, and Forgejo secrets.
- [ ] Test restore onto a fresh machine before relying on it.
- [ ] Add uptime check for `https://git.desertthunder.dev`.
- [ ] Add tailnet `git ls-remote` check for the private push path.
- [ ] Monitor disk usage for repos, LFS, and dumps.
- [ ] Configure Baxcalibur for static DHCP and BIOS/UEFI restore-after-power-loss.
- [ ] Avoid automatic reboots outside maintenance windows.

### Kavita

Kavita on Baxcalibur for comics, manga, ebooks, and PDFs.

Access is tailnet-first.

Use Tailscale Serve for private access and Tailscale Funnel only when the
library intentionally needs temporary public HTTPS access.

References:

- Kavita: <https://github.com/Kareadita/Kavita>
- Kavita docs: <https://wiki.kavitareader.com/getting-started/>
- NixOS module: <https://github.com/NixOS/nixpkgs/blob/nixos-26.05/nixos/modules/services/web-apps/kavita.nix>
- Tailscale Serve: <https://tailscale.com/docs/reference/tailscale-cli/serve>
- Tailscale Funnel: <https://tailscale.com/docs/features/tailscale-funnel>

Build:

- [x] Add `conf/services/kavita.nix`; import it from Baxcalibur.
- [x] Enable `services.kavita`.
- [x] Store Kavita state in `/var/lib/kavita`.
- [x] Generate a 512+ bit `TokenKey`; manage it with sops.
- [x] Run Kavita on `127.0.0.1:5000`.
- [x] Add conservative systemd resource limits for scans/imports.
- [x] Create the initial admin user from the web UI.
- [ ] Configure libraries and scan schedules.

Access:

- [ ] Enable MagicDNS and HTTPS for the tailnet.
- [ ] Publish private HTTPS with Tailscale Serve.
- [ ] Add Tailscale ACLs so only expected users/devices can reach Kavita.
- [ ] Keep Funnel disabled by default.
- [ ] If Funnel is needed, expose only Kavita's HTTPS endpoint and disable it after use.
- [ ] Test reader access on macOS, Linux, Android, and iPad/tablet if applicable.
- [ ] Test OPDS or third-party clients if wanted.

Operations:

- [ ] Back up `/var/lib/kavita`, especially `config/kavita.db`, covers, settings, and logs.
- [ ] Back up media separately.
- [ ] Test restore onto a fresh machine before relying on it.
- [ ] Add tailnet uptime check for Kavita.
- [ ] Add optional public Funnel check only while Funnel is enabled.
- [ ] Monitor disk usage for media, covers, cache, and database.
- [ ] Keep new downloads in an inbox and only move organized files into Kavita library roots.
- [ ] Avoid automatic reboots during library scans or imports.
