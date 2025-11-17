# Keymaps

Key bindings organized by category. Leader key is `<Space>`.

## Core Navigation

| Key | Mode | Description |
|-----|------|-------------|
| `<Esc>` | n | Clear search highlights |
| `<Esc><Esc>` | t | Exit terminal mode |
| `<C-h>` | n | Move focus to left window |
| `<C-l>` | n | Move focus to right window |
| `<C-j>` | n | Move focus to lower window |
| `<C-k>` | n | Move focus to upper window |

## Search (`<leader>s`)

| Key | Description |
|-----|-------------|
| `<leader>sh` | Search help tags |
| `<leader>sk` | Search keymaps |
| `<leader>sf` | Search files |
| `<leader>ss` | Search Telescope builtin |
| `<leader>sw` | Search current word |
| `<leader>sg` | Search by grep |
| `<leader>sd` | Search diagnostics |
| `<leader>sr` | Search resume |
| `<leader>s.` | Search recent files |
| `<leader>s/` | Search in open files |
| `<leader>sn` | Search Neovim files |
| `<leader>/` | Fuzzy search current buffer |
| `<leader><leader>` | Find existing buffers |

## Toggle (`<leader>t`)

| Key | Description |
|-----|-------------|
| `<leader>te` | Toggle NeoTree explorer |
| `<leader>tb` | Toggle git blame line |
| `<leader>tD` | Toggle git deleted preview |

## Buffer Management (`<leader>b`)

| Key | Description |
|-----|-------------|
| `<leader>bn` | New buffer |
| `<leader>bd` | Delete buffer |
| `<leader>bp` | Toggle pin buffer |
| `<leader>bP` | Delete non-pinned buffers |
| `<leader>br` | Delete buffers to right |
| `<leader>bl` | Delete buffers to left |
| `<S-h>` | Previous buffer |
| `<S-l>` | Next buffer |
| `[b` / `]b` | Previous/next buffer |
| `[B` / `]B` | Move buffer prev/next |

## Git Hunks (`<leader>h`)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>hs` | n/v | Stage hunk |
| `<leader>hr` | n/v | Reset hunk |
| `<leader>hS` | n | Stage buffer |
| `<leader>hu` | n | Undo stage hunk |
| `<leader>hR` | n | Reset buffer |
| `<leader>hp` | n | Preview hunk |
| `<leader>hb` | n | Blame line |
| `<leader>hd` | n | Diff against index |
| `<leader>hD` | n | Diff against last commit |
| `]c` / `[c` | n | Jump to next/prev git change |

## LSP Actions

| Key | Mode | Description |
|-----|------|-------------|
| `grn` | n | Rename symbol |
| `gra` | n/x | Code action |
| `grr` | n | Go to references |
| `gri` | n | Go to implementation |
| `grd` | n | Go to definition |
| `grD` | n | Go to declaration |
| `grt` | n | Go to type definition |
| `gO` | n | Document symbols |
| `gW` | n | Workspace symbols |

## Misc

| Key | Description |
|-----|-------------|
| `<leader>q` | Open diagnostic quickfix |
| `<leader>?` | Toggle cheatsheet |
| `\` | Toggle NeoTree |