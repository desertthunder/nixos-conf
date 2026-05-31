# Nix Notes

## Language basics

- Strings: `"hello"`, paths: `./file.nix`, lists: `[ a b c ]`.
- Attribute sets: `{ key = value; nested.x = 1; }`.
- Functions: `x: x + 1` or `{ pkgs, ... }: { }`.
- `let ... in ...` binds local names.
- `with pkgs; [ ripgrep fd ]` brings attrs into scope.

## Common patterns

Imports compose modules:

```nix
{
  imports = [ ./hardware-configuration.nix ];
}
```

Optional packages by platform:

```nix
home.packages = with pkgs; [ fd ] ++ lib.optionals stdenv.isLinux [ zathura ];
```

Read JSON into Nix:

```nix
builtins.fromJSON (builtins.readFile ./conf/modules/omp.json)
```

## Flakes

This repository's flake pins inputs for Nixpkgs, Home Manager, SOPS-Nix, and the
external Neovim config. `nixosConfigurations` maps host names to systems.

## Modules

NixOS and Home Manager modules return option assignments. Shared modules are now
collected in `conf/shared.nix` as two attrs:

- `(import ./conf/shared.nix).nixos`
- `(import ./conf/shared.nix).home`

Machine configs import the shared NixOS module and add host-specific options.
