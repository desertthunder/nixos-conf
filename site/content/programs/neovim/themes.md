---
title: "Neovim Themes"
description: "Colorscheme plugins installed in the current Neovim config."
section: "Programs"
weight: 230
---

The active colorscheme is `vitesse`.

```lua
vim.g.tundra_biome = vim.g.tundra_biome or 'arctic'
require('nvim-tundra').setup {
  plugins = {
    lsp = true,
    semantic_tokens = true,
    treesitter = true,
    telescope = true,
    gitsigns = true,
  },
}
require('iced-lightning').setup {
  transparent = false,
  terminal_colors = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
  },
}
vim.cmd.colorscheme 'vitesse'
```

## Installed theme plugins

| Plugin | Notes |
| --- | --- |
| `ptdewey/vitesse-nvim` | Active theme |
| `sam4llis/nvim-tundra` | Configured with LSP, semantic token, Treesitter, Telescope, and gitsigns support |
| `desertthunder/iced-lightning.nvim` | Configured with terminal colors and italic comments/keywords |
| `folke/tokyonight.nvim` | Available as an alternate dark theme |
| `EdenEast/nightfox.nvim` | Available as an alternate multi-variant theme |
| `ptdewey/darkearth-nvim` | Available as an alternate earthy dark theme |

## Related visual plugins

- `mini.statusline` supplies the statusline.
- `indent-blankline.nvim` adds indent guides.
- `todo-comments.nvim` highlights comment markers without signs.
- `nvim-colorizer.lua` previews CSS colors and CSS color functions inline.
