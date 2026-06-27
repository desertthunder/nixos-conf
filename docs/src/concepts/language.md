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

## Impurities

Most Nix expressions are pure: they transform values into other values without
observing the outside world. The exception to know is how Nix introduces files
as build inputs.

The common case is a path such as `./data` or `./src`. A path literal is not
just a string. When Nix needs it as a build input, Nix hashes the referenced
file or directory, copies it into `/nix/store`, and uses the resulting store
path. Directories are copied as whole directory trees.

Fetchers apply the same pattern to remote inputs. Functions such as
`builtins.fetchurl`, `builtins.fetchTarball`, and `builtins.fetchGit` fetch
source material and return a store path. If the fetch cannot complete, the
expression cannot be evaluated.

Other impure expressions exist, including lookup paths such as `<nixpkgs>` and
host-dependent values such as `builtins.currentSystem`. When reading older
examples, treat these as values that depend on evaluator state outside the
expression itself.

## Derivations

A derivation is a build description. The Nix language describes derivations,
Nix realizes them, and the resulting store paths can be used as inputs to later
derivations.

The low-level primitive is `derivation`, but most Nix code uses wrappers such
as `stdenv.mkDerivation`, `mkShell`, language-specific builders, or NixOS
system builders. Those wrappers still produce derivations underneath.

Evaluating a derivation does not necessarily build it immediately. Evaluation
produces the build description and expected output path. Realization is the
later step where Nix builds the output locally or substitutes it from a binary
cache.

Derivations also work in string interpolation. If `pkg` is a derivation,
`"${pkg}"` evaluates to the store path of its build result. That lets one
derivation refer to another derivation's output as an input while the Nix
language still treats packages as composable values.

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

## References

- nix.dev: <https://nix.dev/tutorials/nix-language>
