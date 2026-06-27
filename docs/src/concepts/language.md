# Language Basics

Nix is an expression language. Files evaluate to values: strings, paths, lists,
attribute sets, functions, or larger structures built from those pieces.

| Form                        | Meaning                                         |
| --------------------------- | ----------------------------------------------- |
| `"hello"`                   | String                                          |
| `./file.nix`                | Path, copied into the Nix store when referenced |
| `[ a b c ]`                 | List                                            |
| `{ key = value; }`          | Attribute set                                   |
| `x: x + 1`                  | Function                                        |
| `{ pkgs, ... }: { }`        | Function taking an attribute set                |
| `let name = value; in body` | Local binding                                   |

Attribute sets are the central shape. NixOS modules, Home Manager modules,
flake inputs, flake outputs, package sets, and option trees are all attribute
sets at different layers.

## Common Idioms

Imports compose modules:

```nix
{
  imports = [ ./hardware-configuration.nix ];
}
```

Package lists are ordinary lists:

```nix
home.packages = with pkgs; [
  fd
  zathura
];
```

`with pkgs;` brings package names into scope for the expression that follows.
It is convenient for package lists, but avoid using it when it would make the
origin of names unclear.

Read structured files with builtins when a native parser is available:

```nix
builtins.fromJSON (builtins.readFile ./config.json)
```

Prefer data formats and module options over ad hoc string generation. Generated
text is useful for application config files, but it should not be the first
tool for structured data.
