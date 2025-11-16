local M = {}

--- Default configuration for dracula-recharged theme
M.defaults = {
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
  --- @type fun(colors: table): table|nil
  on_colors = nil,

  -- Callback to override highlight groups
  --- @type fun(highlights: table, colors: table): table|nil
  on_highlights = nil,
}

M.current = vim.deepcopy(M.defaults)

--- Setup user configuration by merging with defaults
--- @param user_opts table|nil User configuration options
function M.setup(user_opts)
  M.current = vim.tbl_deep_extend('force', M.defaults, user_opts or {})
end

--- Get current configuration
--- @return table Current configuration
function M.get()
  return M.current
end

return M
