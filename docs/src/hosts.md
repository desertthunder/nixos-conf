# Hosts

The flake builds two NixOS hosts. Both import `conf/shared.nix` and then add
machine-specific options from `conf/machines/{machine}/configuration.nix`.

## nix-haxorus

ThinkPad configuration.

Files:

- `conf/machines/thinkpad/configuration.nix`
- `conf/machines/thinkpad/hardware-configuration.nix`

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

## owais-nix-hp

HP configuration.

Files:

- `conf/machines/hp/configuration.nix`
- `conf/machines/hp/hardware-configuration.nix`

Flake target:

```bash
sudo nixos-rebuild test --flake .#owais-nix-hp
sudo nixos-rebuild switch --flake .#owais-nix-hp
```

Host-specific settings:

- hostname: `owais-nix-hp`

The HP file currently only imports shared config and hardware config.

## Add another host

1. Create `conf/machines/{machine}/`.
2. Generate hardware config:

   ```bash
   sudo nixos-generate-config --show-hardware-config \
     > conf/machines/{machine}/hardware-configuration.nix
   ```

3. Add `configuration.nix` that imports hardware config and
   `(import ../../shared.nix).nixos`.
4. Set `networking.hostName`.
5. Add a `nixosConfigurations.{hostname}` entry in `flake.nix`.
6. Test before switching:

   ```bash
   sudo nixos-rebuild test --flake .#{hostname}
   ```
