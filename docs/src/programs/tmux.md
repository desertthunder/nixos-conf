# tmux

tmux is installed for `owais` on every Home Manager host.

## Keys

tmux keeps its standard `Ctrl-b` prefix. Copy mode and command prompts use vi
bindings.

| Key                         | Action                                |
| --------------------------- | ------------------------------------- |
| `Ctrl-b h/j/k/l`            | Move between panes                    |
| `Ctrl-b H/J/K/L`            | Resize the active pane                |
| `Ctrl-b \|`                 | Split left and right                  |
| `Ctrl-b -`                  | Split top and bottom                  |
| `Ctrl-b c`                  | Create a window in the current path   |
| `Ctrl-b [`                  | Enter copy mode                       |
| `v`, `V`, `Ctrl-v`          | Select characters, lines, or a block  |
| `y`, `Enter`                | Copy to the Wayland clipboard         |
| `h/j/k/l`, `w/b`, `0/$`     | Move in copy mode                     |
| `/`, `?`, `n`, `N`          | Search in copy mode                   |
| `Ctrl-b d`                  | Detach and leave the session running  |

Splits and new windows inherit the active pane's working directory. Mouse
selection and pane controls are enabled, and each pane keeps 100,000 lines of
history.

## Theme

The status line adapts the Zellij `marble` theme:

| Element        | Color     |
| -------------- | --------- |
| Background     | `#151516` |
| Surface        | `#181818` |
| Text           | `#cfcfcf` |
| Muted text     | `#7a7a7a` |
| Border         | `#2a2a2a` |
| Active accent  | `#51a4e7` |

Home Manager writes the generated configuration to
`~/.config/tmux/tmux.conf`. Existing tmux servers keep their loaded settings;
run `tmux source-file ~/.config/tmux/tmux.conf` to reload one.
