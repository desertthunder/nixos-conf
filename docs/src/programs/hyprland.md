# Hyprland

- `flake.nix`: pins `nixpkgs` to `nixos-26.05`.
- `conf/shared.nix`: configures Home Manager for the `owais` user.
- `conf/shared.nix`: already configures Ghostty through Home Manager.
- `conf/machines/thinkpad/configuration.nix`: imports Hyprland for
  `nix-haxorus`.
- `conf/shared.nix`: enables shared GNOME/GDM system pieces.
- `conf/modules/de/hypr.nix`: enables Hyprland system pieces.
- `conf/modules/de/hypr-home.nix`: installs Hyprland companion packages and
  copies Hyprland, rofi, waybar, and mako user config.

Package updates come from updating the flake lock and rebuilding:

```bash
nix flake update
sudo nixos-rebuild test --flake .#$(hostname)
sudo nixos-rebuild switch --flake .#$(hostname)
```

Use `nix flake update nixpkgs` to update only `nixpkgs`.

## Host Scope

Hyprland is intentionally scoped to `nix-haxorus`. The ThinkPad machine module
imports the system desktop module:

```nix
imports = [
  ./hardware-configuration.nix
  (import ../../shared.nix).nixos
  ../../modules/de/hypr.nix
];
```

`flake.nix` adds the matching Home Manager module only for `nix-haxorus`:

```nix
home-manager.users.owais = {
  imports = [
    (import ./conf/shared.nix).home
    ./conf/modules/de/hypr-home.nix
  ];
};
```

Other hosts keep using `(import ./conf/shared.nix).home` directly, so they do
not inherit Hyprland, waybar, rofi, mako, or related services.

## System Module

Use the NixOS module for Hyprland. It adds the display-manager session and
sets up system pieces such as XWayland, portals, fonts, dconf, graphics, and
polkit integration.

`conf/shared.nix` keeps GDM and GNOME enabled for every NixOS host:

```nix
services.displayManager.gdm.enable = true;
services.desktopManager.gnome.enable = true;
```

`conf/modules/de/hypr.nix` keeps Hyprland scoped to the ThinkPad:

```nix
programs.hyprland = {
  enable = true;
  withUWSM = true;
  xwayland.enable = true;
};

environment.sessionVariables.NIXOS_OZONE_WL = "1";
```

## UWSM

UWSM is the Universal Wayland Session Manager. Hyprland's docs describe it as
wrapping standalone Wayland compositors as systemd units, with session
environment handling, XDG autostart, login-session binding, and clean shutdown.
On NixOS, `programs.hyprland.withUWSM = true` creates a
`hyprland-uwsm.desktop` entry. In GDM, choose `Hyprland (uwsm-managed)`.

## Ghostty

Ghostty can be used instead of Kitty. Kitty appears in Hyprland examples
because the default example config binds its terminal command to Kitty.

```nix
home.packages = with pkgs; [
  ghostty
  waybar
  rofi
  hyprpaper
  hyprlock
  hypridle
  hyprpolkitagent
  grim
  slurp
  wl-clipboard
  mako libnotify satty
];
```

The local config binds `Super-Return` to Ghostty and `Super-Z` to
`ghostty -e zellij`.

## Home Manager

The system-level enablement should stay in the NixOS module. Home Manager is
appropriate for user-level Hyprland config and companion app config.

Configured project layout:

```text
conf/modules/hypr/
|-- hypridle.conf
|-- shot.sh
|-- wallpapers/
`-- hyprland.lua

conf/modules/rofi/
|-- marble.rasi
`-- config.rasi

conf/modules/waybar/
|-- config.jsonc
|-- power.sh
`-- style.css
```

`conf/modules/de/hypr-home.nix` installs those files with relative paths from
the `conf/modules/de/` directory:

```nix
xdg.configFile."hypr/hyprland.lua".source = ../hypr/hyprland.lua;
xdg.configFile."hypr/hypridle.conf".source = ../hypr/hypridle.conf;
xdg.configFile."hypr/shot.sh" = {
  source = ../hypr/shot.sh;
  executable = true;
};
xdg.configFile."hypr/wallpapers" = {
  source = ../hypr/wallpapers;
  recursive = true;
};

xdg.configFile."hypr/hyprpaper.conf".text = ''
  splash = false

  wallpaper {
    monitor =
    path = /nix/store/.../wall00.png
    fit_mode = cover
  }
'';

xdg.configFile."rofi" = {
  source = ../rofi;
  recursive = true;
};

xdg.configFile."waybar" = {
  source = ../waybar;
  recursive = true;
};
```

`hyprpaper`, `waybar`, `hypridle`, and `mako` are managed as Home Manager user
services in the Hyprland home module.

The Home Manager Hyprland module can also be used, but the upstream docs still
separate responsibilities: the NixOS module is required for correct system
integration, while the Home Manager module is optional for declarative user
configuration.

## Theme

Palette: background `#151516`, surface `#181818`, border `#2a2a2a`,
accent `#51a4e7`, gaps `4` inner / `8` outer, rounding `8`. The same palette
is used by Hyprland, rofi, and the local Zellij theme `marble`.

## Configured Keybinds

| Key                  | Action                           |
| -------------------- | -------------------------------- |
| `Super-Return`       | Open Ghostty                     |
| `Super-Z`            | Open Ghostty with Zellij         |
| `Super-B`            | Open Zen Browser                 |
| `Super-E`            | Open Nautilus                    |
| `Super-R`            | Open rofi app launcher           |
| `Super-Space`        | Open rofi app launcher           |
| `Super-Shift-R`      | Reload Hyprland config           |
| `Super-P`            | Open rofi run launcher           |
| `Super-Shift-L`      | Lock session                     |
| `Super-Q`            | Close focused window             |
| `Super-Shift-F`      | Toggle centered floating         |
| `Super-Shift-G`      | Toggle fullscreen                |
| `Super-Shift-H`      | Toggle fake fullscreen           |
| `Super-Shift-J`      | Toggle Dwindle split             |
| `Super-h/j/k/l`      | Move focus                       |
| `Super-arrow`        | Move focus                       |
| `Super-Ctrl-h/j/k/l` | Resize focused window            |
| `Super-Alt-h/j/k/l`  | Move focused window              |
| `Super-1..0`         | Switch to workspace 1..10        |
| `Super-Shift-1..0`   | Move window to workspace 1..10   |
| `Super-S`            | Toggle scratch workspace         |
| `Super-Shift-S`      | Move window to scratch workspace |
| `Super-mouse1`       | Drag window                      |
| `Super-mouse2`       | Resize window                    |
| `Print`              | Region screenshot with editor    |
| `Shift-Print`        | Full screenshot with editor      |
| `Ctrl-Print`         | Region screenshot, no editor     |
| `Ctrl-Shift-Print`   | Full screenshot, no editor       |

Media keys control PipeWire volume, brightness, and `playerctl`.
Screenshots use `grim`, `slurp`, `satty`, `wl-copy`, and `notify-send`.
All screenshot paths save, copy, and write to `~/Pictures/Screenshots`.

## Sources

- Hyprland wiki: `Hyprland on NixOS`, last updated 2026-06-18.
- Hyprland wiki: `Hyprland on Home Manager`, last updated 2026-06-18.
- Hyprland wiki: `Systemd startup`, last updated 2026-06-18.
