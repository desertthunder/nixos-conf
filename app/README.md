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

`dottools` is a utility CLI scaffold. Existing shell scripts in `../scripts/` remain standalone and documented in `../scripts/README.md`.

After installation, use:

```sh
dottools --help
```

## site

`site` is the custom static site generator for this repo's docs.

Stack:

- Go templates
- Markdown content with front matter
- well-structured vanilla CSS
- Alpine.js for small interactions
- Pagefind for static search

After installation, use:

```sh
site --help
site preview
```

## Design

- Cobra for CLI commands
- Charm log for structured logging
- Lip Gloss for terminal styling/colors
- shared `internal/cli` package with unit structs per binary
- package-manager-native installs where possible
- idempotent file operations
- explicit `plan` before `apply`
