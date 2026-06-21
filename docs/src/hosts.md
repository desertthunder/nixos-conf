# Hosts

The flake builds two NixOS hosts. Both import `conf/shared.nix` and then add
machine-specific options from `conf/machines/{machine}/configuration.nix`.

## nix-haxorus

ThinkPad configuration.

Files:

- `conf/machines/thinkpad/configuration.nix`
- `conf/machines/thinkpad/hardware-configuration.nix`
- `conf/modules/de/hypr.nix`
- `conf/modules/de/hypr-home.nix`

Flake target:

```bash
sudo nixos-rebuild test --flake .#nix-haxorus
sudo nixos-rebuild switch --flake .#nix-haxorus
```

Host-specific settings:

- hostname: `nix-haxorus`
- thermal daemon enabled
- TLP enabled
- `power-profiles-daemon` disabled
- default TLP mode set to battery
- CPU governor set to `performance` on AC and `powersave` on battery
- fingerprint daemon enabled
- Hyprland desktop enabled through host-specific modules

## nix-baxcalibur

HP configuration.

Files:

- `conf/machines/hp/configuration.nix`
- `conf/machines/hp/hardware-configuration.nix`

Flake target:

```bash
sudo nixos-rebuild test --flake .#nix-baxcalibur
sudo nixos-rebuild switch --flake .#nix-baxcalibur
```

Host-specific settings:

- hostname: `nix-baxcalibur`

The HP file imports shared config and hardware config. GNOME is enabled through
shared config; Hyprland stays ThinkPad-specific.

## Add another host

See [Adding a New Machine](./adding-a-new-machine.md) for the full workflow.
