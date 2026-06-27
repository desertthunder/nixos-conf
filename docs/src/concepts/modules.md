# Modules

NixOS and Home Manager are module systems. A _module_ is a Nix expression that
returns option assignments. Imported modules are merged into one final option
tree.

This is why different files can contribute to the same service, package list,
user account, or config file without manually concatenating everything.

## Merge Model

| Concept       | Meaning                                                             |
| ------------- | ------------------------------------------------------------------- |
| `imports`     | Adds more modules to the current module.                            |
| Options       | Declared settings such as `services.openssh.enable`.                |
| Values        | Assignments to options.                                             |
| Merge         | The module system combines compatible values and reports conflicts. |
| `lib.mkIf`    | Adds settings conditionally.                                        |
| `specialArgs` | Extra values passed to modules at evaluation time.                  |

- Lists usually concatenate.
- Attribute sets usually merge by key.
- Some options define custom merge behavior.
- Conflicting scalar values fail evaluation unless priority helpers are used.

## Repository Shape

`conf/shared.nix` exports two reusable modules:

- `(import ./conf/shared.nix).nixos`
- `(import ./conf/shared.nix).home`

Machine modules import the shared NixOS module, then add host-specific options.
Home Manager is attached from `flake.nix` so user configuration is built with
the system.

In general, keep generalized behavior in shared modules but keep hardware, one-off services,
and host-only desktop stacks in host modules or opt-in modules.
