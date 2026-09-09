# Noctalia

Haxorus uses [Noctalia](https://docs.noctalia.dev/noctalia/) for its Wayland
shell. It replaces Waybar, rofi, cliphist, mako, SwayOSD, hyprpaper, hypridle,
hyprlock, the power menu, and the old screenshot scripts. [Umbriel](./umbriel.md) provides the compositor.

## Session

Choose **Umbriel** in GDM. Umbriel starts `umbriel-session.target`, which starts
Noctalia as a systemd user service. Noctalia then provides the shell surfaces
and desktop services for that session.

Noctalia is configured in `conf/modules/de/noct.nix`. The module imports its
NixOS and Home Manager modules. The ThinkPad configuration imports `noct.nix`.

The first rebuild must accept the Noctalia binary cache configuration:

```console
sudo nixos-rebuild switch --accept-flake-config \
  --flake "$NIXOS_CONFIG#nix-haxorus"
```

That generation adds the cache to the system Nix settings, so later rebuilds
can use the normal `rebuild` alias.

## Configuration ownership

Home Manager generates the read-only Noctalia configuration at
`~/.config/noctalia/config.toml` from `programs.noctalia.settings` in
`noct.nix`.

Noctalia stores changes made through Settings and the desktop widget editor in
`~/.local/state/noctalia/settings.toml`. This writable file loads after the
Home Manager file, so a saved GUI value overrides the corresponding value in
`noct.nix`.

Delete the relevant key from `settings.toml`, or delete the whole file while
Noctalia is stopped, to return that setting to Home Manager. Use
**Settings → Export Config → Merged User Config** to inspect or promote GUI
changes. Move wanted values into `noct.nix`, rebuild, and remove their GUI
overrides. Do not edit the Home Manager symlink under `~/.config`.

## Shell surfaces

The floating top bar has an 8 px screen margin and rounded corners. It contains:

- the launcher and per-output workspaces on the left;
- the active media player in the center;
- network, Bluetooth, volume, brightness, battery, idle inhibition,
  notifications, tray, clock, Control Center, and session controls on the
  right.

The launcher searches desktop applications and includes calculator, emoji,
session, wallpaper, and window providers. Prefix a search with `/calc`, `/emo`,
`/session`, `/wall`, or `/win` to select one provider.

Control Center provides media and stream controls, display brightness, system
status, NetworkManager, Bluetooth, notification history, and UPower battery
information. Weather, calendar, and screen-time tabs are hidden because those
services are not configured. Session actions are also available in the
separate session panel.

Noctalia is the notification daemon. Dismissing a toast keeps it in Control
Center history. Do Not Disturb suppresses new toasts without stopping history.

The dock and desktop widgets are disabled.

The lock screen uses `wall00.png`, a dark tint, password authentication, and
fingerprint authentication. Noctalia locks before suspend, including suspend
caused by closing the lid.

## Theme

Noctalia uses Inter and the built-in dark `Eldritch` palette. The custom
`Haxorus` palette remains commented out in `noct.nix` so it can be restored
without reconstructing its color roles.

Panels are solid and bordered rather than glassy. Application theme templates
are disabled, so the palette does not rewrite GTK, Qt, terminal, or editor
themes.

## Idle and power

Noctalia is the only idle daemon:

| Idle time  | Action                                           |
| ----------:| ------------------------------------------------ |
| 5 minutes  | Lock the session.                                |
| 5:30       | Turn displays off. Activity turns them on again. |
| 15 minutes | Lock and suspend the machine.                    |

Wayland idle inhibitors are honored. The bar's caffeine control can also keep
the session awake.

UPower supplies battery status and health. TLP controls CPU and laptop power
policy. `power-profiles-daemon` is disabled to avoid conflicting with TLP, so
Noctalia can show battery information but has no power-profile selector.

## Screenshots and media keys

The Umbriel keymap sends screenshot and media actions to Noctalia. Screenshots
open its annotation editor, save under `~/Pictures/Screenshots`, and copy the
result to the clipboard. Media keys control volume, microphone, brightness, and
playback; Noctalia displays the corresponding OSD.

See [Umbriel](./umbriel.md#keybindings) for the complete keymap.

## Debugging

Check the service, log, IPC connection, and merged configuration:

```console
systemctl --user status noctalia.service
journalctl --user -b -u noctalia.service
noctalia status
noctalia config validate
noctalia config export full | yq -p toml '.'
```

If a declared setting is ignored, inspect the winning GUI layer:

```console
$EDITOR ~/.local/state/noctalia/settings.toml
```

Noctalia requires an Umbriel session for layer-shell, session lock, workspace,
and output integration. See [Umbriel debugging](./umbriel.md#debugging) when the
service runs but compositor integration fails.
