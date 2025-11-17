# Neovim Configuration Guide

This guide contains all the teaching comments and explanations from the original kickstart.nvim configuration.

## Getting Started

### What is Kickstart?

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a starting point for your own configuration. The goal is that you can read every line of code, top-to-bottom, understand what your configuration is doing, and modify it to suit your needs.

Once you've done that, you can start exploring, configuring and tinkering to make Neovim your own! That might mean leaving Kickstart just the way it is for a while or immediately breaking it into modular pieces. It's up to you!

### Learning Lua

If you don't know anything about Lua, I recommend taking some time to read through a guide. One possible example which will only take 10-15 minutes:

- <https://learnxinyminutes.com/docs/lua/>

After understanding a bit more about Lua, you can use `:help lua-guide` as a reference for how Neovim integrates Lua.

- :help lua-guide
- (or HTML version): <https://neovim.io/doc/user/lua-guide.html>

### Kickstart Guide

The very first thing you should do is run the command `:Tutor` in Neovim.

If you don't know what this means, type the following:

- `<escape key>`
- `:`
- `Tutor`
- `<enter key>`

(If you already know the Neovim basics, you can skip this step.)

Once you've completed that, you can continue working through **AND READING** the rest of the kickstart init.lua.

Next, run AND READ `:help`.
This will open up a help window with some basic information about reading, navigating and searching the builtin help documentation.

This should be the first place you go to look when you're stuck or confused with something. It's one of my favorite Neovim features.

MOST IMPORTANTLY, we provide a keymap `<space>sh` to [s]earch the [h]elp documentation, which is very useful when you're not exactly sure of what you're looking for.

### Understanding the Configuration

Throughout the configuration files, you'll see `:help X` comments. These are hints about where to find more information about the relevant settings, plugins or Neovim features used in Kickstart.

Look for NOTE: comments throughout the files. These are for you, the reader, to help you understand what is happening. Feel free to delete them once you know what you're doing, but they should serve as a guide for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

## Core Options Explained

### Leader Key

- See `:help mapleader`
- Must happen before plugins are loaded (otherwise wrong leader will be used)

### Vim Options

- See `:help vim.o`
- For more options, you can see `:help option-list`

**Line Numbers:**

- You can also add relative line numbers to help with jumping
- Experiment for yourself to see if you like it!

**Mouse:**

- Enable mouse mode, can be useful for resizing splits for example!

**Clipboard:**

- Sync clipboard between OS and Neovim
- Schedule the setting after `UiEnter` because it can increase startup-time
- Remove this option if you want your OS clipboard to remain independent
- See `:help 'clipboard'`

**Search:**

- Case-insensitive searching UNLESS \C or one or more capital letters in the search term

**Splits:**

- Configure how new splits should be opened

**Whitespace Display:**

- Sets how neovim will display certain whitespace characters in the editor
- See `:help 'list'` and `:help 'listchars'`
- Notice listchars is set using `vim.opt` instead of `vim.o`
- It is very similar to `vim.o` but offers an interface for conveniently interacting with tables
- See `:help lua-options` and `:help lua-options-guide`

**Substitution:**

- Preview substitutions live, as you type!

**Confirm:**

- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`), instead raise a dialog asking if you wish to save the current file(s)
- See `:help 'confirm'`

## Keymaps Explained

See `:help vim.keymap.set()`

**Search Highlights:**

- Clear highlights on search when pressing `<Esc>` in normal mode
- See `:help hlsearch`

**Terminal Mode:**

- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier for people to discover
- Otherwise, you normally need to press `<C-\><C-n>`, which is not what someone will guess without a bit more experience
- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping or just use `<C-\><C-n>` to exit terminal mode

**Arrow Keys:**

- TIP: You can disable arrow keys in normal mode to force yourself to use hjkl

**Split Navigation:**

- Keybinds to make split navigation easier
- Use CTRL+`<hjkl>` to switch between windows
- See `:help wincmd` for a list of all window commands

**Moving Windows:**

- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes

## Autocommands Explained

See `:help lua-guide-autocommands`

**Highlight on Yank:**

- Highlight when yanking (copying) text
- Try it with `yap` in normal mode
- See `:help vim.hl.on_yank()`

## Plugin System

### Lazy.nvim Plugin Manager

See `:help lazy.nvim.txt` or <https://github.com/folke/lazy.nvim> for more info

To check the current status of your plugins, run: `:Lazy`

You can press `?` in this menu for help. Use `:q` to close the window

To update plugins you can run: `:Lazy update`

### Plugin Configuration Methods

**Simple plugins** can be added with just a link (or for a github repo: 'owner/repo' link):

```lua
'NMAC427/guess-indent.nvim'
```

**Plugins with options** can use a table, with the first argument being the link and the following keys can be used to configure plugin behavior/loading/etc:

```lua
{
  'lewis6991/gitsigns.nvim',
  opts = { ... }
}
```

**Using `opts = {}`** will automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.

**Full control** - alternatively, use `config = function() ... end` for full control over the configuration. If you prefer to call `setup` explicitly:

```lua
{
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup({
      -- Your gitsigns configuration here
    })
  end,
}
```

### Plugin Loading

Plugins can be configured to run Lua code when they are loaded. This is often very useful to both group configuration, as well as handle lazy loading plugins that don't need to be loaded immediately at startup.

For example, we use `event = 'VimEnter'` which loads which-key before all the UI elements are loaded. Events can be normal autocommands events (`:help autocmd-events`).

Then, because we use the `opts` key (recommended), the configuration runs after the plugin has been loaded as `require(MODULE).setup(opts)`.

### Plugin Dependencies

Plugins can specify dependencies. The dependencies are proper plugin specifications as well - anything you do for a plugin at the top level, you can do for a dependency.

Use the `dependencies` key to specify the dependencies of a particular plugin.

**Build steps:**
`build` is used to run some command when the plugin is installed/updated. This is only run then, not every time Neovim starts up.

**Conditional loading:**
`cond` is a condition used to determine whether this plugin should be installed and loaded.

## Plugin-Specific Guides

### Telescope

Telescope is a fuzzy finder that comes with a lot of different things that it can fuzzy find! It's more than just a "file finder", it can search many different aspects of Neovim, your workspace, LSP, and more!

The easiest way to use Telescope, is to start by doing something like:

```sh
:Telescope help_tags
```

After running this command, a window will open up and you're able to type in the prompt window. You'll see a list of `help_tags` options and a corresponding preview of the help.

**Two important keymaps to use while in Telescope:**

- Insert mode: `<c-/>`
- Normal mode: `?`

This opens a window that shows you all of the keymaps for the current Telescope picker. This is really useful to discover what Telescope can do as well as how to actually do it!

See `:help telescope` and `:help telescope.setup()`

You can put your default mappings / updates / etc. in the defaults table. All the info you're looking for is in `:help telescope.setup()`

See `:help telescope.builtin` for built-in pickers.

### LSP (Language Server Protocol)

**What is LSP?**

LSP is an initialism you've probably heard, but might not understand what it is.

LSP stands for Language Server Protocol. It's a protocol that helps editors and language tooling communicate in a standardized fashion.

In general, you have a "server" which is some tool built to understand a particular language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone processes that communicate with some "client" - in this case, Neovim!

**LSP provides Neovim with features like:**

- Go to definition
- Find references
- Autocompletion
- Symbol Search
- and more!

Thus, Language Servers are external tools that must be installed separately from Neovim. This is where `mason` and related plugins come into play.

If you're wondering about lsp vs treesitter, you can check out the wonderfully and elegantly composed help section: `:help lsp-vs-treesitter`

**LspAttach Autocommand:**

This function gets run when an LSP attaches to a particular buffer. That is to say, every time a new file is opened that is associated with an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this function will be executed to configure the current buffer.

**Helper Functions:**

Remember that Lua is a real programming language, and as such it is possible to define small helper and utility functions so you don't have to repeat yourself.

**Document Highlighting:**

The following two autocommands are used to highlight references of the word under your cursor when your cursor rests there for a little while.

- See `:help CursorHold` for information about when this is executed
- When you move your cursor, the highlights will be cleared (the second autocommand)

**Inlay Hints:**

The following code creates a keymap to toggle inlay hints in your code, if the language server you are using supports them. This may be unwanted, since they displace some of your code.

**Diagnostic Config:**

See `:help vim.diagnostic.Opts`

**LSP Capabilities:**

LSP servers and clients are able to communicate to each other what features they support. By default, Neovim doesn't support everything that is in the LSP specification. When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities. So, we create new capabilities with blink.cmp, and then broadcast that to the servers.

**Server Configuration:**

Feel free to add/remove any LSPs that you want here. They will automatically be installed.

Add any additional override configuration in the following tables. Available keys are:

- `cmd` (table): Override the default command used to start the server
- `filetypes` (table): Override the default list of associated filetypes for the server
- `capabilities` (table): Override fields in capabilities. Can be used to disable certain LSP features.
- `settings` (table): Override the default settings passed when initializing the server.

For example, to see the options for `lua_ls`, you could go to: <https://luals.github.io/wiki/settings/>

See `:help lspconfig-all` for a list of all the pre-configured LSPs

Some languages (like typescript) have entire language plugins that can be useful:

- <https://github.com/pmizio/typescript-tools.nvim>

**Mason:**

To check the current status of installed tools and/or manually install other tools, you can run: `:Mason`

You can press `g?` for help in this menu.

You can add other tools here that you want Mason to install for you, so that they are available from within Neovim.

### Formatting (Conform.nvim)

Disable "format_on_save lsp_fallback" for languages that don't have a well standardized coding style. You can add additional languages here or re-enable it for the disabled ones.

Conform can also run multiple formatters sequentially:

```lua
python = { "isort", "black" }
```

You can use 'stop_after_first' to run the first available formatter from the list:

```lua
javascript = { "prettierd", "prettier", stop_after_first = true }
```

### Completion (Blink.cmp)

**Keymap Presets:**

- `'default'` (recommended) for mappings similar to built-in completions
    - `<c-y>` to accept ([y]es) the completion
    - This will auto-import if your LSP supports it
    - This will expand snippets if the LSP sent a snippet
- `'super-tab'` for tab to accept
- `'enter'` for enter to accept
- `'none'` for no mappings

For an understanding of why the 'default' preset is recommended, you will need to read `:help ins-completion`

No, but seriously. Please read `:help ins-completion`, it is really good!

**All presets have the following mappings:**

- `<tab>/<s-tab>`: move to right/left of your snippet expansion
- `<c-space>`: Open menu or open docs if already open
- `<c-n>/<c-p>` or `<up>/<down>`: Select next/previous item
- `<c-e>`: Hide menu
- `<c-k>`: Toggle signature help

See `:h blink-cmp-config-keymap` for defining your own keymap

For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
<https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps>

**Appearance:**

`'mono'` (default) for 'Nerd Font Mono' or `'normal'` for 'Nerd Font'. Adjusts spacing to ensure icons are aligned.

**Documentation:**

By default, you may press `<c-space>` to show the documentation. Optionally, set `auto_show = true` to show the documentation after a delay.

**Fuzzy Matching:**

Blink.cmp includes an optional, recommended rust fuzzy matcher, which automatically downloads a prebuilt binary when enabled.

By default, we use the Lua implementation instead, but you may enable the rust implementation via `'prefer_rust_with_warning'`

See `:h blink-cmp-config-fuzzy` for more information

**Snippets:**

Build Step is needed for regex support in snippets. This step is not supported in many windows environments. Remove the condition to re-enable on windows.

`friendly-snippets` contains a variety of premade snippets. See the README about individual language/framework/plugin snippets:
<https://github.com/rafamadriz/friendly-snippets>

### Colorschemes

You can easily change to a different colorscheme. Change the name of the colorscheme plugin, and then change the command in the config to whatever the name of that colorscheme is.

If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.

### Mini.nvim

#### Mini.ai - Better Around/Inside textobjects

Examples:

- `va)` - [V]isually select [A]round [)]paren
- `yinq` - [Y]ank [I]nside [N]ext [Q]uote
- `ci'` - [C]hange [I]nside [']quote

#### Mini.surround - Add/delete/replace surroundings

- `saiw)` - [S]urround [A]dd [I]nner [W]ord [)]Paren
- `sd'` - [S]urround [D]elete [']quotes
- `sr)'` - [S]urround [R]eplace [)] [']

#### Mini.statusline - Simple and easy statusline

You could remove this setup call if you don't like it, and try some other statusline plugin

You can configure sections in the statusline by overriding their default behavior. For example, we set the section for cursor location to LINE:COLUMN

For more mini.nvim modules, check out: <https://github.com/echasnovski/mini.nvim>

### Treesitter

Configure Treesitter - See `:help nvim-treesitter`

Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules. If you are experiencing weird indenting issues, add the language to the list of additional_vim_regex_highlighting and disabled languages for indent.

**Additional nvim-treesitter modules** that you can use to interact with nvim-treesitter. You should go explore a few and see what interests you:

- Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
- Show your current context: <https://github.com/nvim-treesitter/nvim-treesitter-context>
- Treesitter + textobjects: <https://github.com/nvim-treesitter/nvim-treesitter-textobjects>

## Optional Kickstart Plugins

The following comments only work if you have downloaded the kickstart repo, not just copy pasted the init.lua. If you want these files, they are in the repository, so you can just download them and place them in the correct locations.

**Next step on your Neovim journey:** Add/Configure additional plugins for Kickstart

Here are some example plugins that are included in the Kickstart repository. Uncomment any of the lines below to enable them (you will need to restart nvim):

- `require 'kickstart.plugins.debug'`
- `require 'kickstart.plugins.indent_line'`
- `require 'kickstart.plugins.lint'`
- `require 'kickstart.plugins.autopairs'`
- `require 'kickstart.plugins.neo-tree'`
- `require 'kickstart.plugins.gitsigns'` - adds gitsigns recommend keymaps

The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`. This is the easiest way to modularize your config.

For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`

Or use telescope! In normal mode type `<space>sh` then write `lazy.nvim-plugin`. You can continue same window with `<space>sr` which resumes last telescope search.

## Understanding the Configuration Structure

This configuration is organized into modules for easier maintenance and customization.

### Core Configuration Modules

**config/options.lua** - Core Vim settings:

- Line numbers (regular and relative)
- Mouse support for resizing splits
- Clipboard integration with OS (synced after UiEnter for faster startup)
- Break indentation
- Persistent undo history
- Smart case-insensitive search (case-sensitive when pattern has uppercase)
- Sign column always visible
- Faster update time (250ms) for better responsiveness
- Faster key sequence timeout (300ms)
- Split behavior (new splits open right/below)
- Whitespace character display (using `vim.opt` for table-like configuration)
- Live substitution preview
- Cursor line highlighting
- Scroll offset (10 lines above/below cursor)
- Confirm dialog for unsaved changes

**config/keymaps.lua** - Custom key mappings:

- Clear search highlights on `<Esc>` (normal mode)
- Diagnostic quickfix list on `<leader>q`
- Terminal mode exit with `<Esc><Esc>` (doesn't work in all terminals)
- Split navigation with `<C-h/j/k/l>` (avoiding `cd` to maintain working directory)
- Optional: Disable arrow keys to learn hjkl movement

**config/autocmds.lua** - Automatic commands:

- Highlight text when yanking (try with `yap` in normal mode)
- Uses autogroups to avoid duplicate autocommands

**config/lazy.lua** - Plugin manager setup:

- Bootstraps lazy.nvim if not installed
- Checks for installation and clones from git if needed
- Prepends lazy.nvim to runtime path

### Plugin Organization

Each plugin has its own file in `lua/plugins/` for better organization:

**Simple plugins** use minimal configuration:

```lua
return {
  'plugin-author/plugin-name',
}
```

**Plugins with options** pass configuration to `setup()`:

```lua
return {
  'plugin-author/plugin-name',
  opts = {
    setting = value,
  },
}
```

**Plugins needing custom setup** use `config` function:

```lua
return {
  'plugin-author/plugin-name',
  config = function()
    -- Custom setup code
    require('plugin-name').setup({ ... })
  end,
}
```

**Plugins with dependencies** specify them in the `dependencies` table. Dependencies are full plugin specs themselves and can have their own configuration.

**Lazy loading** is controlled with:

- `event` - Load on autocommand event (e.g., 'VimEnter', 'BufWritePre')
- `ft` - Load on filetype (e.g., 'lua', 'python')
- `cmd` - Load on command
- `keys` - Load on keymap
- `cond` - Conditional loading based on function return

**Build steps** run when plugin is installed/updated (not on every startup):

```lua
build = 'make'  -- or function
```

## Customizing Your Configuration

### Adding a New Plugin

1. Create a new file in `lua/plugins/` (e.g., `lua/plugins/my-plugin.lua`)
2. Return a plugin specification:

    ```lua
    return {
      'author/plugin-name',
      event = 'VimEnter',  -- Optional: lazy load
      opts = {
        -- Plugin options
      },
      -- OR for more control:
      config = function()
        require('plugin-name').setup({
          -- Configuration
        })
      end,
    }
    ```

3. Restart Neovim - lazy.nvim auto-loads all files in `plugins/`
4. Run `:Lazy` to check status

### Removing a Plugin

1. Delete the file from `lua/plugins/`
2. Restart Neovim
3. Run `:Lazy clean` to remove the plugin

### Modifying Core Settings

**Change Vim options** - Edit `lua/config/options.lua`:

```lua
-- Enable relative line numbers
vim.o.relativenumber = true

-- Change scroll offset
vim.o.scrolloff = 20
```

**Add keymaps** - Edit `lua/config/keymaps.lua`:

```lua
-- Add your custom keymap
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save file' })
```

**Add autocommands** - Edit `lua/config/autocmds.lua`:

```lua
-- Auto-save on focus lost
vim.api.nvim_create_autocmd('FocusLost', {
  pattern = '*',
  command = 'wa',
})
```

### Changing the Colorscheme

Edit `lua/plugins/colorscheme.lua`:

```lua
return {
  'folke/tokyonight.nvim',
  priority = 1000,
  config = function()
    require('tokyonight').setup {
      style = 'storm',  -- storm, moon, night, day
      styles = {
        comments = { italic = false },
      },
    }
    vim.cmd.colorscheme 'tokyonight-storm'
  end,
}
```

Or install a different colorscheme entirely:

```lua
return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  config = function()
    vim.cmd.colorscheme 'catppuccin-mocha'
  end,
}
```

### Adding Language Servers

Edit `lua/plugins/lspconfig.lua`, add to the `servers` table:

```lua
local servers = {
  lua_ls = { ... },

  -- Add Python
  pyright = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = 'basic',
        },
      },
    },
  },

  -- Add Go
  gopls = {},

  -- Add TypeScript
  ts_ls = {},
}
```

Mason will automatically install these on next startup, or run `:Mason` to install manually.

For server-specific settings, see the LSP config documentation (e.g., <https://luals.github.io/wiki/settings/> for lua_ls).

### Configuring Formatters

Edit `lua/plugins/conform.lua`:

```lua
formatters_by_ft = {
  lua = { 'stylua' },
  python = { 'isort', 'black' },  -- Run sequentially
  javascript = { 'prettierd', 'prettier', stop_after_first = true },  -- First available
  go = { 'gofmt' },
}
```

Disable format-on-save for specific filetypes:

```lua
format_on_save = function(bufnr)
  local disable_filetypes = { c = true, cpp = true, markdown = true }
  if disable_filetypes[vim.bo[bufnr].filetype] then
    return nil
  end
  return { timeout_ms = 500, lsp_format = 'fallback' }
end,
```

### Working with Optional Kickstart Plugins

The original kickstart.nvim includes optional plugins in `lua/kickstart/plugins/`. These are still available in your configuration if you copied them:

**Available optional plugins:**

- `autopairs.lua` - Auto-close brackets and quotes
- `debug.lua` - DAP (Debug Adapter Protocol) support
- `gitsigns.lua` - Enhanced git integration with recommended keymaps
- `indent_line.lua` - Visual indentation guides
- `lint.lua` - Linting support
- `neo-tree.lua` - File explorer sidebar

**To enable an optional plugin:**

Option 1: Copy to plugins directory

```bash
cp config/nvim/lua/kickstart/plugins/neo-tree.lua config/nvim/lua/plugins/
```

Option 2: Require in init.lua (less recommended)

```lua
-- In init.lua, before lazy.setup()
require 'kickstart.plugins.neo-tree'
```

## Troubleshooting Guide

### Common Issues and Solutions

**Plugins not loading:**

1. Check `:Lazy` for errors (red text)
2. Run `:Lazy sync` to install/update all plugins
3. Run `:checkhealth lazy` for diagnostic info
4. Check for Lua syntax errors in plugin files
5. Ensure plugin file returns a table

**LSP not working:**

1. Run `:LspInfo` to see if LSP is attached to buffer
2. Check if language server is installed: `:Mason`
3. Run `:checkhealth lsp` for diagnostic info
4. Verify filetype is correct: `:set filetype?`
5. Check server configuration in `lua/plugins/lspconfig.lua`

**Completion not appearing:**

1. Ensure LSP is attached (`:LspInfo`)
2. Check blink.cmp is loaded: `:Lazy`
3. Try manual trigger: `<C-space>`
4. Run `:checkhealth` for issues

**Formatting not working:**

1. Run `:ConformInfo` to check formatter status
2. Ensure formatter is installed (many installed via Mason: `:Mason`)
3. Check configuration in `lua/plugins/conform.lua`
4. Verify filetype is configured: `:ConformInfo`
5. Try manual format: `<leader>f`

**Treesitter errors:**

1. Update parsers: `:TSUpdate`
2. Reinstall parser: `:TSInstall <language>`
3. Check health: `:checkhealth nvim-treesitter`
4. Ensure compiler is available (gcc, clang, or zig)

**Telescope not finding files:**

1. Ensure ripgrep is installed: `rg --version`
2. Ensure fd is installed (optional): `fd --version`
3. Check cwd is correct: `:pwd`
4. Try different pickers: `<leader>sf` vs `<leader>sg`

### Performance Issues

**Slow startup:**

1. Check startup time: `nvim --startuptime startup.log`
2. Review lazy-loaded plugins (event, ft, cmd, keys)
3. Consider removing unused plugins
4. Check for heavy autocommands

**Laggy editing:**

1. Disable treesitter for large files: `:TSBufDisable highlight`
2. Check LSP performance: `:LspInfo`
3. Reduce `updatetime` if too low
4. Check for heavy plugins

## Additional Resources

- Run `:Tutor` - Interactive Neovim tutorial
- Run `:checkhealth` - Check your Neovim installation
- `:help` - Search help documentation
- `:help lua-guide` - Comprehensive Lua in Neovim guide
- `:help lazy.nvim-plugin-spec` - Plugin specification details
- <https://github.com/nvim-lua/kickstart.nvim> - Original Kickstart repository
- <https://neovim.io/doc/user/lua-guide.html> - Lua guide (HTML version)
