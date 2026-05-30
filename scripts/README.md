<!-- markdownlint-disable MD033 -->
# Scripts

Shell utilities kept as standalone scripts. They are documented here and are not planned to be ported into the Go CLIs.

The Go binaries have separate responsibilities:

- `dotfiler` handles machine setup, packages, dotfiles, and SOPS secrets.
- `dottools` may grow new utilities later, but the existing scripts remain directly executable.

## Dependencies

Scripts expect these tools to be available through `lib/nix/modules/home-manager/home.nix` on NixOS or `dotfiler` on non-Nix machines:

- **gum** — TUI components for shell scripts
- **dust** — disk usage analyzer with ASCII tree visualization
- **rg** — fast recursive file/content search
- **curl**, **jq**, **git** — required by the sparse clone helper

## Scripts

### `analyze-disk.sh`

Interactive disk storage report. Helps identify what is consuming space. Read-only.

```sh
scripts/analyze-disk.sh [-h] [-d DIR] [-m MODE]
```

Modes:

- `overview` — top space consumers via `dust`
- `large` — files above a chosen size threshold
- `search` — filename or content search
- `all` — all modes

### `analyze-project.sh`

Gitignore-aware source analyzer for lines of code, word counts, file counts, and large files.

```sh
scripts/analyze-project.sh [-h] [-d DIR] [-m MODE] [-t LINES]
```

Modes:

- `loc` — lines of code per file type
- `words` — word count per file type
- `files` — file count per file type
- `big` — files exceeding the line threshold
- `all` — all modes

### `gc-sparse.sh`

GitHub sparse clone helper. Fetches a repo tree, optionally prompts for a path, and sparse-clones only that path.

```sh
scripts/gc-sparse.sh --url <github-url> [--path <dir>] [--dest <dir>]
```

Set `GITHUB_TOKEN` to avoid low unauthenticated API limits.

## Secrets

Use `dotfiler` directly for SOPS key extraction.

```sh
dotfiler secrets extract-ssh
```
