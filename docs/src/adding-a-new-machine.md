# Adding A New Machine

This page is the operational checklist for adding a NixOS host to the flake.

For why flakes, modules, and Home Manager work this way, see [Nix Concepts](./concepts.md).

## Naming

Pick two names before creating files:

| Name      | Example           | Used for                                      |
| --------- | ----------------- | --------------------------------------------- |
| Directory | `framework`, `x1` | Human-readable folder under `conf/machines/`. |
| Hostname  | `haxorus`         | `networking.hostName` and flake target.       |

They may match, but they do not have to.

Existing hosts use short hardware directory names and Pokemon hostnames.

## Checklist

| Step                     | File or command                                  | Notes                                          |
| ------------------------ | ------------------------------------------------ | ---------------------------------------------- |
| Generate hardware config | `nixos-generate-config --show-hardware-config`   | Store it in the new host directory.            |
| Add host module          | `conf/machines/{machine}/configuration.nix`      | Import hardware and shared NixOS config.       |
| Set hostname             | `networking.hostName = "{hostname}";`            | Must match the flake target you plan to build. |
| Add flake output         | `nixosConfigurations.{hostname}`                 | Copy the shape of existing hosts.              |
| Choose architecture      | `x86_64-linux` or `aarch64-linux`                | Match the target CPU.                          |
| Build temporarily        | `sudo nixos-rebuild test --flake .#{hostname}`   | Safer first activation.                        |
| Make persistent          | `sudo nixos-rebuild switch --flake .#{hostname}` | Only after the test generation works.          |

## Host Directory

Create:

```text
conf/machines/{machine}/
├── configuration.nix
└── hardware-configuration.nix
```

`hardware-configuration.nix` should stay mostly generated. It captures machine
facts: filesystems, swap, kernel modules, CPU hints, and hardware-specific
imports.

`configuration.nix` should contain host choices: hostname, hardware workarounds,
desktop stack imports, power management, and services that belong only on that
machine.

Keep general packages, users, shell defaults, editor defaults, and shared
secrets in `conf/shared.nix`.

## Minimal Host Module

```nix
{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    (import ../../shared.nix).nixos
  ];

  networking.hostName = "{hostname}";
}
```

For a host-specific desktop stack, import its system module here. `nix-haxorus`
does this for Hyprland.

## Flake Output

Add a `nixosConfigurations.{hostname}` entry in `flake.nix`. Copy an existing
host entry and adjust:

- output name
- `system`
- machine configuration path
- any host-specific Home Manager imports

This repo wires Home Manager through each NixOS system, so normal
`nixos-rebuild` applies both system and user changes.

## Activation

Build and activate temporarily:

```bash
sudo nixos-rebuild test --flake .#{hostname}
```

If it works, make it the boot default:

```bash
sudo nixos-rebuild switch --flake .#{hostname}
```

If a switched generation is bad:

```bash
sudo nixos-rebuild switch --rollback
```

## Final Review

- Hardware config is present and machine-specific.
- Host module imports shared NixOS config.
- Hostname and flake output name match.
- Architecture matches the machine.
- Host-only features stayed out of `conf/shared.nix`.
- Shared behavior went into `conf/shared.nix`.
- `test` succeeded before `switch`.
