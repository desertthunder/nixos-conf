-- Custom cheatsheet plugin - displays keymaps in a floating window
--
-- This file is the plugin specification for lazy.nvim. Lazy.nvim reads all
-- files in lua/plugins/ and treats them as plugin specs.
--
-- Plugin spec structure:
-- - [1] = plugin path (for external plugins) or omitted (for local plugins)
-- - dependencies = other plugins this depends on
-- - config = function called after plugin loads (setup our plugin)
-- - keys = lazy-load when these keys are pressed

return {
  -- No [1] because this is a local plugin (code in lua/cheatsheet/)
  -- For external plugins, you'd have: 'author/repo-name'

  name = 'cheatsheet.nvim',
  dir = vim.fn.stdpath 'config' .. '/lua/cheatsheet',
  keys = { { '<leader>?', desc = 'Toggle [?] Cheatsheet' } },

  config = function()
    local cheatsheet = require 'cheatsheet'
    cheatsheet.setup {
      header = {
        '╭──────────────────────────────────────────────────────────────────────────────────────────────────────╮',
        '│                               ▗▄▄▖▗▖ ▗▖▗▄▄▄▖ ▗▄▖▗▄▄▄▖▗▄▄▖▗▖ ▗▖▗▄▄▄▖▗▄▄▄▖▗▄▄▄▖                        │',
        '│                              ▐▌   ▐▌ ▐▌▐▌   ▐▌ ▐▌ █ ▐▌   ▐▌ ▐▌▐▌   ▐▌     █                          │',
        '│                              ▐▌   ▐▛▀▜▌▐▛▀▀▘▐▛▀▜▌ █  ▝▀▚▖▐▛▀▜▌▐▛▀▀▘▐▛▀▀▘  █                          │',
        '│                              ▝▚▄▄▖▐▌ ▐▌▐▙▄▄▖▐▌ ▐▌ █ ▗▄▄▞▘▐▌ ▐▌▐▙▄▄▖▐▙▄▄▖  █                          │',
        '╰──────────────────────────────────────────────────────────────────────────────────────────────────────╯',
      },

      exclude_patterns = { '<Plug>', '<SNR>' },
      window = { width = 0.8, height = 0.8, border = 'rounded' },
    }

    vim.api.nvim_create_user_command('Cheatsheet', function() cheatsheet.toggle() end, { desc = 'Toggle cheatsheet window' })
    vim.keymap.set('n', '<leader>?', cheatsheet.toggle, { desc = 'Toggle [?] Cheatsheet' })
  end,
}
