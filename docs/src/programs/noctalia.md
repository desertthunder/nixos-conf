# Noctalia and Umbriel

Haxorus uses [Noctalia](https://docs.noctalia.dev/noctalia/) as its Wayland
shell and [Umbriel](https://docs.noctalia.dev/umbriel/) as its compositor. The
configuration is scoped to `nix-haxorus` keeping the shared GNOME session
available on every machine.

Umbriel replaces Hyprland. Noctalia replaces Waybar, rofi, cliphist, mako,
SwayOSD, hyprpaper, hypridle, hyprlock, the power menu, the Ignis shortcut
widget, the screenshot scripts, and the Hyprland Polkit agent.

## Session model

Choose **Umbriel** in GDM. The package installs this session and starts the
compositor through `start-umbriel`. Umbriel owns window management, outputs,
workspaces, input, and compositor effects. Its systemd session target starts
Noctalia, which owns the shell surfaces and desktop services.

X11 applications run through `xwayland-satellite`. Screen sharing and portal
screenshots use `xdg-desktop-portal-umbriel`; the Umbriel NixOS module installs
and selects that portal.

The complete Haxorus setup lives in `conf/modules/de/noct.nix`. It imports the
Noctalia and Umbriel NixOS and Home Manager modules. `flake.nix` pins both
projects, and `conf/machines/thinkpad/configuration.nix` imports the module.

The first rebuild must accept the flake's Noctalia binary cache configuration:

```console
sudo nixos-rebuild switch --accept-flake-config \
  --flake "$NIXOS_CONFIG#nix-haxorus"
```

That generation adds the cache to the system Nix settings, so later rebuilds
can use the normal `rebuild` alias.

## Configuration ownership

Home Manager writes these read-only files from the Nix configuration:

- `~/.config/noctalia/config.toml`
- `~/.config/noctalia/palettes/Haxorus.json`
- `~/.config/umbriel/config.toml`

Noctalia Settings is safe to use interactively. GUI changes persist in
`~/.local/state/noctalia/settings.toml`, which is writable and loaded after the
Home Manager file. A GUI override therefore wins over the value in
`noct.nix`. Delete the relevant setting from that state file, or delete the
whole file while Noctalia is stopped, to return to the declared value.

Use **Settings → Export Config → Merged User Config** to inspect or promote GUI
changes. Move the wanted values into `noct.nix`, rebuild, and remove their GUI
overrides. Do not edit the Home Manager symlinks under `~/.config`.

Umbriel does not write overrides. Its TOML configuration is generated entirely
from `programs.umbriel.settings` and reloads when Home Manager updates it.

## Shell surfaces

The floating top bar has an 8 px screen margin and rounded corners. It contains:

- launcher and per-output workspaces on the left;
- the active media player in the center;
- network, Bluetooth, volume, brightness, battery, idle inhibition,
  notifications, tray, clock, Control Center, and session controls on the
  right.

The launcher searches desktop applications and includes calculator, emoji,
session, wallpaper, and window providers. Prefix a search with `/calc`, `/emo`,
`/session`, `/wall`, or `/win` to select one of those providers.

Control Center provides media and stream controls, display brightness, system
status, NetworkManager, Bluetooth, notification history, and UPower battery
information. Weather, calendar, and screen-time tabs are hidden because those
services are not configured. Session actions are available in its header and
in the separate session panel.

Noctalia is the notification daemon. Dismissing a toast keeps it in Control
Center history. Do Not Disturb suppresses new toasts without stopping history.

The dock is disabled. A Noctalia label widget on the laptop desktop replaces
the Ignis shortcut card. It lists the common terminal, launcher, browser, file,
clipboard, lock, and shortcut-help bindings. The widget is attached to
`eDP-1`; use Noctalia's desktop widget editor to find coordinates for another
panel, then promote its exported values into `noct.nix`.

The lock screen uses `wall00.png`, a dark tint, password authentication, and
fingerprint authentication. Noctalia locks before suspend, including suspend
caused by closing the lid.

## Theme

Noctalia uses its built-in dark `Eldritch` palette. The custom
`Haxorus` palette is commented out in `noct.nix` so it can be restored
without reconstructing its color roles.

Noctalia uses Inter.

Umbriel takes its compositor colors from `desktop-theme.nix`, with 4 px tile gaps,
8 px corners, a 1 px border, no blur, no shadows, and slightly translucent unfocused windows.

Panels are solid and bordered rather than glassy.

Noctalia's application theme templates are disabled, so the palette does not
rewrite GTK, Qt, terminal, or editor themes.

## Idle and power

Noctalia is the only idle daemon:

|  Idle time | Action                                           |
| ---------: | ------------------------------------------------ |
|  5 minutes | Lock the session.                                |
|       5:30 | Turn displays off. Activity turns them on again. |
| 15 minutes | Lock and suspend the machine.                    |

Wayland idle inhibitors are honored. The bar's caffeine control can also hold
the session awake.

UPower supplies battery status and health. TLP still controls CPU and laptop
power policy. `power-profiles-daemon` is disabled to avoid conflicting
with TLP, so Noctalia can show battery information but has no power-profile
selector.

## Umbriel behavior

The laptop output is `eDP-1`, starts at `[0, 0]`, uses scale `1.2`, and has ten
workspaces. Other outputs use their preferred mode, scale `1`, automatic
left-to-right placement, and Umbriel's independent per-output workspaces. Run
`umbriel outputs` after connecting a display and add an explicit `[output]`
entry in `noct.nix` when it needs a fixed mode, scale, or position.

The default layout is `dwindle` with preserved splits. Three-finger touchpad
gestures follow the horizontal workspace axis. `Super` plus the left or right
mouse button moves or resizes a window; Umbriel implements those grabs
natively.

Common bindings are:

| Key                                 | Action                                           |
| ----------------------------------- | ------------------------------------------------ |
| `Super-Return`, `Super-Z`           | Open Ghostty, or Ghostty with Zellij.            |
| `Super-B`, `Super-E`                | Open Zen Browser or Nautilus.                    |
| `Super-R`, `Super-Space`, `Super-P` | Open the launcher.                               |
| `Super-V`                           | Open clipboard history.                          |
| `Super-Shift-V`                     | Clear unpinned clipboard history.                |
| `Super-N`, `Super-Shift-N`          | Invoke the latest notification; toggle DND.      |
| `Super-Shift-L`                     | Lock.                                            |
| `Super-Escape`                      | Open session controls.                           |
| `Super-?`                           | Toggle Umbriel's shortcut sheet.                 |
| `Super-Q`                           | Close the focused window.                        |
| `Super-Shift-F/G/H/P`               | Toggle floating, fullscreen, maximize, or pin.   |
| `Super-h/j/k/l`, arrows             | Move focus.                                      |
| `Super-Ctrl-h/j/k/l`                | Resize the focused tile.                         |
| `Super-Alt-h/j/k/l`                 | Reorder the focused tile.                        |
| `Super-1..0`                        | Switch to workspace 1..10 on the pointer output. |
| `Super-Shift-1..0`                  | Move a window to workspace 1..10.                |
| `Super-S`, `Super-Shift-S`          | Show the scratchpad; move a window into it.      |
| `Super-wheel`                       | Switch to the previous or next workspace.        |
| `Print`, `Shift-Print`              | Capture a region or the focused display.         |

Screenshots open Noctalia's annotation editor, save under
`~/Pictures/Screenshots`, and copy the result to the clipboard. Media keys use
Noctalia directly for volume, microphone, brightness, and playback; its OSD
shows the result.

## Debugging

Configuration can be evaluated from GNOME, but layer-shell, session lock,
workspace integration, input gestures, and output behavior need an Umbriel
session. Umbriel can also run nested in GNOME for basic compositor testing; its
modifier changes to Alt unless `general.mod_key` is forced as it is here.

After rebuilding, use:

```console
systemctl --user status umbriel noctalia
journalctl --user -b -u umbriel -u noctalia
noctalia status
noctalia config validate
umbriel validate
umbriel outputs
umbriel windows
umbriel layers
```

If Noctalia ignores a declared setting, inspect its winning GUI layer:

```console
$EDITOR ~/.local/state/noctalia/settings.toml
noctalia config export full | yq -p toml '.'
```

If the shell is absent only in Umbriel, check
`systemctl --user status noctalia` and confirm that
`umbriel-session.target` is active. If an X11 app fails, check that
`xwayland-satellite` is running. Use the portal log for screen-sharing failures:

```console
journalctl --user -b -u xdg-desktop-portal-umbriel
```

Umbriel is young and its configuration may change. Run both validators after
updating the flake inputs, then test lock/unlock, suspend, screenshots, external
outputs, and screen sharing in a real Umbriel session.
