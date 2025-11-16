local M = {}

--- @param opts table|nil User configuration options
function M.setup(opts)
  local config_module = require 'iced-lightning.config'
  config_module.setup(opts)
end

function M.load()
  if vim.g.colors_name then vim.cmd 'hi clear' end

  if vim.fn.exists 'syntax_on' then vim.cmd 'syntax reset' end

  vim.o.termguicolors = true
  vim.g.colors_name = 'iced-lightning'

  local config = require('iced-lightning.config').get()
  local colors = require('iced-lightning.colors').setup(config)

  if config.terminal_colors then M.set_terminal_colors(colors) end

  local highlights = require('iced-lightning.highlights').setup(colors, config)
  require('iced-lightning.highlights').apply(highlights)
end

--- Set terminal colors for integrated terminal (16 ANSI colors)
--- @param colors table Color palette
function M.set_terminal_colors(colors)
  vim.g.terminal_color_0 = colors.black
  vim.g.terminal_color_1 = colors.red
  vim.g.terminal_color_2 = colors.green
  vim.g.terminal_color_3 = colors.yellow
  vim.g.terminal_color_4 = colors.blue
  vim.g.terminal_color_5 = colors.purple
  vim.g.terminal_color_6 = colors.cyan
  vim.g.terminal_color_7 = colors.fg

  -- Bright variants
  vim.g.terminal_color_8 = colors.grey
  vim.g.terminal_color_9 = colors.red
  vim.g.terminal_color_10 = colors.green1
  vim.g.terminal_color_11 = colors.yellow
  vim.g.terminal_color_12 = colors.nord_blue
  vim.g.terminal_color_13 = colors.violet
  vim.g.terminal_color_14 = colors.cyan
  vim.g.terminal_color_15 = colors.fg
end

--- Get the color palette (used for statusline integrations)
--- @param opts table|nil Configuration options
--- @return table colors Color palette
function M.get_colors(opts)
  local config = require('iced-lightning.config').get()
  if opts then config = vim.tbl_deep_extend('force', config, opts) end
  return require('iced-lightning.colors').setup(config)
end

return M
