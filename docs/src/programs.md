# Programs

## Zathura

Zathura is enabled on Linux through Home Manager in `conf/shared.nix`.

Notable mappings:

| Key | Action |
| --- | --- |
| `u` | half page up |
| `d` | half page down |
| `J` | full page down |
| `K` | full page up |
| `T` | toggle page mode |
| `r` | reload |
| `R` | rotate |
| `A` | zoom in |
| `D` | zoom out |
| `i` | recolor |
| `p` | print |
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
