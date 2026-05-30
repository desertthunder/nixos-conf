# app

Go CLIs for this repo.

## dotfiler

`dotfiler` is the non-Nix setup tool for macOS, Ubuntu, and Fedora.

NixOS remains managed by the repo flake.

After installation, use:

```sh
dotfiler --help
```

## dottools

`dottools` is the planned replacement for maintenance scripts in `../scripts/`.

After installation, use:

```sh
dottools --help
```

## site

`site` is the planned custom static site generator for this repo's docs.

Planned stack:

- Go templates
- Markdown content with front matter
- well-structured vanilla CSS
- Alpine.js for small interactions
- Pagefind for static search

After installation, use:

```sh
site --help
```

## Design

- Cobra for CLI commands
- Charm log for structured logging
- Lip Gloss for terminal styling/colors
- shared `internal/cli` package with unit structs per binary
- package-manager-native installs where possible
- idempotent file operations
- explicit `plan` before `apply`
