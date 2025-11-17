# Plugins

Plugin configuration managed by [Lazy.nvim](https://github.com/folke/lazy.nvim).

## Core UI

| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **goolord/alpha-nvim** | Dashboard | Startup screen with ASCII art, quick actions |
| **akinsho/bufferline.nvim** | Buffer tabs | Visual buffer management, pinning, grouping |
| **echasnovski/mini.statusline** | Status line | Minimal statusline with file info, location |
| **lukas-reineke/indent-blankline.nvim** | Indentation | Visual indent guides |

## Navigation & Search

| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **nvim-telescope/telescope.nvim** | Fuzzy finder | Files, grep, buffers, help, diagnostics |
| **nvim-neo-tree/neo-tree.nvim** | File explorer | Tree view, git integration, buffer management |
| **folke/which-key.nvim** | Keymap hints | Shows pending keybinds after prefix |

## Text Editing

| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **echasnovski/mini.surround** | Surround text | Add/change/delete surrounding characters |
| **echasnovski/mini.ai** | Text objects | Enhanced around/inside text objects |
| **windwp/nvim-autopairs** | Auto pairs | Automatic bracket/quote pairing |
| **NMAC427/guess-indent.nvim** | Indentation | Auto-detect indentation settings |

## Development Tools

| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **neovim/nvim-lspconfig** | LSP client | Language server integration |
| **mason-org/mason.nvim** | LSP installer | Automatic LSP server installation |
| **saghen/blink.cmp** | Completion | Fast completion engine |
| **j-hui/fidget.nvim** | LSP progress | LSP operation progress indicators |

## Git Integration

| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **lewis6991/gitsigns.nvim** | Git decorations | Line signs, hunk actions, blame |

## Syntax & Highlighting

| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **nvim-treesitter/nvim-treesitter** | Syntax highlighting | Advanced syntax highlighting, folding |
| **catgoose/nvim-colorizer.lua** | Color preview | CSS color highlighting |
| **folke/todo-comments.nvim** | Comment highlighting | TODO/FIXME/NOTE highlighting |

## Colorschemes

| Plugin | Purpose | Active |
|--------|---------|---------|
| **dracula-recharged** (local) | Dark theme | ✓ |
| **iced-lightning** (local) | Cool theme | - |
| **folke/tokyonight.nvim** | Dark theme | - |
| **EdenEast/nightfox.nvim** | Multi-variant | - |

## Quality of Life

| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **folke/lazydev.nvim** | Lua development | Neovim Lua API completion |
| **cheatsheet** (local) | Keymap browser | Interactive keymap reference |

## Configuration Structure

```
lua/
├── plugins/
│   ├── init.lua          # UI plugins (alpha, bufferline, themes)
│   ├── telescope.lua     # Fuzzy finder
│   ├── neo-tree.lua      # File explorer  
│   ├── which-key.lua     # Keymap hints
│   ├── lspconfig.lua     # LSP configuration
│   ├── gitsigns.lua      # Git integration
│   ├── treesitter.lua    # Syntax highlighting
│   ├── blink-cmp.lua     # Completion
│   ├── conform.lua       # Formatting
│   ├── lint.lua          # Linting
│   └── cheatsheet.lua    # Custom keymap browser
└── config/
    ├── keymaps.lua       # Core keybindings
    ├── options.lua       # Vim options
    └── autocmds.lua      # Auto commands
```