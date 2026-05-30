# Repo Organization Plan

This repo should support three setup paths:

1. Macs without Nix, such as this machine and the Mac mini
2. Ubuntu/Fedora machines
3. NixOS machines

Core principle:

> Portable dotfiles are canonical. NixOS installs them declaratively. Non-Nix machines install them with scripts. Secrets use SOPS + age everywhere.

## Goals

- [ ] Make non-Nix macOS a first-class use case
- [ ] Make Ubuntu/Fedora bootstrap possible without Home Manager
- [ ] Keep NixOS as the fully declarative path
- [x] Drop nix-darwin from the codebase
- [ ] Use SOPS + age consistently across all platforms
- [ ] Avoid adding git-crypt unless a specific encrypted-binary use case appears
- [ ] Reorganize docs around platform-specific setup paths
- [ ] Confirm all active NixOS machines are on 25.11
- [ ] Decide on dragon-type naming convention for machines, starting with NUC -> Haxorus

## Recommended Top-Level Structure

Target shape:

```text
.
├── flake.nix
├── flake.lock
├── README.md
├── todo.md
├── app/                 # Go installer for non-Nix machines
├── docs/
├── nix/
│   ├── hosts/
│   ├── modules/
│   └── profiles/
├── dotfiles/
├── packages/
│   ├── brew/
│   ├── apt/
│   └── dnf/
├── scripts/
│   ├── bootstrap/
│   ├── secrets/
│   └── maintenance/
├── secrets/
└── archive/
```

This does not need to happen in one pass. Prefer incremental migration.

## Phase 1: Build the Non-Nix Go Installer

The non-Nix setup path should be implemented as a Go CLI in `app/`, with shell scripts reserved only for tiny first-stage bootstrap tasks if needed.

Current scaffold:

```text
app/
├── cmd/
│   ├── dotfiler/main.go
│   └── dottools/main.go
├── internal/
│   ├── cli/
│   ├── runner/
│   ├── system/
│   └── ui/
├── go.mod
├── go.sum
└── README.md
```

Initial dependencies:

- [x] Cobra for CLI commands
- [x] `github.com/charmbracelet/log` for structured logging
- [x] `github.com/charmbracelet/lipgloss` for styling/colors

Planned commands:

- [x] `dotfiler doctor`
- [x] `dotfiler plan`
- [x] `dotfiler apply --dry-run`
- [x] `dotfiler version`
- [x] `dotfiler packages plan`
- [x] `dotfiler packages apply`
- [x] `dotfiler dotfiles plan`
- [x] `dotfiler dotfiles apply`
- [x] `dotfiler secrets check`
- [x] `dotfiler secrets extract-ssh`

Installer design tasks:

- [x] Detect platform: macOS, Ubuntu, Fedora, unsupported Linux
- [x] Detect package manager: `brew`, `apt`, `dnf`
- [x] Add command runner with dry-run support
- [x] Add idempotent file/link operations
- [x] Add backups before overwriting user files
- [x] Defer machine-readable plan output until there is a concrete consumer
- [x] Add repo-root detection
- [x] Add config loading for package lists and dotfile manifests
- [x] Add tests for platform detection and planner behavior
- [x] Keep setup deterministic-ish: explicit package lists, visible plans, no silent mutation

Suggested remaining script layout:

```text
scripts/
├── bootstrap/
│   ├── install.sh
│   └── setup/
│       └── mac.sh
└── maintenance/
    ├── analyze-disk.sh
    ├── analyze-project.sh
    └── gc-sparse.sh
```

### macOS without Nix

Use:

- Homebrew for packages
- normal dotfiles symlinked from `dotfiles/`
- SOPS + age for secrets
- optional `mas` for App Store apps
- no nix-darwin by default

Tasks:

- [x] Create `packages/brew/Brewfile.common`
- [x] Create `packages/brew/Brewfile.macbook-air` if needed
- [x] Create `packages/brew/Brewfile.mac-mini` if needed
- [x] Create `scripts/bootstrap/setup/mac.sh`
- [x] Install Homebrew if missing or print the required manual command
- [x] Run `brew bundle --file packages/brew/Brewfile.common`
- [x] Run machine-specific Brewfile if present
- [x] Link dotfiles through `dotfiler dotfiles apply`
- [x] Extract SSH keys through `dotfiler secrets extract-ssh`

### Ubuntu/Fedora

Use the same portable layer as macOS:

- `dotfiles/`
- `scripts/bootstrap/`
- `scripts/secrets/`
- distro package lists

Tasks:

- [x] Create `packages/apt/packages.txt`
- [x] Create `packages/dnf/packages.txt`
- [x] Implement Ubuntu package installation in `dotfiler packages apply`
- [x] Implement Fedora package installation in `dotfiler packages apply`
- [x] Decide Hyprland is NixOS-only for now, not part of the non-Nix installer path
- [x] Defer Rofi configuration until Hyprland work resumes
- [x] Defer Waybar configuration until Hyprland work resumes
- [x] Install common tools:
    - [x] git
    - [x] curl
    - [x] zsh
    - [x] node/npm
    - [x] age
    - [x] sops
    - [x] ripgrep
    - [x] fzf
    - [x] jq
    - [x] yq
    - [x] zellij
    - [x] neovim
    - [x] gh
    - [x] gum, if available
- [x] Link dotfiles through `dotfiler dotfiles apply`
- [x] Extract SSH keys through `dotfiler secrets extract-ssh`

## Phase 2: Keep NixOS as the Declarative Path

Current NixOS host configs live under `machines/`, and shared modules live under `shared/`. This is workable, but as the repo grows, split by Nix role.

Suggested future structure:

```text
nix/
├── hosts/
│   ├── thinkpad/
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   ├── hp/
│   └── nuc/
├── modules/
│   ├── nixos/
│   │   ├── base.nix
│   │   ├── users.nix
│   │   ├── desktop-gnome.nix
│   │   └── sops.nix
│   └── home-manager/
│       ├── base.nix
│       ├── packages.nix
│       ├── dotfiles.nix
│       └── sops.nix
└── profiles/
    ├── desktop.nix
    ├── dev.nix
    ├── fonts.nix
    └── secrets.nix
```

Tasks:

- [x] Keep current `machines/` and `shared/` until the portable dotfiles layer is stable
- [ ] Fill in HP-specific configuration if that host remains active
- [ ] Fill in NUC-specific configuration if that host remains active
- [ ] Replace placeholder NUC hardware config by running `nixos-generate-config` on the NUC
- [ ] Document HP machine profile in `docs/src/nixos/multi-machine.md`
- [ ] Document NUC machine profile in `docs/src/nixos/multi-machine.md`
- [ ] Later move `machines/*` to `nix/hosts/*`
- [ ] Later split `shared/configuration.nix` into focused NixOS modules
- [ ] Later split `shared/home.nix` into focused Home Manager modules
- [x] Make Home Manager consume canonical files from `dotfiles/`

## Phase 3: Secrets Strategy

Recommendation: keep using SOPS + age.

### Why SOPS + age

- Already integrated with `sops-nix`
- Works on NixOS, macOS, Ubuntu, Fedora, and CI
- Keeps secrets as structured YAML
- Allows extracting individual fields with `sops --extract`
- Recipient management is explicit in `.sops.yaml`
- Better fit for NixOS and Home Manager than git-crypt

### Non-Nix Requirements

Expected age key path:

```text
~/.config/sops/age/keys.txt
```

Common usage:

```sh
export SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"
sops -d secrets/owais.yaml
```

Tasks:

- [ ] Keep `.sops.yaml` as source of recipient configuration
- [ ] Keep `secrets/owais.yaml` encrypted with SOPS
- [x] Add `dotfiler secrets extract-ssh`
- [ ] Add `dotfiler secrets edit`
- [x] Add checks for missing `sops`, `age`, and age key file
- [x] Ensure extracted SSH keys are written with `chmod 600`
- [ ] Document how to restore the age private key from password manager
- [ ] Add machine recipient keys only when needed

### git-crypt Decision

Do not add git-crypt by default.

Use git-crypt only if there is a future need for:

- encrypted binary files
- entire private directories
- files that tools must read directly without a decrypt/extract step

For current SSH keys and structured secrets, SOPS + age is the better fit.

## Phase 4: Migration and Inventory Cleanup

Mac Mini migration tasks that were previously scattered through the docs:

- [ ] Export Homebrew formulae and casks
- [ ] Dump a full Brewfile with dependencies
- [ ] Document ASDF versions from `asdf current` and `~/.tool-versions`
- [ ] List installed applications from `/Applications` and `~/Applications`
- [ ] Back up configuration files before migration
- [ ] Note machine-specific packages
- [ ] Install selected packages from the inventory
- [ ] Restore Homebrew GUI applications
- [ ] Configure ASDF or replace it with the chosen toolchain strategy
- [ ] Test development environment
- [ ] Verify migrated applications
- [ ] Move package inventory material from README/docs into the new docs reference section

## Phase 5: Port Utility Scripts to a Separate Go Binary

The existing `scripts/` directory contains useful maintenance utilities. These should move into a separate Go binary under `app/cmd/`, distinct from `dotfiler`.

Recommended binary name: `dottools`.

Reasoning:

- `dotfiler` should stay focused on machine setup: packages, dotfiles, secrets.
- `dottools` can house day-to-day utilities: disk analysis, project analysis, sparse clone helpers.
- Both binaries can share internal packages for UI, logging, command running, and platform detection.

Current scripts inventory:

| Script | Current purpose | Proposed Go command |
| ------ | --------------- | ------------------- |
| `scripts/analyze-disk.sh` | Interactive disk usage report using `dust`, `rg`, `gum` | `dottools disk` |
| `scripts/analyze-project.sh` | Gitignore-aware LoC/word/file/big-file analyzer | `dottools project` |
| `scripts/gc-sparse.sh` | GitHub sparse clone helper | `dottools sparse` |
| `scripts/keys.sh` | Extract SSH keys from SOPS secrets | Move to `dotfiler secrets extract-ssh` |

Planned `app/` shape:

```text
app/
├── cmd/
│   ├── dotfiler/
│   │   └── main.go
│   ├── dottools/
│   │   └── main.go
│   └── site/
│       └── main.go
└── internal/
    ├── cli/          # dotfiler, dottools, and site CLI package, organized with unit structs
    ├── runner/       # shared subprocess runner
    ├── system/       # shared platform/path helpers
    └── ui/           # shared iceberg/lipgloss styles
```

Tasks:

- [x] Scaffold `app/cmd/dottools/main.go`
- [x] Use one `app/internal/cli` package for both binaries, organized with `Dotfiler` and `Dottools` unit structs
- [x] Add `dottools disk` command stub
- [x] Add `dottools project` command stub
- [x] Add `dottools sparse` command stub
- [ ] Move SOPS key extraction responsibility from `scripts/keys.sh` to `dotfiler secrets extract-ssh`
- [ ] Decide whether to keep shell scripts as wrappers around Go binaries during migration
- [ ] Port project analysis logic without depending on `gum`
- [ ] Port disk analysis as an orchestrator around `dust` and `rg`, at least initially
- [ ] Port sparse clone helper using Go HTTP + GitHub API JSON instead of `curl`/`jq`
- [ ] Update `scripts/README.md` to point to `dottools` once commands exist

---

## Phase 6: Build a Custom Static Site Generator

Replace the mdBook-oriented docs pipeline with a small custom SSG under `app/cmd/site`.

The `site` binary should build the project documentation site using:

- Go templates for layouts and components
- Markdown content with front matter
- Well-structured vanilla CSS
- Alpine.js for small interactive UI behaviors
- Pagefind for static search

Recommended binary name: `site`.

Planned commands:

- [ ] `site build`
- [ ] `site serve`
- [ ] `site clean`
- [ ] `site check`
- [ ] `site pagefind`

Planned `app/` shape:

```text
app/
├── cmd/
│   ├── dotfiler/
│   ├── dottools/
│   └── site/
└── internal/
    ├── cli/          # dotfiler, dottools, and site CLI package, organized with unit structs
    ├── site/         # SSG engine: content loading, rendering, assets, search indexing
    ├── runner/
    ├── system/
    └── ui/
```

Planned site source layout:

```text
site/
├── assets/
│   ├── css/
│   │   ├── style.css
│   │   ├── reset.css
│   │   ├── base.css
│   │   ├── utilities.css
│   │   ├── tokens/
│   │   │   ├── colors.css
│   │   │   ├── type.css
│   │   │   └── spacing.css
│   │   └── components/
│   │       ├── nav.css
│   │       ├── article.css
│   │       ├── callout.css
│   │       └── code.css
│   ├── js/
│   │   └── alpine.js
│   └── images/
├── content/
│   ├── start-here.md
│   ├── platforms/
│   ├── dotfiles/
│   ├── secrets/
│   ├── nix/
│   ├── programs/
│   └── reference/
├── layouts/
│   ├── base.html
│   ├── page.html
│   ├── section.html
│   └── partials/
│       ├── head.html
│       ├── nav.html
│       ├── search.html
│       └── footer.html
└── public/            # generated output; likely gitignored
```

SSG implementation tasks:

- [ ] Scaffold `app/cmd/site/main.go`
- [ ] Add `Site` unit struct to `app/internal/cli`
- [ ] Add `site build` command
- [ ] Add `site serve` command with a local static file server
- [ ] Add `site clean` command
- [ ] Add `site check` command for links/front matter/content errors
- [ ] Add markdown rendering, likely with `goldmark`
- [ ] Add front matter parsing, likely YAML
- [ ] Add Go template loading with partials and shared template funcs
- [ ] Add syntax highlighting strategy for code blocks
- [ ] Copy static assets into output directory
- [ ] Generate section indexes and sidebar navigation from content metadata
- [ ] Generate canonical URLs and stable slugs
- [ ] Generate RSS or Atom later if useful
- [ ] Run Pagefind after build, either by invoking the `pagefind` binary or documenting install requirements
- [ ] Add `data-pagefind-body` to article content templates
- [ ] Add Alpine.js for nav/search toggles and small progressive enhancements only
- [ ] Add `site/README.md` documenting content conventions

Vanilla CSS structure rules:

- [ ] Use semantic HTML first; avoid utility-class-heavy markup
- [ ] Keep `style.css` as imports only
- [ ] Put reset, tokens, base, utilities, and components in separate files
- [ ] Define colors, spacing, type, radii, and shadows as CSS variables
- [ ] Let parent layout components own spacing
- [ ] Use grid/flex and modern CSS before adding breakpoints
- [ ] Keep Alpine.js behavior separate from styling concerns

Docs restructuring for the custom SSG:

- [ ] Decide whether to move `docs/src/*` to `site/content/*` or keep `docs/src` as content input initially
- [ ] Remove mdBook-specific `SUMMARY.md` dependency once `site` can generate navigation
- [ ] Replace `docs/book.toml` with `site` config if needed
- [ ] Convert existing relative links to stable site paths
- [ ] Add front matter to pages: `title`, `description`, `section`, `weight`, `status`
- [ ] Move platform docs under `site/content/platforms/`
- [ ] Move secrets docs under `site/content/secrets/`
- [ ] Move Nix docs under `site/content/nix/`
- [ ] Move program docs under `site/content/programs/`
- [ ] Move migration and command references under `site/content/reference/`
- [ ] Decide where generated site output lives: `site/public/`, `public/`, or `dist/site/`

---

## Phase 7: Restructure Docs

Docs should answer:

> What machine am I on, and what do I run?

Suggested `docs/src/SUMMARY.md` structure:

```md
# Summary

- [Start Here](./start-here.md)

- [Platforms](./platforms/)
  - [Mac without Nix](./platforms/mac-no-nix.md)
  - [Ubuntu/Fedora](./platforms/ubuntu-fedora.md)
  - [NixOS](./platforms/nixos.md)

- [Dotfiles](./dotfiles/)
  - [Overview](./dotfiles/overview.md)
  - [Layout](./dotfiles/layout.md)
  - [Bootstrap](./dotfiles/bootstrap.md)

- [Secrets](./secrets/)
  - [Overview](./secrets/overview.md)
  - [SOPS + age](./secrets/sops-age.md)
  - [Non-Nix Usage](./secrets/non-nix.md)
  - [git-crypt Comparison](./secrets/git-crypt.md)

- [Nix](./nix/)
  - [Flake](./nix/flake.md)
  - [Hosts](./nix/hosts.md)
  - [Home Manager](./nix/home-manager.md)
  - [sops-nix](./nix/sops-nix.md)

- [Programs](./programs/)
  - [Neovim](./programs/neovim.md)
  - [Zellij](./programs/zellij.md)
  - [Ghostty](./programs/ghostty.md)
  - [Ripgrep](./programs/ripgrep.md)

- [Reference](./reference/)
  - [Commands](./reference/commands.md)
  - [Migration](./reference/migration.md)
  - [Package Inventory](./reference/packages.md)
```

Tasks:

- [ ] Add `docs/src/start-here.md`
- [ ] Add `docs/src/platforms/mac-no-nix.md`
- [ ] Add `docs/src/platforms/ubuntu-fedora.md`
- [ ] Add `docs/src/platforms/nixos.md`
- [x] Rewrite old macOS/nix-darwin documentation as non-Nix macOS setup docs
- [ ] Move `docs/src/dotfiles/sops.md` to `docs/src/secrets/non-nix.md`
- [ ] Move NixOS-specific SOPS docs to `docs/src/nix/sops-nix.md`
- [ ] Move platform comparison material into `docs/src/platforms/`
- [ ] Move migration/package inventory material into `docs/src/reference/`

## Suggested Order of Work

1. [ ] Build out the Go installer in `app/`
2. [ ] Add package/dotfile/secrets workflows to `dotfiler`
3. [ ] Scaffold and port utility scripts to `dottools`
4. [ ] Scaffold and build the custom `site` SSG
5. [ ] Clean up migration/package inventory docs
6. [ ] Restructure docs around platform paths and the custom SSG
7. [ ] Later reorganize Nix files into `nix/hosts`, `nix/modules`, and `nix/profiles`

## Parking Lot

- Alias zellij layouts in zshrc
