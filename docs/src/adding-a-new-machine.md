# Adding a New Machine

This page explains how to add a NixOS computer to this flake. It covers the
mechanics, but also the concepts that make the workflow reliable.

The short version is:

1. Generate hardware configuration on the new machine.
2. Add a host directory under `conf/machines/`.
3. Add a `nixosConfigurations.<hostname>` entry to `flake.nix`.
4. Build with `test` first, then switch once the result looks right.

## Mental model

NixOS systems are built from modules, Nix files that declare option values.
`configuration.nix` is a module, imported files are modules, and NixOS merges
all of those option definitions into one system configuration.[^modules]

This is how the repository models modules:

```text
conf/
├── machines/
│   ├── hp/
│   └── thinkpad/
├── modules/
│   └── de/
└── shared.nix
```

- `conf/shared.nix` contains reusable NixOS and Home Manager modules.
- `conf/machines/{machine}/configuration.nix` contains host-specific choices.
- `conf/machines/{machine}/hardware-configuration.nix` contains hardware
  discovered on that machine.
- `conf/modules/` contains app config assets and focused modules.
- `conf/modules/de/` contains opt-in desktop-environment modules.
- `flake.nix` maps a hostname to a complete NixOS system.

The flake is the entry point.

- `inputs` pin external dependencies such as Nixpkgs and Home Manager,
- `outputs` expose buildable things.[^flake-format]

For NixOS hosts, the important output is `nixosConfigurations.<hostname>`,
which is the target used by `nixos-rebuild --flake .#<hostname>`.[^flake-nixos]

The lock file records exact input revisions, so a rebuild uses the same source
graph until you intentionally update it.[^flake-lock]

## Naming

The convention I stick to is to pick two names before creating files:

- Directory name: a short machine label, such as `framework` or `x1`.
- Hostname: the value of `networking.hostName` (a Pokemon)
  like `haxorus`

The directory name is for humans (me) reading the repo.

The hostname is the flake target and the NixOS network identity. They can
match, but they do not have to.

## Generate Hardware Config

Run this on the new NixOS machine after disks are mounted or after the machine
is already installed:

```bash
sudo nixos-generate-config --show-hardware-config \
  > conf/machines/{machine}/hardware-configuration.nix
```

During a fresh install, the NixOS manual uses `nixos-generate-config --root
/mnt` as part of the normal installation sequence.[^install-summary]

This repo stores the generated hardware module in the host directory instead
of leaving it under `/etc/nixos`.

Treat `hardware-configuration.nix` as mostly generated. It usually contains
filesystem mounts, swap devices, kernel modules, CPU microcode hints, and other
facts that are specific to the machine. Keep shared preferences out of this
file.

## Machine Module

Create `conf/machines/{machine}/configuration.nix`:

```nix
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    (import ../../shared.nix).nixos
  ];

  networking.hostName = "{hostname}";
}
```

Add host-specific settings below `networking.hostName` like:

- Laptop power management.
- Fingerprint reader support.
- Machine-specific graphics options.
- Hardware workarounds.

Avoid putting general preferences here. If every machine should get a package,
service, user, shell, desktop setting, or secret integration, put it in
`conf/shared.nix` to keep new machines boring.

If a desktop stack should only exist on one host, import it explicitly from the
host module instead of adding it to `conf/shared.nix`. For example,
`nix-haxorus` imports `../../modules/de/hypr.nix`.

## Flake Output

Open `flake.nix` and add another entry inside `nixosConfigurations`:

```nix
{hostname} = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit inputs; };
  modules = [
    ./conf/machines/{machine}/configuration.nix
    home-manager.nixosModules.home-manager
    {
      home-manager.extraSpecialArgs = {
        root = ./.;
        inherit (inputs) neovim-config;
        inherit inputs;
      };
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.owais = (import ./conf/shared.nix).home;
      home-manager.backupFileExtension = null;
    }
  ];
};
```

Use `system = "aarch64-linux";` instead if the target machine is ARM Linux.
Flake outputs are architecture-aware, so the system string is part of the build
identity.[^flake-schema]

This repository wires Home Manager into each NixOS system as a NixOS module, so
the user environment is built together with `nixos-rebuild`.[^home-manager]
`home-manager.useGlobalPkgs = true` makes Home Manager use the same Nixpkgs
instance as the system, and `home-manager.useUserPackages = true` installs user
packages under `/etc/profiles/per-user`.[^home-manager-options]

For host-specific Home Manager modules, wrap the shared home module in an
imports list. `nix-haxorus` uses this for Hyprland:

```nix
home-manager.users.owais = {
  imports = [
    (import ./conf/shared.nix).home
    ./conf/modules/de/hypr-home.nix
  ];
};
```

## Build and Activate

From the repo on the NixOS machine:

```bash
sudo nixos-rebuild test --flake .#{hostname}
```

`test` builds the system and activates it for the running boot only.

If the configuration breaks the machine, rebooting returns to the previous boot
default.[^rebuild]

Once the result works:

```bash
sudo nixos-rebuild switch --flake .#{hostname}
```

`switch` builds, activates, and makes the new generation the boot default.[^rebuild]
If a bad generation was switched, roll back with:

```bash
sudo nixos-rebuild switch --rollback
```

This is possible because NixOS keeps previous generations.[^rollback]

## Update inputs intentionally

Keep the lock file stable unless the task is specifically to update the system:

```bash
nix flake update
```

After an input update, rebuild one host with `test` before switching every
machine.

## Checklist

- [ ] `conf/machines/{machine}/hardware-configuration.nix` exists.
- [ ] `conf/machines/{machine}/configuration.nix` imports hardware and shared NixOS
      config.
- [ ] `networking.hostName` matches the intended flake target.
- [ ] `flake.nix` has `nixosConfigurations.{hostname}`.
- [ ] The `system` value matches the CPU architecture.
- [ ] The machine builds
  - `sudo nixos-rebuild test --flake .#{hostname}`.
- [ ] The machine switches
  - `sudo nixos-rebuild switch --flake .#{hostname}`.

[^modules]: [NixOS Manual: Modularity](https://nixos.org/manual/nixos/stable/#sec-modularity).

[^flake-format]: [Nix Reference Manual: Flake format](https://nix.dev/manual/nix/latest/command-ref/new-cli/nix3-flake#flake-format).

[^flake-nixos]: [Official NixOS Wiki: Flake schema](https://wiki.nixos.org/wiki/Flakes#Flake_schema).

[^flake-lock]: [Nix Reference Manual: Lock files](https://nix.dev/manual/nix/latest/command-ref/new-cli/nix3-flake#lock-files).

[^install-summary]: [NixOS Manual: Installation Summary](https://nixos.org/manual/nixos/stable/#sec-installation-manual-summary).

[^flake-schema]: [Official NixOS Wiki: Output schema](https://wiki.nixos.org/wiki/Flakes#Output_schema).

[^home-manager]: [Home Manager Manual](https://nix-community.github.io/home-manager/).

[^home-manager-options]: [Home Manager NixOS options](https://nix-community.github.io/home-manager/options/nixos/home-manager.html).

[^rebuild]: [NixOS Manual: Changing the Configuration](https://nixos.org/manual/nixos/stable/#sec-changing-config).

[^rollback]: [NixOS Manual: Rolling Back Configuration Changes](https://nixos.org/manual/nixos/stable/#sec-rollback).
