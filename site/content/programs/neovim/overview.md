---
title: "Neovim Configuration"
description: "A compact Neovim config built on vim.pack, native LSP, Telescope, Treesitter, DAP, and a custom cheatsheet window."
section: "Programs"
weight: 190
---

This Neovim setup lives in [neovim-conf](https://github.com/desertthunder/nvim). It is a small Lua config that leans on Neovim's built-in pieces first: `vim.pack` for packages, native LSP, netrw for the file drawer, and focused plugins where they earn their keep.

## Shape of the config

```sh
.
├── init.lua                 # options, core keymaps, autocommands, plugin entry
├── lua/
│   ├── health.lua           # :checkhealth support for the config
│   └── plugins/init.lua     # vim.pack list and plugin setup
├── nvim-pack-lock.json      # vim.pack lockfile
└── stylua.toml
```

The config is intentionally flat. Most plugin setup is in `lua/plugins/init.lua`, which makes it easy to audit after package updates.

## Defaults

- Leader and local leader are both `<Space>`.
- True color, persistent undo, cursor line, smart-case search, sign column, and break indent are enabled.
- The OS clipboard is synced asynchronously with `unnamedplus`.
- Splits open right and below.
- List characters make tabs, trailing spaces, and non-breaking spaces visible.
- `vim.loader.enable()` is turned on at startup.

## Editing stack

- `nvim-autopairs` for bracket and quote pairs.
- `guess-indent.nvim` to inherit indentation from the current file.
- `mini.ai` and `mini.surround` for text objects and surround edits.
- `conform.nvim` formats on save, except for C and C++.
- `nvim-lint` runs on buffer enter, write, and insert leave.

## Development stack

| Area | Tools |
| --- | --- |
| Completion | `blink.cmp`, `LuaSnip`, `lazydev.nvim` |
| LSP | `mason.nvim`, `mason-lspconfig.nvim`, `nvim-lspconfig` |
| Treesitter | `nvim-treesitter` with parsers installed into Neovim data |
| Search | `telescope.nvim`, `telescope-fzf-native.nvim`, `telescope-ui-select.nvim` |
| Git | `gitsigns.nvim` |
| Debugging | `nvim-dap`, `nvim-dap-ui`, `mason-nvim-dap.nvim` |

Configured language servers are `gopls`, `lua_ls`, `rust_analyzer`, and `ts_ls`. Mason also ensures the formatter/linter tools `dprint`, `eslint_d`, `goimports`, `markdownlint-cli2`, and `stylua` are available.

## Languages

Treesitter parsers are requested for Bash, C, diff, Go, HTML, JavaScript, JSON, Lua, LuaDoc, Markdown, Markdown inline, query, Rust, TSX, TypeScript, Vim, and Vimdoc.

## Updating the installed config

```sh
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
rsync -a --delete --exclude '.git/' --exclude '.vscode/' ./ "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/"
```

After running `vim.pack.update()` from the live config, copy the lockfile back to the repo:

```sh
nvim +'lua vim.pack.update()'
cp "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/nvim-pack-lock.json" ./nvim-pack-lock.json
```
