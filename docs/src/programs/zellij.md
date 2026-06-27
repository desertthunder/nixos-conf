# Zellij

## Summary

| Area          | Current shape                    |
| ------------- | -------------------------------- |
| Config source | `conf/modules/zellij/config.kdl` |
| Layouts       | `conf/modules/zellij/layouts`    |
| Themes        | `conf/modules/zellij/themes`     |
| Default mode  | Locked                           |
| Theme         | `marble`                         |

## Layouts

| Layout        | Notes                                                        |
| ------------- | ------------------------------------------------------------ |
| `default`     | Single pane plus compact bar.                                |
| `classic`     | Large left pane, two stacked right panes, compact bar.       |
| `ide`         | Strider file explorer, Neovim pane, execution and VCS panes. |
| `ide-stack`   | Neovim-style top pane with a lower terminal pane.            |
| `ide-stack-2` | Neovim-style pane, side pane, and testing pane.              |

## Keys

Shared config starts in locked mode.

Press `Ctrl-g` to toggle locked and normal mode.

| Key                          | Action                          |
| ---------------------------- | ------------------------------- |
| `Ctrl-p`                     | Pane mode                       |
| `Ctrl-t`                     | Tab mode                        |
| `Ctrl-s`                     | Scroll mode                     |
| `Ctrl-n`                     | Resize mode                     |
| `Ctrl-o`                     | Session mode                    |
| `Ctrl-h`                     | Move mode                       |
| `p`, `t`, `s`, `r`, `o`, `m` | Modal shortcuts after unlocking |
| `Alt-h/j/k/l`                | Move focus                      |
| `Alt-[`, `Alt-]`             | Cycle swap layouts              |
| `Alt-n`                      | New pane                        |
| `Alt-f`                      | Toggle floating panes           |

Existing sessions do not reliably pick up keymap edits. Start a fresh Zellij
server/session after changing `config.kdl`.

## Validate

| Check         | Command                                                  |
| ------------- | -------------------------------------------------------- |
| Binary        | `zellij --version`                                       |
| Active config | `zellij setup --check`                                   |
| Repo config   | Set `ZELLIJ_CONFIG_FILE` then run `zellij setup --check` |
