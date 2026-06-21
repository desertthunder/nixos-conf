# Tailscale

Tailscale is the private network layer for this setup.

It gives each trusted device a stable tailnet identity, MagicDNS name, and encrypted path to
other devices without exposing private services to the public internet.

## Current Shape

`conf/shared.nix` enables Tailscale on every NixOS host:

```nix
services.tailscale = {
  enable = true;
  openFirewall = true;
};
```

The shared package set also installs the `tailscale` CLI. NixOS owns the local
daemon and package installation. The Tailscale admin console owns tailnet policy:

- MagicDNS
- tailnet HTTPS
- device approval and expiry
- users, groups, tags, grants, and ACLs
- Serve and Funnel permissions

## How We Use It

Use Tailscale as the default private control plane.

- Hostnames: use MagicDNS names such as `nix-baxcalibur`.
- Git forge writes: use SSH over the tailnet, not public HTTPS.
- Forgejo admin/private access: keep on the tailnet.
- Kavita: publish private web access through Tailscale Serve.

## Setup On NixOS

After installing or rebuilding a host from this flake, confirm the service is enabled:

```bash
systemctl status tailscaled
```

Authenticate the machine into the tailnet:

```bash
sudo tailscale up
```

The command prints a login URL. Open it, sign in, and approve the device if the
tailnet requires approval.

Verify local state:

```bash
tailscale status
tailscale ip
```

Verify MagicDNS from another tailnet device:

```bash
ping nix-baxcalibur
ssh owais@nix-baxcalibur
```

For a server that should remain connected, disable key expiry in the Tailscale
admin console after confirming the device identity. Do this only for trusted
long-lived machines.

## Setup On Other Devices

For another Linux device, install Tailscale using the official package for that
distribution or Tailscale's install script:

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

For Android, install the Tailscale app, sign in to the same tailnet, and keep it
connected when using Termux for Git or SSH workflows.

For macOS, Windows, iOS, and other clients, install the official client, sign in,
then confirm the device appears in the admin console.

After any device joins, test:

```bash
tailscale status
ping nix-baxcalibur
```

## MagicDNS

MagicDNS lets tailnet devices use machine names instead of Tailscale IPs. This
repo assumes MagicDNS is enabled and that Baxcalibur is reachable as
`nix-baxcalibur`.

If a hostname does not resolve:

```bash
tailscale status
tailscale ip nix-baxcalibur
```

Then check the admin console:

- the device is connected
- MagicDNS is enabled
- the machine name is what the docs expect
- the client is signed in to the correct tailnet

## Tailscale Serve

Use Serve for private HTTPS access to local services. Serve routes traffic from
tailnet devices to a local service running on the host.

Example shape for a service bound locally:

```bash
sudo tailscale serve --bg https / http://127.0.0.1:5000
tailscale serve status
```

Serve requires tailnet HTTPS certificates. If HTTPS is not enabled, the CLI can
prompt for the required admin-console consent.

Use Funnel only when a service intentionally needs public internet access. Funnel
is not the default for this repo.

## References

- Tailscale Linux install:
  <https://tailscale.com/docs/install/linux>
- Tailscale CLI:
  <https://tailscale.com/docs/reference/tailscale-cli>
- MagicDNS:
  <https://tailscale.com/docs/features/magicdns>
- Tailscale Serve:
  <https://tailscale.com/docs/features/tailscale-serve>
- Access controls:
  <https://tailscale.com/docs/features/access-control/acls>
