# TODOs

## Parking Lot

## Machines

### Haxorus

Hyprland is the primary desktop. The completed setup includes:

- UWSM-managed desktop services, Polkit authentication, idle locking and
  suspend, clipboard history, SwayOSD, Mako, and Waybar status controls.
- Described Hyprland bindings, searchable `Super-?` help, and a small Ignis
  shortcut widget generated from the same binding data.
- Packaged desktop helpers, shared theme values, and explicit laptop, docked,
  and multi-monitor workspace behavior.
- A restrained charcoal desktop theme built around `wall00.png`, with compact
  Waybar and rofi surfaces, crisp application windows, a background-layer
  shortcut reference, and a matching Hyprlock layout.

References:

- Hyprland UWSM: <https://wiki.hypr.land/Useful-Utilities/Systemd-start/>
- hyprpolkitagent: <https://wiki.hypr.land/Hypr-Ecosystem/hyprpolkitagent/>
- hypridle: <https://wiki.hypr.land/Hypr-Ecosystem/hypridle/>
- cliphist: <https://github.com/sentriz/cliphist>
- SwayOSD: <https://github.com/ErikReider/SwayOSD>
- Ignis: <https://ignis-sh.github.io/ignis/>

#### Verification

- [ ] Test screen sharing, file pickers, authentication prompts, suspend and
      resume, clipboard history, screenshots, and notification actions under
      Hyprland.
- [ ] Review the desktop at laptop resolution and confirm that `wall00.png`
      remains dominant when no windows are open.
- [ ] Confirm that Waybar, rofi, the Ignis widget, Mako, SwayOSD, and Hyprlock
      read as one visual system.
- [ ] Remove any visual element that duplicates information or draws attention
      without helping normal use.

### Dragonite

Set up Dragonite as the lightweight desktop/media-server machine. Use XFCE for
the local desktop, Alacritty as its terminal, and Jellyfin as a native NixOS
service.

References:

- NixOS XFCE: <https://wiki.nixos.org/wiki/Xfce>
- Jellyfin: <https://jellyfin.org/docs/>
- Jellyfin hardware acceleration:
  <https://jellyfin.org/docs/general/post-install/transcoding/hardware-acceleration/>
- NixOS Jellyfin: <https://wiki.nixos.org/wiki/Jellyfin>
- Tailscale Serve: <https://tailscale.com/docs/reference/tailscale-cli/serve>

Machine:

- [ ] Install NixOS and add `conf/machines/dragonite/`.
- [ ] Add `nix-dragonite` to `flake.nix`.
- [ ] Generate and commit Dragonite's `hardware-configuration.nix`.
- [ ] Set `networking.hostName = "nix-dragonite"`.
- [ ] Reuse the shared NixOS and Home Manager configuration where appropriate.
- [ ] Enable XFCE and make it the default graphical session.
  - [ ] Keep the stock XFCE desktop/panel initially instead of recreating the
        Hyprland shell.
  - [ ] Use Thunar for local file management.
- [ ] Use Alacritty instead of Ghostty on Dragonite.
  - [ ] Add a small Dragonite-specific Home Manager module rather than changing
        the shared terminal choice for other machines.
  - [ ] Set XFCE's preferred terminal and terminal shortcut to Alacritty.
- [ ] Enable Tailscale and verify Dragonite is reachable through MagicDNS.
- [ ] Give Dragonite a stable DHCP lease.
- [ ] Configure BIOS/UEFI restore-after-power-loss if the machine supports it.
- [ ] Disable suspend while Jellyfin is serving media; allow display blanking
      independently from system sleep.

Jellyfin:

- [ ] Add `conf/services/jellyfin.nix` and import it only from Dragonite.
- [ ] Enable `services.jellyfin`.
- [ ] Keep Jellyfin state and cache on predictable local paths.
- [ ] Decide and create stable media mount points such as `/srv/media`.
  - [ ] Separate movies, television, music, and an optional ingest directory.
  - [ ] Make media readable by Jellyfin without making the library world
        writable.
  - [ ] Mount storage by UUID or filesystem label rather than `/dev/sdX`.
- [ ] Give the `jellyfin` user access to the Intel render device.
- [ ] Enable Intel hardware transcoding.
  - [ ] Prefer VA-API for the OptiPlex 7010-era Intel GPU.
  - [ ] Verify `/dev/dri/renderD128` exists and is usable by Jellyfin.
  - [ ] Verify supported codecs with `vainfo` before enabling codec options.
  - [ ] Trigger an actual transcode and confirm GPU usage rather than assuming
        hardware acceleration works.
- [ ] Keep direct play/direct stream as the preferred path and use transcoding
      only when clients require it.
- [ ] Verify subtitles that require burn-in do not overwhelm the machine.
- [ ] Test at least one simultaneous local playback and one remote playback.

Access:

- [ ] Keep Jellyfin tailnet-first.
- [ ] Bind Jellyfin normally on Dragonite but restrict access with the host
      firewall and Tailscale policy.
- [ ] Provide private HTTPS through Tailscale Serve if browser HTTPS is useful.
- [ ] Do not expose Jellyfin directly to the public internet by default.
- [ ] Test playback from Linux, Android, and the primary television/streaming
      client.

Operations:

- [ ] Back up Jellyfin configuration, metadata, and database separately from
      replaceable media.
- [ ] Test a Jellyfin restore before treating the library as durable.
- [ ] Monitor free space on the system disk, media disks, cache, and transcode
      directory.
- [ ] Add a tailnet health check for Jellyfin.
- [ ] Confirm Jellyfin starts correctly after reboot without logging into XFCE.
- [ ] Confirm mounted media is available before Jellyfin starts scanning it.
- [ ] Avoid automatic reboots during active playback or library maintenance.

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
