# Cheatsheet Extension

Interactive keymap browser that displays all Neovim keymaps in an organized, searchable floating window.

## Usage

- `<leader>?` - Toggle cheatsheet window
- `:Cheatsheet` - Toggle cheatsheet window

**Inside cheatsheet:**

- `q` or `<Esc>` - Close window
- `j`/`k` or arrows - Scroll through keymaps

## Features

- **Auto-extraction**: Pulls all keymaps from Neovim automatically
- **Categorization**: Groups keymaps by function (Search, Toggle, LSP, Git, etc.)
- **Floating window**: Syntax highlighted, rounded borders
- **Interactive**: Keyboard navigation, auto-close on buffer switch

## Configuration

Located in `modules/nvim/lua/cheatsheet/config.lua`:

```lua
{
  header = { '╔═══════════════════════════════════════════╗', ... },
  exclude_patterns = { '<Plug>', '<SNR>' },
  window = { width = 0.8, height = 0.8, border = 'rounded' },
  highlights = { header = 'Title', category = 'Function', ... }
}
```

## API

- `require('cheatsheet').toggle()` - Show/hide window
- `require('cheatsheet').open()` - Show window
- `require('cheatsheet').close()` - Hide window

## Files

- `init.lua` - Main plugin interface
- `config.lua` - Configuration management
- `keymaps.lua` - Keymap extraction and categorization
- `ui.lua` - Window creation and display
