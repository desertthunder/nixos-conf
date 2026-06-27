# Hyprland

Hyprland is intentionally scoped to `nix-haxorus`. Other hosts keep the shared
GNOME/GDM baseline and do not inherit Hyprland, Waybar, rofi, mako, or related
user services.

## Session Model

Hyprland uses UWSM. In GDM, choose the `Hyprland (uwsm-managed)` session.

UWSM wraps the compositor as a systemd-managed Wayland session.
That gives cleaner environment propagation, XDG autostart behavior, and shutdown
handling than launching the compositor as a plain process.

## Companion Apps

| App                | Role                                         |
| ------------------ | -------------------------------------------- |
| Ghostty            | Default terminal.                            |
| Zellij             | Terminal workspace launched through Ghostty. |
| rofi               | App and run launcher.                        |
| Waybar             | Panel.                                       |
| hyprpaper          | Wallpaper service.                           |
| hypridle           | Idle handling.                               |
| hyprlock           | Lock screen.                                 |
| mako               | Notifications.                               |
| grim, slurp, satty | Screenshot flow.                             |

Ghostty is shared config, but Hyprland binds it directly with
`Super-Return`. `Super-Z` launches `ghostty -e zellij`.

## Theme

| Token      | Value     |
| ---------- | --------- |
| Background | `#151516` |
| Surface    | `#181818` |
| Border     | `#2a2a2a` |
| Accent     | `#51a4e7` |
| Inner gap  | `4`       |
| Outer gap  | `8`       |
| Rounding   | `8`       |

The same palette is used by Hyprland, rofi, and the local Zellij `marble`
theme.

## Keybinds

| Key                      | Action                           |
| ------------------------ | -------------------------------- |
| `Super-Return`           | Open Ghostty                     |
| `Super-Z`                | Open Ghostty with Zellij         |
| `Super-B`                | Open Zen Browser                 |
| `Super-E`                | Open Nautilus                    |
| `Super-R`, `Super-Space` | Open rofi app launcher           |
| `Super-P`                | Open rofi run launcher           |
| `Super-Shift-R`          | Reload Hyprland config           |
| `Super-Shift-L`          | Lock session                     |
| `Super-Q`                | Close focused window             |
| `Super-Shift-F`          | Toggle centered floating         |
| `Super-Shift-G`          | Toggle fullscreen                |
| `Super-Shift-H`          | Toggle fake fullscreen           |
| `Super-Shift-J`          | Toggle Dwindle split             |
| `Super-h/j/k/l`          | Move focus                       |
| `Super-arrow`            |                                  |
| `Super-Ctrl-h/j/k/l`     | Resize focused window            |
| `Super-Alt-h/j/k/l`      | Move focused window              |
| `Super-1..0`             | Switch to workspace 1..10        |
| `Super-Shift-1..0`       | Move window to workspace 1..10   |
| `Super-S`                | Toggle scratch workspace         |
| `Super-Shift-S`          | Move window to scratch workspace |
| `Super-mouse1`           | Drag window                      |
| `Super-mouse2`           | Resize window                    |
| `Print`                  | Region screenshot with editor    |
| `Shift-Print`            | Full screenshot with editor      |
| `Ctrl-Print`             | Region screenshot, no editor     |
| `Ctrl-Shift-Print`       | Full screenshot, no editor       |

Media keys control PipeWire volume, brightness, and `playerctl`.

Screenshot paths save to `~/Pictures/Screenshots`, copy to clipboard, and notify.

## References

<!-- TODO: link these references -->

- Hyprland wiki: NixOS
- Hyprland wiki: Home Manager
- Hyprland wiki: Systemd startup
