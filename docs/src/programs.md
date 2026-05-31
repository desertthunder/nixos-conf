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

## Zellij

Zellij config is sourced from `conf/modules/zellij` into `~/.config/zellij`.
