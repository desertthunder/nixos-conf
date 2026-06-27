# SSH

Home Manager writes SSH host entries for GitHub, Codeberg, Tangled, Forgejo, and
the Tangled Knot. On NixOS, identities come from SOPS-Nix paths under
`/run/secrets`.

## Host Aliases

| Host                     | User  | Identity        | Purpose                      |
| ------------------------ | ----- | --------------- | ---------------------------- |
| `github.com`             | `git` | `keys_gh`       | GitHub remotes               |
| `codeberg.org`           | `git` | `keys_codeberg` | Codeberg remotes             |
| `tangled.sh`             | `git` | `keys_tangled`  | Tangled hosted remotes       |
| `knot.desertthunder.dev` | `git` | `keys_tangled`  | Knot host                    |
| `nix-baxcalibur-knot`    | `git` | `keys_tangled`  | Tailnet Tangled Knot remotes |

The shared config sets `IdentitiesOnly yes` and `AddKeysToAgent no`.

## Secret Paths

| Environment | Path style                   |
| ----------- | ---------------------------- |
| NixOS       | `/run/secrets/keys_*`        |
| Non-NixOS   | `~/.local/share/sops/keys_*` |

See [Secrets](../secrets.md) for extraction and permissions. This page should
not duplicate the SOPS workflow.

## Validate

| Check                 | Command                      |
| --------------------- | ---------------------------- |
| GitHub auth           | `ssh -T git@github.com`      |
| Codeberg auth         | `ssh -T git@codeberg.org`    |
| Tangled auth          | `ssh -T git@tangled.sh`      |
| Knot over tailnet     | `ssh -T nix-baxcalibur-knot` |
| Debug identity choice | `ssh -vT git@github.com`     |

When debugging, look for `Offering public key` and confirm the path matches the
configured identity.
