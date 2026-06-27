# Services

Self-hosted service documentation lives here. Service pages should describe the
operating model: ownership, boundaries, access paths, checks, and failure modes.

Implementation details stay in `conf/services/` and host imports stay under
`conf/machines/`.

## Shared Baseline

| Service area | Baseline                                           |
| ------------ | -------------------------------------------------- |
| Tailscale    | Enabled on every NixOS host with firewall support. |
| OpenSSH      | Enabled on every NixOS host.                       |
| PostgreSQL   | Local development database baseline.               |
| Redis        | Local development cache baseline.                  |
| Docker       | Local container runtime baseline.                  |

## Service Pages

| Page                                    | Scope                                                 |
| --------------------------------------- | ----------------------------------------------------- |
| [Tailscale](./services/tailscale.md)    | Private network, MagicDNS, Serve, and tailnet policy. |
| [Git Forge](./services/git-forge.md)    | Forgejo on Baxcalibur.                                |
| [Kavita](./services/kavita.md)          | Comics, manga, ebooks, and PDFs on Baxcalibur.        |
| [Tangled Knot](./services/tngl-knot.md) | Tangled knot and SSH guard on Baxcalibur.             |
