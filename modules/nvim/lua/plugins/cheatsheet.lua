return {
  'desertthunder/cheatsheet.nvim',
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
