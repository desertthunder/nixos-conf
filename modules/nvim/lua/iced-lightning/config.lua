local M = {}

--- Default configuration for iced-lightning theme
M.defaults = {
  variant = 'dark',
  transparent = false,
  terminal_colors = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = { bold = false },
    variables = {},
  },
  plugins = {
    telescope = true,
    treesitter = true,
    lsp = true,
    neotree = true,
    bufferline = true,
    gitsigns = true,
    alpha = true,
  },

  --- @type fun(colors: table): table|nil
  on_colors = nil,

  --- @type fun(highlights: table, colors: table): table|nil
  on_highlights = nil,
}

M.current = vim.deepcopy(M.defaults)

--- Setup user configuration by merging with defaults
--- @param user_opts table|nil User configuration options
function M.setup(user_opts) M.current = vim.tbl_deep_extend('force', M.defaults, user_opts or {}) end

--- Get current configuration
--- @return table Current configuration
function M.get() return M.current end

return M
