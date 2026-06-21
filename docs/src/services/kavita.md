# Kavita

Kavita will run on Baxcalibur for comics, manga, ebooks, and PDFs.

Access is tailnet-first. Use Tailscale Serve for private HTTPS access and
Tailscale Funnel only when the library intentionally needs temporary public
access.

Tracked implementation tasks stay in `TODO.md`. This page is the durable service
shape and operating model.

## Shape

Kavita should bind locally on Baxcalibur and be published through Tailscale:

- HTTP app: `127.0.0.1:5000`
- state: `/var/lib/kavita`
- database: `/var/lib/kavita/config/kavita.db`
- media roots: read-only mounts under `/srv/media`
- token key: sops-managed

Kavita state and media should be treated separately. State contains app config,
library metadata, covers, settings, logs, and the SQLite database. Media is the
book/comic/manga library itself and should have its own backup and storage
policy.

## Boundaries

Tailscale Serve is the normal access path. MagicDNS, tailnet HTTPS, and ACLs are
configured in the Tailscale admin console.

Funnel should stay disabled by default. If public access is needed temporarily,
expose only Kavita's HTTPS endpoint and disable Funnel again after the access
window ends.

Media mounts should be read-only from Kavita's perspective. Import, rename, and
library organization work should happen outside the service path so a bad scan
or app bug cannot rewrite the source library.

## Client model

Primary readers should use the tailnet URL from desktop, Android, and tablet
clients. OPDS or third-party clients can be added later if they are useful, but
the web UI is the baseline supported client.

The initial admin user is created from the web UI after the service is first
available. Library scan schedules should avoid maintenance windows and large
media-copy operations.

## Reliability

Backups must cover `/var/lib/kavita`, especially the SQLite database, covers,
settings, and logs. Media backups are separate and should be validated
independently.

Health checks should use the tailnet endpoint. Public Funnel checks only matter
while Funnel is intentionally enabled.

Disk monitoring should account for media, covers, cache, and database growth.
Avoid automatic reboots during imports, scans, or metadata refreshes.

## References

- Kavita: <https://github.com/Kareadita/Kavita>
- Kavita docs: <https://wiki.kavitareader.com/getting-started/>
- NixOS module:
  <https://github.com/NixOS/nixpkgs/blob/nixos-26.05/nixos/modules/services/web-apps/kavita.nix>
- Tailscale Serve: <https://tailscale.com/docs/reference/tailscale-cli/serve>
- Tailscale Funnel: <https://tailscale.com/docs/features/tailscale-funnel>
