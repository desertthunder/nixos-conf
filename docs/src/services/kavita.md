# Kavita

Kavita runs on Baxcalibur for comics, manga, ebooks, and PDFs.

Access is tailnet-first. Use Tailscale Serve for private HTTPS access and
Tailscale Funnel only when the library intentionally needs temporary public
access.

## Shape

Kavita state and media should be treated separately. State contains app config,
library metadata, covers, settings, logs, and the SQLite database. Media is the
book/comic/manga library itself and should have its own backup and storage
policy.

The local module sets conservative service limits:

- `MemoryMax=1G`
- `CPUQuota=150%`
- `IOSchedulingClass=best-effort`
- `IOSchedulingPriority=6`

These limits are mainly for first scans, cover generation, and imports. Idle
load should be modest.

## Rebuild

After switching:

```bash
systemctl status kavita
journalctl -u kavita -f
curl http://127.0.0.1:5000/site.webmanifest
```

## Media Layout

Do not point Kavita at `~/Documents` or `~/Downloads`. Keep a staging inbox and
only move organized files into Kavita's library roots:

```text
/srv/media/inbox
/srv/media/books
/srv/media/comics
/srv/media/manga
```

Kavita should scan only the real library roots, not the inbox.

Recommended layout:

```text
/srv/media/books/Author or Collection/Book Title.epub
/srv/media/books/Author or Collection/Book Title.pdf
/srv/media/comics/Series Name/Series Name v01 - Volume Title.pdf
/srv/media/comics/Series Name/Series Name 001.cbz
/srv/media/manga/Series Name/Series Name v01.cbz
```

For comics and manga, use series folders. For books, author or collection
folders are not strictly required, but they keep the library easier to maintain.

Move it into the library roots with:

```bash
sudo mkdir -p /srv/media/books /srv/media/comics
sudo cp -a ~/Downloads/inbox/kavita-ready/books/. /srv/media/books/
sudo cp -a ~/Downloads/inbox/kavita-ready/comics/. /srv/media/comics/
sudo chmod -R a+rX /srv/media/books /srv/media/comics
```

After verifying Kavita can scan the `/srv/media` copies, remove the staged copy:

```bash
rm -r ~/Downloads/inbox/kavita-ready
```

## Client model

Primary readers should use the tailnet URL from desktop, Android, and tablet
clients. OPDS or third-party clients can be added later if they are useful, but
the web UI is the baseline supported client.

The initial admin user is created from the web UI after the service is first
available. Library scan schedules should avoid maintenance windows and large
media-copy operations.

Android access path:

1. Install Tailscale.
2. Sign in to the same tailnet.
3. Open the Kavita HTTPS URL from `tailscale serve status`.
4. Use the browser's "Add to Home screen" flow if an app-like shortcut is useful.

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
