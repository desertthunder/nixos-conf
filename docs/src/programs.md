# Programs

## Zathura

Zathura is enabled on Linux through Home Manager in `conf/shared.nix`.

Notable mappings:

| Key | Action            |
| --- | ----------------- |
| `u` | half page up      |
| `d` | half page down    |
| `J` | full page down    |
| `K` | full page up      |
| `T` | toggle page mode  |
| `r` | reload            |
| `R` | rotate            |
| `A` | zoom in           |
| `D` | zoom out          |
| `i` | recolor           |
| `p` | print             |
| `b` | toggle status bar |

The theme is Catppuccin-like and uses Home Manager options rather than a
separate dotfile.

## Ghostty

Ghostty is enabled on Linux with Zsh integration, JetBrains Mono Nerd Font, and a
small dark palette. It launches Zsh as a login shell.

## Zed

Zed is enabled through Home Manager. It uses the Oxocarbon theme and Zed's
auto-installer for Bash, Dart/Flutter, Elixir, Gleam, Lua, and Nix extensions.
Home Manager wraps Zed with the language servers and formatters used by the
Neovim setup so GUI launches can find them.

## Zellij

Zellij config is sourced from `conf/modules/zellij` into `~/.config/zellij`.
Home Manager copies the whole directory recursively, so layouts from
`conf/modules/zellij/layouts/*.kdl` are available as
`~/.config/zellij/layouts/*.kdl`.

Use a named layout with either the long or short flag:

```bash
zellij --layout ide
zellij -l ide-stack
```

A layout can also be selected by path while iterating on it:

```bash
zellij --layout ~/.config/zellij/layouts/classic.kdl
```

`layouts/default.kdl` is the default layout for plain `zellij`. Current local
layouts:

| Layout        | Notes                                                               |
| ------------- | ------------------------------------------------------------------- |
| `default`     | single pane plus compact bar                                        |
| `classic`     | large left pane, two stacked right panes, compact bar               |
| `ide`         | strider file explorer, focused Neovim pane, execution and VCS panes |
| `ide-stack`   | Neovim-style top pane with a lower terminal pane                    |
| `ide-stack-2` | Neovim-style pane, side pane, and testing pane                      |

Shared config starts in locked mode. Press `Ctrl-g` to toggle locked/normal.
Common global bindings include `Alt-h/j/k/l` to move focus,
`Alt-[`/`Alt-]` to cycle swap layouts, `Alt-n` for a new pane, and `Alt-f` to
toggle floating panes.
