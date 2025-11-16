local M = {}

--- Color palette inspired by chadracula-evondev theme
--- @param config table User configuration
--- @return table colors Color palette
function M.setup(config)
  local colors = {
    none = 'NONE',
    bg = '#141423',
    bg_alt = '#19192c',
    bg_highlight = '#2b2b4c',
    bg_statusline = '#19192c',
    bg_sidebar = '#141423',
    bg_float = '#19192c',
    bg_popup = '#19192c',

    fg = '#F8F8F2',
    fg_dark = '#6060a4',
    fg_gutter = '#414171',

    black = '#141423',
    black2 = '#19192c',

    grey = '#414171',
    grey_alt = '#6060a4',

    red = '#FF5555',
    red1 = '#FF6BCB',
    green = '#50FA7B',
    green1 = '#20E3B2',
    yellow = '#F1FA8C',
    blue = '#2CCCFF',
    cyan = '#2CCCFF',
    purple = '#BD93F9',
    purple1 = '#a166f6',
    orange = '#FFB86C',
    pink = '#FF6BCB',

    violet = '#9A86FD',
    teal = '#92A2D4',
    nord_blue = '#05C3FF',

    comment = '#6060a4',
    error = '#FF5555',
    warning = '#FFB86C',
    info = '#2CCCFF',
    hint = '#20E3B2',

    git_add = '#50FA7B',
    git_change = '#FFB86C',
    git_delete = '#FF5555',
    git_ignore = '#414171',

    diff_add = '#50FA7B',
    diff_change = '#FFB86C',
    diff_delete = '#FF5555',
    diff_text = '#2CCCFF',
  }

  if config.transparent then
    colors.bg = 'NONE'
    colors.bg_sidebar = 'NONE'
    colors.bg_statusline = 'NONE'
    colors.bg_float = 'NONE'
  end

  if config.on_colors then
    colors = config.on_colors(colors) or colors
  end

  return colors
end

return M
