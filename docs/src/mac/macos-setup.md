# macOS Without Nix

This repo no longer manages macOS with nix-darwin. macOS machines should use the non-Nix path:

- Homebrew for packages and GUI apps
- portable dotfiles from this repo
- SOPS + age for secrets
- the planned `dotfiler` Go installer in `app/`

NixOS remains managed by `flake.nix`.

## Planned Setup Flow

```sh
# From this repo
cd app
go run ./cmd/dotfiler doctor
go run ./cmd/dotfiler plan
go run ./cmd/dotfiler apply --dry-run
```

Eventually the bootstrap flow should be:

```sh
# install/build dotfiler, then:
dotfiler doctor
dotfiler packages apply
dotfiler dotfiles apply
dotfiler secrets extract-ssh
```

## Package Strategy

Use Homebrew-native package files under the planned `packages/brew/` directory:

```text
packages/brew/Brewfile.common
packages/brew/Brewfile.macbook-air
packages/brew/Brewfile.mac-mini
```

## Secrets

Use SOPS + age with the age key at:

```text
~/.config/sops/age/keys.txt
```

See [SOPS on Non-Nix Machines](../dotfiles/sops.md) for the current manual workflow.

## Removed nix-darwin Path

The previous nix-darwin configuration was intentionally dropped from the active codebase:

- no `nix-darwin` flake input
- no `nixpkgs-darwin` flake input
- no `darwinConfigurations`
- no macOS host under `nix/hosts/`
- no Darwin module under `nix/modules/`
