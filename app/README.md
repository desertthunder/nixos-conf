# app

Go CLIs for this repo.

## dotfiler

`dotfiler` is the planned non-Nix setup tool.

It aims to provide deterministic-ish setup for:

- macOS without Nix
- Ubuntu
- Fedora

NixOS remains managed by the repo flake.

## Commands

```sh
go run ./cmd/dotfiler --help
go run ./cmd/dotfiler doctor
go run ./cmd/dotfiler plan
go run ./cmd/dotfiler apply --dry-run
```

## dottools

`dottools` is the planned replacement for maintenance scripts in `../scripts/`.

```sh
go run ./cmd/dottools --help
go run ./cmd/dottools disk
go run ./cmd/dottools project
go run ./cmd/dottools sparse --url https://github.com/owner/repo --path src
```

## site

`site` is the planned custom static site generator for this repo's docs.

Planned stack:

- Go templates
- Markdown content with front matter
- well-structured vanilla CSS
- Alpine.js for small interactions
- Pagefind for static search

Planned commands:

```sh
go run ./cmd/site build
go run ./cmd/site serve
go run ./cmd/site check
```

## Design

- Cobra for CLI commands
- Charm log for structured logging
- Lip Gloss for terminal styling/colors
- shared `internal/cli` package with unit structs per binary
- package-manager-native installs where possible
- idempotent file operations
- explicit `plan` before `apply`
