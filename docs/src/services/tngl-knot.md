# Tangled Knot

The [Tangled](https://tangled.org) knot runs on Baxcalibur at `https://knot.desertthunder.dev`.

This service hosts the repositories and SSH guard for the ATproto identity that owns the knot.

## Current State

The owner is configured as `did:plc:xg2vq45muivyy3xwatcehspu`, my ATproto handle `desertthunder.dev`.

If the handle changes to a different DID, update `desert.services.tangledKnot.ownerDid`.

## Boundaries

Cloudflare Tunnel fronts public HTTPS for `knot.desertthunder.dev` and maps it
to `http://127.0.0.1:5555`.

SSH uses the normal system `sshd` on port `22`.

The upstream Tangled module adds a `Match User git` block that uses `knot keys` as `AuthorizedKeysCommand`, so
Tangled-managed SSH keys authorize Git access for the `git` user.

Client machines use the `nix-baxcalibur-knot` SSH alias for Tailscale-friendly
Git remotes.

That alias connects to the MagicDNS hostname `nix-baxcalibur` as
`git` and uses the sops-managed Tangled key.

Forgejo also uses SSH on Baxcalibur, but it uses the `forgejo` user. The two
services share port `22` by separating users:

- Forgejo remotes: `forgejo@nix-baxcalibur:USER/REPO.git`
- Tangled knot remotes: `nix-baxcalibur-knot:USER/REPO.git`

Use Tangled's repository path when setting the remote. For example:

```bash
git remote set-url origin nix-baxcalibur-knot:USER/REPO.git
```

## Checks

```bash
systemctl status knot
journalctl -u knot -e
ssh -T git@nix-baxcalibur
```

Check the public HTTPS endpoint that Tangled sees:

```bash
curl 'https://knot.desertthunder.dev/xrpc/sh.tangled.knot.version'
```

If Tangled shows "The knot hosting this repository is unreachable" but the knot
version endpoint and repo endpoints work, Tangled's mirror may need to re-crawl
the repo. Ask the mirror to subscribe to the knot and ensure the repo record:

```bash
curl -X POST 'https://mirror.tangled.network/xrpc/sh.tangled.sync.requestCrawl' \
  -H 'content-type: application/json' \
  --data '{
    "hostname": "knot.desertthunder.dev",
    "ensureRepo": "at://did:plc:xg2vq45muivyy3xwatcehspu/sh.tangled.repo/garden"
  }'
```

Then re-check the mirror endpoint Tangled's overview page uses for README rendering:

```bash
curl 'https://mirror.tangled.network/xrpc/sh.tangled.git.temp.getBlob?repo=did:plc:r5jqwa23vgiar6cvmoeuqkvl&ref=main&path=README.md'
```

For other repositories, replace the `ensureRepo` AT URI with that repo's
`sh.tangled.repo` record URI and replace the `repo` query parameter with its
repo DID.

## References

- Tangled knot self-hosting guide: <https://docs.tangled.org/knot-self-hosting-guide#nixos>
- Upstream Knot NixOS module: <https://tangled.org/tangled.org/core/blob/master/nix/modules/knot.nix>
- Tangled flake: <https://tangled.org/@tangled.org/core>
