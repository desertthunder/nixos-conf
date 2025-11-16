local M = {}

--- Color palette inspired by Iceberg theme
--- @param config table User configuration
--- @return table colors Color palette
function M.setup(config)
  local colors = {}

  local is_dark = config.variant == 'dark'

  if is_dark then
    colors = {
      none = 'NONE',
      bg = '#161821',
      bg_alt = '#1e2132',
      bg_highlight = '#1e2132',
      bg_statusline = '#0f1117',
      bg_sidebar = '#161821',
      bg_float = '#1e2132',
      bg_popup = '#1e2132',

      fg = '#c6c8d1',
      fg_dark = '#6b7089',
      fg_gutter = '#444b71',

      black = '#161821',
      black2 = '#0f1117',

      grey = '#6b7089',
      grey_alt = '#3d425b',

      red = '#e27878',
      red1 = '#cc517a',
      green = '#b4be82',
      green1 = '#668e3d',
      yellow = '#e2a478',
      blue = '#84a0c6',
      cyan = '#89b8c2',
      purple = '#a093c7',
      purple1 = '#7759b4',
      orange = '#e2a478',
      pink = '#cc517a',

      violet = '#a093c7',
      teal = '#89b8c2',
      nord_blue = '#84a0c6',

      comment = '#6b7089',
      error = '#e27878',
      warning = '#e2a478',
      info = '#84a0c6',
      hint = '#89b8c2',

      git_add = '#b4be82',
      git_change = '#e2a478',
      git_delete = '#e27878',
      git_ignore = '#6b7089',

      diff_add = '#b4be82',
      diff_change = '#e2a478',
      diff_delete = '#e27878',
      diff_text = '#84a0c6',
    }
  else
    colors = {
      none = 'NONE',
      bg = '#e8e9ec',
      bg_alt = '#dcdfe7',
      bg_highlight = '#cad0de',
      bg_statusline = '#dcdfe7',
      bg_sidebar = '#e8e9ec',
      bg_float = '#dcdfe7',
      bg_popup = '#dcdfe7',

      fg = '#33374c',
      fg_dark = '#8389a3',
      fg_gutter = '#a7b2cd',

      black = '#e8e9ec',
      black2 = '#dcdfe7',

      grey = '#8389a3',
      grey_alt = '#cbcfda',

      red = '#cc517a',
      red1 = '#cc517a',
      green = '#668e3d',
      green1 = '#668e3d',
      yellow = '#c57339',
      blue = '#2d539e',
      cyan = '#3f83a6',
      purple = '#7759b4',
      purple1 = '#7759b4',
      orange = '#c57339',
      pink = '#cc517a',

      violet = '#7759b4',
      teal = '#3f83a6',
      nord_blue = '#2d539e',

      comment = '#8389a3',
      error = '#cc517a',
      warning = '#c57339',
      info = '#2d539e',
      hint = '#3f83a6',

      git_add = '#668e3d',
      git_change = '#c57339',
      git_delete = '#cc517a',
      git_ignore = '#8389a3',

      diff_add = '#668e3d',
      diff_change = '#c57339',
      diff_delete = '#cc517a',
      diff_text = '#2d539e',
    }
  end

  if config.transparent then
    colors.bg = 'NONE'
    colors.bg_sidebar = 'NONE'
    colors.bg_statusline = 'NONE'
    colors.bg_float = 'NONE'
  end

  if config.on_colors then
    return config.on_colors(colors)
  else
    return colors
  end
end

return M
