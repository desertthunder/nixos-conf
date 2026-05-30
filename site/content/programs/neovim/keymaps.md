---
title: "Neovim Keymaps"
description: "Current key bindings from the associated neovim configuration."
section: "Programs"
weight: 200
---

The leader key is `<Space>`. The local leader is also `<Space>`.

## Core navigation

| Key | Mode | Description |
| --- | --- | --- |
| `<Esc>` | Normal | Clear search highlights |
| `<Esc><Esc>` | Terminal | Exit terminal mode |
| `<C-h>` | Normal | Move to the left split |
| `<C-j>` | Normal | Move to the lower split |
| `<C-k>` | Normal | Move to the upper split |
| `<C-l>` | Normal | Move to the right split |

## Search and Telescope

| Key | Description |
| --- | --- |
| `<leader>sh` | Search help tags |
| `<leader>sk` | Search keymaps |
| `<leader>sf` | Search files |
| `<leader>ss` | Search Telescope builtins |
| `<leader>sw` | Grep the word under the cursor |
| `<leader>sg` | Live grep |
| `<leader>sd` | Search diagnostics |
| `<leader>sr` | Resume the previous picker |
| `<leader>s.` | Recent files |
| `<leader>s/` | Live grep in open files |
| `<leader>sn` | Search Neovim config files |
| `<leader>/` | Fuzzy search the current buffer |
| `<leader><leader>` | Find existing buffers |

## File explorer

| Key | Description |
| --- | --- |
| `<leader>te` | Toggle the netrw sidebar |
| `\` | Toggle the netrw sidebar |

The sidebar opens with `botright vertical 25new`, fixes its width, explores the current file's directory, then returns focus to the original window.

## Buffers and Harpoon

| Key | Description |
| --- | --- |
| `<leader>bn` | New buffer |
| `<leader>bd` | Delete buffer |
| `<leader>ba` | Add the current buffer to Harpoon |
| `<leader>bh` | Toggle the Harpoon quick menu |
| `<leader>bp` | Harpoon previous |
| `<leader>bl` | Harpoon next |
| `<leader>1` … `<leader>9` | Select Harpoon item 1 through 9 |
| `<leader>0` | Select Harpoon item 10 |
| `<S-h>` / `[b` | Harpoon previous |
| `<S-l>` / `]b` | Harpoon next |

## Git hunks

| Key | Mode | Description |
| --- | --- | --- |
| `]c` / `[c` | Normal | Next/previous git change, respecting diff mode |
| `<leader>hs` | Normal/Visual | Stage hunk |
| `<leader>hr` | Normal/Visual | Reset hunk |
| `<leader>hS` | Normal | Stage buffer |
| `<leader>hu` | Normal | Undo stage hunk |
| `<leader>hR` | Normal | Reset buffer |
| `<leader>hp` | Normal | Preview hunk |
| `<leader>hb` | Normal | Blame line |
| `<leader>hd` | Normal | Diff against index |
| `<leader>hD` | Normal | Diff against last commit |
| `<leader>tb` | Normal | Toggle current-line blame |
| `<leader>tD` | Normal | Toggle deleted-line preview |

## LSP

| Key | Mode | Description |
| --- | --- | --- |
| `grn` | Normal | Rename symbol |
| `gra` | Normal/Visual | Code action |
| `grr` | Normal | References via Telescope |
| `gri` | Normal | Implementations via Telescope |
| `grd` | Normal | Definitions via Telescope |
| `grD` | Normal | Declaration |
| `grt` | Normal | Type definitions via Telescope |
| `gO` | Normal | Document symbols |
| `gW` | Normal | Workspace symbols |
| `<leader>th` | Normal | Toggle inlay hints when the server supports them |

## Diagnostics, formatting, and cheatsheet

| Key | Mode | Description |
| --- | --- | --- |
| `<leader>q` | Normal | Open diagnostic quickfix list |
| `<leader>f` | Normal/Visual | Format buffer or selection asynchronously |
| `<leader>?` | Normal | Toggle the cheatsheet window |

## Debugging

| Key | Description |
| --- | --- |
| `<F5>` | Start or continue debugging |
| `<F1>` | Step into |
| `<F2>` | Step over |
| `<F3>` | Step out |
| `<F7>` | Toggle DAP UI |
| `<leader>b` | Toggle breakpoint |
| `<leader>B` | Set conditional breakpoint |
