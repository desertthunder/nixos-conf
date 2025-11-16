# Dracula Recharged

Another exercise in writing my own Neovim plugin, this time a colorscheme based on the Chadracula-Evondev theme.
The palette comes from NvChad's base46 with comprehensive (to me) plugin support.

## Installation

### Using lazy.nvim

```lua
{
  'dracula-recharged',
  dir = vim.fn.stdpath('config') .. '/lua/dracula-recharged',
  priority = 1000,
  config = function()
    require('dracula-recharged').setup({
      transparent = false,
      terminal_colors = true,
    })
    vim.cmd('colorscheme dracula-recharged')
  end,
}
```

<!--
```lua
{
  'desertthunder/dracula-recharged.nvim',
  priority = 1000,
  config = function()
    require('dracula-recharged').setup({
      transparent = false,
      terminal_colors = true,
    })
    vim.cmd('colorscheme dracula-recharged')
  end,
}
``` -->

Copy the `dracula-recharged/` directory to your Neovim config:

```bash
cp -r dracula-recharged ~/.config/nvim/lua/
```

## Usage

### Basic usage

```lua
vim.cmd('colorscheme dracula-recharged')
```

### With configuration

```lua
-- Setup with options
require('dracula-recharged').setup({
  transparent = false,
  terminal_colors = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = { bold = false },
    variables = {},
  },
})

-- Apply the colorscheme
vim.cmd('colorscheme dracula-recharged')
```

### Switch colorschemes on-the-fly

```vim
:colorscheme dracula-recharged
```

## Configuration

### Default configuration

```lua
require('dracula-recharged').setup({
  -- Enable transparent background
  transparent = false,

  -- Enable terminal colors (16 ANSI colors)
  terminal_colors = true,

  -- Styling options
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = { bold = false },
    variables = {},
  },

  -- Enable/disable specific plugin integrations
  plugins = {
    telescope = true,
    treesitter = true,
    lsp = true,
    neotree = true,
    bufferline = true,
    gitsigns = true,
    alpha = true,
  },

  -- Callback to override colors before highlight groups are set
  on_colors = function(colors)
    -- Modify colors here
    return colors
  end,

  -- Callback to override highlight groups
  on_highlights = function(highlights, colors)
    -- Modify highlights here
    return highlights
  end,
})
```

### Configuration options

| Option             | Type     | Default             | Description                      |
| ------------------ | -------- | ------------------- | -------------------------------- |
| `transparent`      | boolean  | `false`             | Enable transparent background    |
| `terminal_colors`  | boolean  | `true`              | Set terminal color palette       |
| `styles.comments`  | table    | `{ italic = true }` | Comment styling                  |
| `styles.keywords`  | table    | `{ italic = true }` | Keyword styling                  |
| `styles.functions` | table    | `{ bold = false }`  | Function styling                 |
| `styles.variables` | table    | `{}`                | Variable styling                 |
| `plugins.*`        | boolean  | `true`              | Enable/disable plugin highlights |
| `on_colors`        | function | `nil`               | Color override callback          |
| `on_highlights`    | function | `nil`               | Highlight override callback      |

## API Reference

### Main Module (`require('dracula-recharged')`)

#### `setup(opts)`

Initialize the theme with optional configuration. Calling setup is **optional**.

```lua
require('dracula-recharged').setup({
  transparent = false,
  terminal_colors = true,
  styles = { ... },
  plugins = { ... },
})
```

#### `load()`

Load the colorscheme. This is called automatically by `:colorscheme dracula-recharged`.

```lua
require('dracula-recharged').load()
```

#### `set_terminal_colors(colors)`

Set terminal colors for integrated terminals (16 ANSI colors).

```lua
local colors = require('dracula-recharged').get_colors()
require('dracula-recharged').set_terminal_colors(colors)
```

#### `get_colors(opts)`

Get the color palette for statusline integrations or custom use.

```lua
local colors = require('dracula-recharged').get_colors()
print(colors.purple)  -- #BD93F9
```

### Colors Module (`require('dracula-recharged.colors')`)

#### `setup(config)`

Generate the color palette based on configuration.

### Highlights Module (`require('dracula-recharged.highlights')`)

#### `setup(colors, config)`

Generate all highlight groups based on colors and configuration.

- `colors` (table) - Color palette from `colors.setup()`
- `config` (table) - Configuration from `config.get()`
- `table` - Highlight groups

#### `apply(highlights)`

Apply highlight groups to Neovim.

**Parameters:**

- `highlights` (table) - Highlight groups from `highlights.setup()`

### Config Module (`require('dracula-recharged.config')`)

#### `setup(user_opts)`

Merge user configuration with defaults.

#### `get()`

Get the current configuration.

## Color Palette

### Base Colors

| Color          | Hex       | Usage                               |
| -------------- | --------- | ----------------------------------- |
| `bg`           | `#141423` | Background                          |
| `bg_alt`       | `#19192c` | Alt background (statusline, floats) |
| `bg_highlight` | `#2b2b4c` | Highlights, selections              |
| `fg`           | `#F8F8F2` | Foreground text                     |
| `fg_dark`      | `#6060a4` | Dark foreground (comments)          |

### Accent Colors

| Color    | Hex       | Usage               |
| -------- | --------- | ------------------- |
| `red`    | `#FF5555` | Errors, deletions   |
| `pink`   | `#FF6BCB` | Keywords, operators |
| `green`  | `#50FA7B` | Strings, additions  |
| `green1` | `#20E3B2` | Functions, methods  |
| `yellow` | `#F1FA8C` | Warnings, special   |
| `blue`   | `#2CCCFF` | Info, types         |
| `cyan`   | `#2CCCFF` | Types, cyan variant |
| `purple` | `#BD93F9` | Numbers, booleans   |
| `violet` | `#9A86FD` | Constants           |
| `orange` | `#FFB86C` | Parameters, changes |

## Examples

### Transparent background

```lua
require('dracula-recharged').setup({
  transparent = true,
})
vim.cmd('colorscheme dracula-recharged')
```

### Custom color overrides

```lua
require('dracula-recharged').setup({
  on_colors = function(colors)
    colors.comment = '#7070aa'  -- Lighter comments
    colors.bg = '#0a0a0f'       -- Darker background
    return colors
  end,
})
```

### Custom highlight overrides

```lua
require('dracula-recharged').setup({
  on_highlights = function(highlights, colors)
    highlights.Function = { fg = colors.cyan, bold = true }
    highlights.Comment = { fg = colors.fg_dark, italic = false }
    return highlights
  end,
})
```

### Disable specific plugins

```lua
require('dracula-recharged').setup({
  plugins = {
    telescope = true,
    treesitter = true,
    lsp = true,
    neotree = false,    -- Disable neo-tree highlights
    bufferline = false, -- Disable bufferline highlights
    gitsigns = true,
    alpha = true,
  },
})
```

### Bold functions, no italic keywords

```lua
require('dracula-recharged').setup({
  styles = {
    comments = { italic = true },
    keywords = { italic = false },      -- No italic
    functions = { bold = true },        -- Bold functions
    variables = { italic = true },
  },
})
```

### Use with statusline plugins

```lua
-- lualine integration
local colors = require('dracula-recharged').get_colors()

require('lualine').setup({
  options = {
    theme = {
      normal = {
        a = { bg = colors.purple, fg = colors.bg },
        b = { bg = colors.bg_highlight, fg = colors.fg },
        c = { bg = colors.bg_statusline, fg = colors.fg },
      },
      -- ... other modes
    },
  },
})
```

## Plugin Support

The theme includes optimized highlight groups for (these are all plugins I use):

- **Telescope**: Borders, prompts, selections, matching
- **Treesitter**: Semantic tokens, syntax highlighting
- **LSP**: Diagnostics (errors, warnings, info, hints), references, code lens
- **Neo-tree**: File explorer, directory icons, git status
- **Bufferline**: Buffer tabs, separators, indicators, close buttons
- **GitSigns**: Git additions, changes, deletions
- **Alpha**: Dashboard header, buttons, shortcuts, footer

All plugin integrations can be selectively disabled via the `plugins` configuration.

## Notes

### Vim Configuration

Ensure `termguicolors` is enabled:

```lua
vim.opt.termguicolors = true
```

Some terminals require additional configuration. Force transparency:

```lua
require('dracula-recharged').setup({ transparent = true })

vim.cmd([[
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NormalNC guibg=NONE ctermbg=NONE
]])
```

### Execution Order

Ensure `setup()` is called *before* `vim.cmd('colorscheme dracula-recharged')`:

```lua
require('dracula-recharged').setup({ ... })
vim.cmd('colorscheme dracula-recharged')
```

### Project

```sh
dracula-recharged/
├── init.lua         -- Main module (setup, load, public API)
├── config.lua       -- Configuration management
├── colors.lua       -- Color palette generation
└── highlights.lua   -- Highlight group generation
```

1. `setup(opts)` merges user config with defaults
2. `:colorscheme dracula-recharged` triggers `load()`
3. `load()` generates colors → applies terminal colors → generates highlights → applies to Neovim
4. Callbacks `on_colors()` and `on_highlights()` allow user customization

## Reference

- `:help colorscheme` - Colorscheme system
- `:help highlight` - Highlight groups
- `:help nvim_set_hl()` - Set highlights via API
- `:help termguicolors` - True color support
- `:help g:terminal_color_0` - Terminal colors
- `:help lua-guide` - Lua in Neovim
- `:help vim.api` - Neovim API

## Credits

- **Color Palette**: Based on [Chadracula-Evondev](https://github.com/NvChad/base46) by NvChad
- **Architecture**: Inspired by [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) by folke
- **Original Dracula**: [Dracula Theme](https://draculatheme.com/)
