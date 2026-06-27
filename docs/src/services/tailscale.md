# Tailscale

Tailscale is the private network layer. It gives trusted devices stable tailnet
identity, MagicDNS names, and encrypted paths to private services.

## Ownership

| Layer                   | Owns                                                           |
| ----------------------- | -------------------------------------------------------------- |
| `conf/shared.nix`       | Enables `tailscaled`, opens firewall, installs CLI.            |
| Tailscale admin console | MagicDNS, HTTPS, device approval, expiry, users, groups, ACLs. |
| Service pages           | How individual services use tailnet access.                    |

## How This Repo Uses It

| Use                          | Policy                                          |
| ---------------------------- | ----------------------------------------------- |
| Hostnames                    | Prefer MagicDNS names such as `nix-baxcalibur`. |
| Git writes                   | Use SSH over the tailnet.                       |
| Forgejo private/admin access | Keep on the tailnet.                            |
| Kavita                       | Publish private HTTPS through Tailscale Serve.  |
| Public exposure              | Use Funnel only when intentionally needed.      |

## Host Setup

After a rebuild on a new host, authenticate once with `sudo tailscale up`.
Approve the device in the admin console if the tailnet requires it.

For long-lived servers, disable key expiry only after confirming the device
identity. Do not disable expiry for casual clients by default.

## Checks

| Check            | Command                       |
| ---------------- | ----------------------------- |
| Daemon           | `systemctl status tailscaled` |
| Tailnet state    | `tailscale status`            |
| Local tailnet IP | `tailscale ip`                |
| MagicDNS         | `tailscale ip nix-baxcalibur` |
| SSH path         | `ssh owais@nix-baxcalibur`    |
| Serve routes     | `tailscale serve status`      |

## Serve

Use Serve for private HTTPS access to a local service. The usual shape is a
tailnet HTTPS endpoint forwarding to a service bound on `127.0.0.1`.

| Service                   | Local endpoint     | Exposure         |
| ------------------------- | ------------------ | ---------------- |
| Kavita                    | `127.0.0.1:5000`   | Tailscale Serve  |
| Forgejo admin/private use | `127.0.0.1:3030`   | Tailnet first    |
| Tangled Knot SSH          | system SSH on `22` | Tailnet SSH path |

Funnel is public internet exposure. Treat it as temporary or explicitly
intentional service policy, not the default.

## Troubleshooting

| Symptom                   | Check                                                       |
| ------------------------- | ----------------------------------------------------------- |
| Name does not resolve     | MagicDNS enabled, client on correct tailnet, device online. |
| SSH hangs                 | ACLs, MagicDNS result, and target `sshd`.                   |
| Serve URL missing         | Tailnet HTTPS enabled and Serve route configured.           |
| Device repeatedly expires | Admin console expiry policy for that node.                  |

## References

- Tailscale Linux install: <https://tailscale.com/docs/install/linux>
- Tailscale CLI: <https://tailscale.com/docs/reference/tailscale-cli>
- MagicDNS: <https://tailscale.com/docs/features/magicdns>
- Tailscale Serve: <https://tailscale.com/docs/features/tailscale-serve>
- Access controls: <https://tailscale.com/docs/features/access-control/acls>
