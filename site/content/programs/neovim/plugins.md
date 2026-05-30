---
title: "Neovim Plugins"
description: "Plugins installed with vim.pack and configured in lua/plugins/init.lua."
section: "Programs"
weight: 210
---

Plugins are managed with Neovim's `vim.pack`. The lockfile is `nvim-pack-lock.json`, and package install/update hooks live near the top of `lua/plugins/init.lua`.

## Package management

```lua
vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.x' },
}, { confirm = false })
```

The config listens for `PackChanged` and runs plugin-specific post-install work:

- `nvim-treesitter` runs `TSUpdate`.
- `telescope-fzf-native.nvim` runs `make` when available.
- `LuaSnip` runs `make install_jsregexp` outside Windows.

## Core dependencies

| Plugin | Purpose |
| --- | --- |
| `plenary.nvim` | Lua utility library used by Telescope and other plugins |
| `nvim-web-devicons` | Optional icons for plugins that can use them |
| `nui.nvim` | UI primitives required by DAP UI and other tools |
| `nvim-nio` | Async primitives used by DAP UI |

## Interface and navigation

| Plugin | Purpose |
| --- | --- |
| `mini.statusline` | Small statusline, with a custom `line:column` location section |
| `which-key.nvim` | Prefix hints for leader groups |
| `telescope.nvim` | File, grep, help, diagnostics, LSP, and buffer pickers |
| `telescope-fzf-native.nvim` | Native FZF sorter for Telescope |
| `telescope-ui-select.nvim` | Uses Telescope for `vim.ui.select` |
| `harpoon` | Fast buffer marks and numbered jumps |
| netrw | Built-in file drawer toggled as a left sidebar |

## Editing

| Plugin | Purpose |
| --- | --- |
| `nvim-autopairs` | Bracket and quote pairs |
| `guess-indent.nvim` | Detects indentation from files |
| `mini.ai` | Extra text objects |
| `mini.surround` | Surround add/change/delete operations |
| `todo-comments.nvim` | Highlights TODO-style comments without signs |
| `indent-blankline.nvim` | Indentation guides |
| `nvim-colorizer.lua` | CSS color previews, including CSS functions |

## Completion, LSP, formatting, linting

| Plugin | Purpose |
| --- | --- |
| `blink.cmp` | Completion engine and LSP capability provider |
| `LuaSnip` | Snippet engine used by completion |
| `lazydev.nvim` | Neovim Lua API metadata for Lua development |
| `mason.nvim` | External tool installer |
| `mason-lspconfig.nvim` | Bridge between Mason and lspconfig |
| `mason-tool-installer.nvim` | Ensures language tools are present |
| `nvim-lspconfig` | LSP server setup |
| `conform.nvim` | Format-on-save and manual formatting |
| `nvim-lint` | Event-driven linting |
| `fidget.nvim` | LSP progress notifications |

## Syntax and languages

`nvim-treesitter` installs parsers for the languages used most often in this config: Lua, Go, Rust, TypeScript/JavaScript, TSX, Markdown, Bash, C, HTML, JSON, Vimscript, Vimdoc, diff, query, and LuaDoc.

## Debugging

| Plugin | Purpose |
| --- | --- |
| `nvim-dap` | Debug adapter client |
| `nvim-dap-ui` | Debug panels and controls |
| `mason-nvim-dap.nvim` | Mason integration for debug adapters |

DAP UI opens when a debug session starts and closes when the session exits or terminates.

## Themes

Installed colorscheme plugins include `tokyonight.nvim`, `nightfox.nvim`, `darkearth-nvim`, `vitesse-nvim`, `nvim-tundra`, and `iced-lightning.nvim`. The active colorscheme is `vitesse`.
