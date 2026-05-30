---
title: "Cheatsheet Plugin"
description: "A local keymap browser exposed through desertthunder/cheatsheet.nvim."
section: "Programs"
weight: 220
---

The config installs `desertthunder/cheatsheet.nvim` and exposes it with both a user command and a keymap.

## Usage

| Command or key | Action |
| --- | --- |
| `<leader>?` | Toggle the cheatsheet floating window |
| `:Cheatsheet` | Toggle the cheatsheet floating window |

The plugin is configured with a large ASCII header, rounded borders, and an 80% by 80% floating window.

```lua
require('cheatsheet').setup {
  header = {
    '╭──────────────────────────────────────────────────────────────────────────────────────────────────────╮',
    '│                               ▗▄▄▖▗▖ ▗▖▗▄▄▄▖ ▗▄▖▗▄▄▄▖▗▄▄▖▗▖ ▗▖▗▄▄▄▖▗▄▄▄▖▗▄▄▄▖                        │',
    '╰──────────────────────────────────────────────────────────────────────────────────────────────────────╯',
  },
  exclude_patterns = { '<Plug>', '<SNR>' },
  window = { width = 0.8, height = 0.8, border = 'rounded' },
}
```

## What it is for

The cheatsheet is the escape hatch when `which-key` is not enough. `which-key` helps while typing a prefix; the cheatsheet gives a broader view of configured mappings in a floating window.

## Integration

```lua
local cheatsheet = require 'cheatsheet'

vim.api.nvim_create_user_command('Cheatsheet', function()
  cheatsheet.toggle()
end, { desc = 'Toggle cheatsheet window' })

vim.keymap.set('n', '<leader>?', cheatsheet.toggle, {
  desc = 'Toggle [?] Cheatsheet',
})
```

Mappings containing `<Plug>` and `<SNR>` are hidden so the display focuses on mappings meant to be called by a human.
