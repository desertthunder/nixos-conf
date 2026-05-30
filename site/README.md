# Site

Custom static site source for this repo.

## Build

```sh
site build          # build HTML/assets and run Pagefind
site build --static # build HTML/assets only
site serve
site preview
site check
site index
```

## Content

Markdown pages live in `site/content/` and use YAML front matter:

```yaml
---
title: Page title
description: Short page summary
section: Nix
weight: 10
status: draft
---
```

## Design

- Go templates in `site/layouts/`
- Vanilla CSS in `site/assets/css/`
- Iceberg.vim-inspired color tokens
- IBM Plex Serif for prose
- JetBrains Mono for code
- Alpine.js only for small progressive interactions
- Vendored browser libraries live in `site/assets/js/vendor/`
- Pagefind indexes generated output in `dist/`
- Search UI is exposed in the sidebar and renders results into the main content pane
