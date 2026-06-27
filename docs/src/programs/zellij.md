# Zellij

## What this config does

Zellij uses the repo config from `conf/modules/zellij`. Home Manager copies that
directory to `~/.config/zellij`.

## Nix location

- `conf/shared.nix`: installs `zellij`
- `conf/shared.nix`: copies `conf/modules/zellij`
- `conf/modules/zellij/config.kdl`: shared config
- `conf/modules/zellij/layouts/*.kdl`: layouts
- `conf/modules/zellij/themes/*.kdl`: themes

## Portable setup

Install Zellij, then copy the config:

```bash
mkdir -p ~/.config
cp -r conf/modules/zellij ~/.config/zellij
```

Validate it:

```bash
ZELLIJ_CONFIG_FILE="$HOME/.config/zellij/config.kdl" \
  ZELLIJ_CONFIG_DIR="$HOME/.config/zellij" \
  zellij setup --check
```

## Layouts

Available local layouts:

| Layout        | Notes                                                       |
| ------------- | ----------------------------------------------------------- |
| `default`     | single pane plus compact bar                                |
| `classic`     | large left pane, two stacked right panes, compact bar       |
| `ide`         | strider file explorer, Neovim pane, execution and VCS panes |
| `ide-stack`   | Neovim-style top pane with a lower terminal pane            |
| `ide-stack-2` | Neovim-style pane, side pane, and testing pane              |

Run a layout by name:

```bash
zellij --layout ide
zellij -l ide-stack
```

Run a layout by path while editing it:

```bash
zellij --layout ~/.config/zellij/layouts/classic.kdl
```

## Keys

Shared config starts in locked mode. Press `Ctrl-g` to toggle locked and normal
mode.

Common bindings:

- `Ctrl-p`: pane mode
- `Ctrl-t`: tab mode
- `Ctrl-s`: scroll mode
- `Ctrl-n`: resize mode
- `Ctrl-o`: session mode
- `Ctrl-h`: move mode
- `p`, `t`, `s`, `r`, `o`, `m`: modal shortcuts after unlocking
- `Alt-h`, `Alt-j`, `Alt-k`, `Alt-l`: move focus
- `Alt-[`, `Alt-]`: cycle swap layouts
- `Alt-n`: new pane
- `Alt-f`: toggle floating panes
