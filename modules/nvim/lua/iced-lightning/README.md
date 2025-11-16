# ⚡ iced-lightning

A lua/Neovim port of [Iceberg.vim](https://github.com/cocopon/iceberg.vim)

## Color Palette

### Dark Variant (Default)

| Color      | Hex       | Usage                    |
| ---------- | --------- | ------------------------ |
| Background | `#161821` | Editor background        |
| Foreground | `#c6c8d1` | Normal text              |
| Blue       | `#84a0c6` | Functions, keywords      |
| Cyan       | `#89b8c2` | Types, identifiers       |
| Green      | `#b4be82` | Strings, git additions   |
| Purple     | `#a093c7` | Constants, numbers       |
| Red        | `#e27878` | Errors, deletions        |
| Orange     | `#e2a478` | Warnings, special chars  |

### Light Variant

| Color      | Hex       | Usage                    |
| ---------- | --------- | ------------------------ |
| Background | `#e8e9ec` | Editor background        |
| Foreground | `#33374c` | Normal text              |
| Blue       | `#2d539e` | Functions, keywords      |
| Cyan       | `#3f83a6` | Types, identifiers       |
| Green      | `#668e3d` | Strings, git additions   |
| Purple     | `#7759b4` | Constants, numbers       |
| Red        | `#cc517a` | Errors, deletions        |
| Orange     | `#c57339` | Warnings, special chars  |

## Variant Toggle

```lua
vim.keymap.set("n", "<leader>tt", function()
  local config = require("iced-lightning.config").get()
  config.variant = config.variant == "dark" and "light" or "dark"
  require("iced-lightning").load()
end, { desc = "Toggle theme variant" })
```
