# Umbriel

Haxorus uses [Umbriel](https://docs.noctalia.dev/umbriel/) as its Wayland
compositor. It owns outputs, workspaces, window placement, input, and compositor
effects. Noctalia provides the [shell and desktop services](./noctalia.md).

Choose **Umbriel** in GDM to start the session. X11 applications run through
`xwayland-satellite`. Screen sharing and portal screenshots use
`xdg-desktop-portal-umbriel`.

## Configuration

`conf/modules/de/umb.nix` enables the Umbriel NixOS module and configures
`programs.umbriel.settings` through Home Manager. The ThinkPad configuration
imports `umb.nix`.

Home Manager generates `~/.config/umbriel/config.toml` from the Nix attribute
set. Umbriel does not write overrides or modify that file. Change `umb.nix` and
rebuild instead of editing the Home Manager symlink. Umbriel watches the file
and applies valid updates without a restart; it keeps the last working config
if a reload fails.

The repository sets the session environment, laptop output, workspace model,
layout, colors, appearance, input, keybindings, window rules, and animations.
Unspecified settings retain Umbriel's defaults. See the upstream
[configuration reference](https://docs.noctalia.dev/umbriel/configuration/)
when adding an option.

## Window-management model

Every workspace uses Dwindle. There are no Master, Scrolling, or per-workspace
layout overrides. New windows split the focused tile along its longer edge and
open in the right or bottom half. `preserve_split = true` keeps that split
direction when surrounding geometry changes.

Tiled windows have 4 px gaps. Windows use 8 px corners and a 1 px border, with
no outer border, blur, or shadow. Unfocused windows use 97% opacity. Colors come
from `desktop-theme.nix`.

`Super-Shift-F` toggles the focused window between tiled and floating, then
centers it. Other floating windows retain their own size and position unless a
window rule supplies defaults. `Super` plus left or right mouse drag moves or
resizes a window.

## Workspaces

The laptop output has ten static, numbered positions. Empty workspaces remain
available. `Super-1` through `Super-0` select positions 1 through 10 on the
output under the pointer. Re-selecting the active workspace returns to the
previous workspace on that output.

Workspaces belong to outputs rather than forming one global list. An
unconfigured external output uses Umbriel's default dynamic workspace model.
It starts with one workspace, adds an empty workspace after the last occupied
one, and removes other empty inactive workspaces.

No workspace currently overrides the global Dwindle layout. Add a `workspace`
rule in `umb.nix` if a workspace needs Master or Scrolling.

When an output disconnects, Umbriel moves its windows to another enabled
output. If the output reconnects, its workspaces, windows, active workspace,
and layout state return to it.

## Outputs

The ThinkPad panel is `eDP-1`. It starts at `[0, 0]`, uses scale `1.2`, and
arranges its workspaces horizontally. Its mode is not fixed, so Umbriel uses
the display's preferred mode.

List connected outputs and their copyable configuration names from an Umbriel
session:

```console
umbriel outputs
umbriel outputs --json
```

Add or change an `output.<name>` entry in `umb.nix` to set a monitor's mode,
scale, position, workspace inventory, or workspace axis. Prefer the reported
monitor name for rules tied to one physical display. Prefer a connector such as
`DP-1` for rules tied to one port.

Outputs without an explicit position are placed automatically from left to
right. Docking and undocking therefore does not require a fixed arrangement.
Disconnected windows return to their original output when it reconnects.

## Scratchpad

There are no named scratchpads. Umbriel therefore provides its implicit global
`default` scratchpad:

- `Super-Shift-S` stores the focused window.
- `Super-S` shows or hides all stored windows on the pointer output.
- `umbriel msg window-restore-from-scratchpad` restores the focused stored
  window to its saved output and workspace.

There is no restore keybinding. Showing a scratchpad does not remove its windows
from it. Scratchpad windows float, and the visible scratchpad dims the output by
30%. The scratchpad can roam between outputs and returns with an output after a
disconnect and reconnect.

## Keybindings

`Mod` is fixed to `Super`, including nested sessions. Bindings dispatch
[Umbriel actions](https://docs.noctalia.dev/umbriel/actions/) or spawn commands.
The same action strings can be run with `umbriel msg <action>`.

### Applications

| Key            | Action                         |
| -------------- | ------------------------------ |
| `Super-Return` | Open Ghostty.                  |
| `Super-Z`      | Open Ghostty running Zellij.  |
| `Super-B`      | Open Zen Browser.              |
| `Super-E`      | Open Nautilus.                 |

### Windows

| Key                       | Action                                  |
| ------------------------- | --------------------------------------- |
| `Super-Q`                 | Close the focused window.               |
| `Super-Shift-F`           | Toggle floating and center the window.  |
| `Super-Shift-G`           | Toggle fullscreen.                      |
| `Super-Shift-H`           | Toggle maximize.                        |
| `Super-Shift-P`           | Toggle pinned state.                    |
| `Super-Ctrl-H/L`          | Decrease or increase width by 10%.      |
| `Super-Ctrl-K/J`          | Decrease or increase height by 10%.     |
| `Super-Alt-H/L`           | Move the Dwindle column left or right.  |
| `Super-Alt-K/J`           | Move the window up or down.             |
| `Super-Mouse left drag`   | Move a tiled or floating window.        |
| `Super-Mouse right drag`  | Resize a tiled or floating window.      |

### Focus

| Key                         | Action       |
| --------------------------- | ------------ |
| `Super-H`, `Super-Left`     | Focus left.  |
| `Super-J`, `Super-Down`     | Focus down.  |
| `Super-K`, `Super-Up`       | Focus up.    |
| `Super-L`, `Super-Right`    | Focus right. |

Focus follows the pointer. Moving the pointer does not warp it to the focused
window, and typing does not hide it.

### Workspaces

| Key                   | Action                                         |
| --------------------- | ---------------------------------------------- |
| `Super-1..0`          | Switch to workspace 1 through 10.              |
| `Super-Shift-1..0`    | Move the focused window to workspace 1–10.     |
| `Super-Wheel up`      | Switch to the previous workspace.              |
| `Super-Wheel down`    | Switch to the next workspace.                  |

Wheel switching has a 150 ms cooldown. Three-finger horizontal touchpad swipes
also switch workspaces.

### Scratchpad

| Key             | Action                                      |
| --------------- | ------------------------------------------- |
| `Super-S`       | Show or hide the default scratchpad.        |
| `Super-Shift-S` | Move the focused window to the scratchpad.  |

### Noctalia

| Key                                 | Action                               |
| ----------------------------------- | ------------------------------------ |
| `Super-R`, `Super-Space`, `Super-P` | Toggle the launcher.                 |
| `Super-V`                           | Toggle clipboard history.            |
| `Super-Shift-V`                     | Clear clipboard history.             |
| `Super-N`                           | Invoke the latest notification.      |
| `Super-Shift-N`                     | Toggle Do Not Disturb.                |

### Media

| Key                       | Action                         |
| ------------------------- | ------------------------------ |
| `Volume up/down`          | Change output volume.          |
| `Volume mute`             | Toggle output mute.            |
| `Microphone mute`         | Toggle microphone mute.        |
| `Brightness up/down`      | Change display brightness 5%.  |
| `Media next/previous`     | Change tracks.                 |
| `Media play/pause`        | Toggle playback.               |

These hardware-key bindings work while the session is locked.

### Screenshots

| Key           | Action                                      |
| ------------- | ------------------------------------------- |
| `Print`       | Capture a region with Noctalia.             |
| `Shift-Print` | Capture the focused output with Noctalia.   |

Screenshot bindings do not repeat.

### Session

| Key             | Action                                  |
| --------------- | --------------------------------------- |
| `Super-Shift-L` | Lock through Noctalia.                  |
| `Super-Escape`  | Toggle Noctalia's session panel.        |
| `Super-Shift-/` | Toggle Umbriel's keybinding cheatsheet. |
| `Super-Shift-R` | Reload the Umbriel configuration.       |

Power controls are available from the Noctalia session panel.

## Window rules

The rules in `umb.nix` provide these exceptions:

- Unfocused windows use 97% opacity.
- Noctalia Settings opens floating at 1020×900.
- Umbriel's share picker opens floating at 800×600.
- Calculator, Nautilus, PulseAudio controls, NetworkManager's connection
  editor, GNOME Settings, and desktop portal windows open floating.
- Browser picture-in-picture windows open floating, 20 px from the bottom-right
  corner.

Use `umbriel windows` to inspect the app ID and title before adding a rule. Keep
rules for application behavior in `umb.nix` rather than relying on a window's
current title or position by hand.

## Debugging

Validate the generated config and inspect compositor state:

```console
umbriel validate
umbriel outputs
umbriel workspaces
umbriel windows
umbriel layers
```

Inspect the session services and logs when startup or integration fails:

```console
systemctl --user status umbriel.service noctalia.service
journalctl --user -b -u umbriel.service -u noctalia.service
journalctl --user -b -u xdg-desktop-portal-umbriel
```

Umbriel can run nested in GNOME for basic compositor testing, but output,
session lock, input gesture, and portal behavior must be tested in a real
Umbriel session. Run `umbriel validate` after input updates, then test
lock/unlock, suspend, screenshots, external outputs, and screen sharing.
