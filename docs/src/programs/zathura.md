# Zathura Keybinds

## Basic Navigation

| Key(s)          | Action                         |
| --------------- | ------------------------------ |
| `j` / `Down`    | Scroll down (or move down)     |
| `k` / `Up`      | Scroll up (or move up)         |
| `h` / `Left`    | Scroll left / move left ([^1]) |
| `l` / `Right`   | Scroll right / move right      |
| `gg`            | Go to first page               |
| `G` (Shift + g) | Go to last page                |
| `<number>G`     | Go to page number `<number>`   |

## Zooming, Fitting, Rotation, and View

| Key(s)            | Action                               |
| ----------------- | ------------------------------------ |
| `=`               | Reset zoom / original size           |
| `+` / `Shift + =` | Zoom in                              |
| `-`               | Zoom out                             |
| `a`               | Fit height to window                 |
| `s`               | Fit width to window                  |
| `r`               | Rotate page 90° clockwise            |
| `C-r` (Ctrl + r)  | Invert or recolor (black/white) view |

## Search / Find

| Key(s) | Action                 |
| ------ | ---------------------- |
| `/`    | Start forward search   |
| `?`    | Start reverse search   |
| `n`    | Next search result     |
| `N`    | Previous search result |

## Bookmarks, Links, and Index

| Key(s)                        | Action                                                          |
| ----------------------------- | --------------------------------------------------------------- |
| `m<letter>` (e.g. `m1`)       | Create bookmark on current page stored under that letter/number |
| `'<letter>`                   | Jump to bookmark stored under that letter                       |
| `f`                           | Show all link hints; then type hint number to follow link       |
| `F`                           | Show link target hints (without highlighting)                   |
| `Tab`                         | Show document index (table of contents)                         |
| `j` / `k` (within index mode) | Move up/down in index                                           |
| `Enter` (within index)        | Jump to selected index entry’s page                             |

## Modes, Commands & Interface Toggles

| Key(s)      | Action                                                                      |
| ----------- | --------------------------------------------------------------------------- |
| `:`         | Enter command mode (to run commands like `:open`, `:close`, `:blist`, etc.) |
| `Ctrl + N`  | Toggle the info/status bar                                                  |
| `Ctrl + M`  | Toggle the input command bar                                                |
| `Q`         | Quit Zathura                                                                |
| `F11`       | Toggle fullscreen mode                                                      |
| `F5`        | Enter presentation / slide mode                                             |
| `Shift + R` | Reload / redraw document                                                    |

## Mouse / Scroll / Misc

- Mouse wheel scrolls pages up/down
- Ctrl + scroll wheel: zoom in/out
- Right-click + drag: pan the document
- Left-click on a link: follow the link

## References

- <https://wiki.archlinux.org/title/Zathura> "zathura - ArchWiki"
- <https://www.unix.com/man_page/linux/1/zathura/> "linux zathura man page on unix.com"
