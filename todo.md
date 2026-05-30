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
- [ ] Reorganize docs around platform-specific setup paths
- [ ] Decide on dragon-type naming convention for machines, including the new Dell NixOS host

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

## Phase 1: Migration and Inventory Cleanup

Mac Mini will use the non-Nix macOS path. ASDF has been removed completely, and the Brewfiles now represent the desired package inventory.

- [ ] Test Mac Mini bootstrap with `scripts/bootstrap/setup/mac.sh`
- [ ] Move package inventory material from README/docs into the new docs reference section

## Phase 2: Build a Custom Static Site Generator

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

## Phase 3: Restructure Docs

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
- [ ] Move `docs/src/dotfiles/sops.md` to `docs/src/secrets/non-nix.md`
- [ ] Move NixOS-specific SOPS docs to `docs/src/nix/sops-nix.md`
- [ ] Move platform comparison material into `docs/src/platforms/`
- [ ] Move migration/package inventory material into `docs/src/reference/`

## Suggested Order of Work

1. [ ] Test Mac Mini bootstrap with `scripts/bootstrap/setup/mac.sh`
2. [ ] Clean up migration/package inventory docs
3. [ ] Scaffold and build the custom `site` SSG
4. [ ] Restructure docs around platform paths and the custom SSG

## Parking Lot

- Alias zellij layouts in zshrc
