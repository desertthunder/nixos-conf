# Nix Language Reference

Core language concepts and patterns used throughout this configuration.

## Basic Types

### Comments

```nix
# Single-line comment
/* Multi-line
   comment */
```

### Booleans & Logic

| Expression                   | Result  | Description |
| ---------------------------- | ------- | ----------- |
| `true && false`              | `false` | Logical AND |
| `true \|\| false`            | `true`  | Logical OR  |
| `if 3 < 4 then "a" else "b"` | `"a"`   | Conditional |

### Numbers

```nix
42 (-3)           # Integers
123.43 .27e13     # Floats
4 + 6 - 2         # Arithmetic (preserves type)
7 / 2             # Integer division → 3
7 / 2.0           # Float division → 3.5
```

### Strings

```nix
"Simple string"

# Multi-line string
"
  Spans multiple
  lines
"

# Indented string (strips leading whitespace)
''
  Intelligent
    indentation
''

# String interpolation
"Your home is ${getEnv "HOME"}"

# Concatenation
"hello" + " world"
```

## Data Structures

### Lists

```nix
[1 2 3 "mixed"]                    # List literal
[1 2] ++ [3 4]                     # Concatenation → [1 2 3 4]
head [1 2 3]                       # First element → 1
tail [1 2 3]                       # Rest → [2 3]
elemAt ["a" "b" "c"] 1             # Index access → "b"
filter (x: x < 3) [1 2 3 4]        # Filtering → [1 2]
```

### Sets (Attribute Sets)

```nix
{ foo = 1; bar = "text"; }         # Set literal
set.foo                            # Access attribute → 1
set ? foo                          # Check existence → true
{ a = 1; } // { b = 2; }           # Merge sets → { a = 1; b = 2; }

# Nested attributes
{
  a.b = 1;
  a.c.d = 2;
}

# Recursive sets (self-referential)
rec {
  x = 1;
  y = x + 1;  # Can reference x
}
```

### Paths

```nix
/absolute/path                     # Absolute path
./relative/path                    # Relative to current file
../parent/path                     # Parent directory

# Path vs division
./path/to/file                     # Path
(7 / 2)                           # Division (needs parentheses)
```

## Functions & Control Flow

### Functions

```nix
x: x + 1                          # Lambda function
(x: x + 1) 5                      # Application → 6

# Curried functions (multiple args)
x: y: x + y                       # Takes x, returns function taking y
add = x: y: x + y                 # Named via let binding
add 1 2                           # Application → 3

# Set patterns (destructuring)
{x, y}: x + y                     # Extract x and y from set
{x, y, ...}: x + y                # Ignore extra attributes
args@{x, y}: args.x + args.y      # Bind whole set to args
```

### Let Bindings

```nix
let
  x = 1;
  y = x + 1;                      # Can reference other bindings
in x + y                          # Scope of bindings

# Order doesn't matter
let
  y = x + 1;
  x = 1;                          # Defined after use
in y
```

### With Expressions

```nix
with pkgs; [                      # Import all attributes from pkgs
  git
  vim
  # Instead of pkgs.git, pkgs.vim
]

with { a = 1; b = 2; };
a + b                             # Access a and b directly
```

## Imports & Modularity

```nix
import ./other-file.nix           # Import file
import /absolute/path.nix         # Absolute import

# File contains single expression
# ./config.nix:
{ option1 = true; option2 = "value"; }

# Usage:
let config = import ./config.nix;
in config.option1
```

## Error Handling

```nix
throw "error message"             # Throw error
abort "fatal error"               # Uncatchable error
assert condition; value           # Assert condition
tryEval expression                # Catch errors → {success, value}
```

## Common Patterns in This Config

### Function Arguments

```nix
{ config, pkgs, ... }:           # Common pattern in NixOS modules
{
  # Module content
}
```

### Package Lists

```nix
environment.systemPackages = with pkgs; [
  git
  vim
  firefox
];
```

### Conditional Configuration

```nix
services.xserver = {
  enable = true;
  displayManager.gdm.enable = true;
  desktopManager.gnome.enable = true;
};
```

### Font Configuration

```nix
fonts.packages = with pkgs; [
  nerd-fonts.jetbrains-mono
  nerd-fonts.commit-mono
];
```

### Home Manager Integration

```nix
home-manager.users.owais = import ./home.nix;
```

## Built-in Functions

| Function   | Purpose           | Example                               |
| ---------- | ----------------- | ------------------------------------- |
| `length`   | List length       | `length [1 2 3]` → `3`                |
| `head`     | First element     | `head [1 2 3]` → `1`                  |
| `tail`     | Rest of list      | `tail [1 2 3]` → `[2 3]`              |
| `map`      | Transform list    | `map (x: x * 2) [1 2 3]` → `[2 4 6]`  |
| `filter`   | Filter list       | `filter (x: x > 1) [1 2 3]` → `[2 3]` |
| `getEnv`   | Environment var   | `getEnv "HOME"`                       |
| `toString` | Convert to string | `toString 42` → `"42"`                |

## Advanced Concepts

### Inherit Keyword

The `inherit` keyword provides a convenient way to copy variables from one scope into an attribute set. This is extremely common in Nix code as it reduces repetition and makes code cleaner.

```nix
let
  x = 1;
  y = 2;
in
{
  inherit x y;                    # Same as: x = x; y = y;
  inherit (pkgs) git vim;         # Same as: git = pkgs.git; vim = pkgs.vim;
}
```

Without `inherit`, you'd have to write `x = x; y = y;` which is redundant. The `inherit (source)` form lets you extract multiple attributes from a set in one line, commonly used with `pkgs` to import packages.

### System Architecture

Nix uses specific strings to identify different computer architectures and operating systems. These determine which packages can be built and run on your system.

```nix
"x86_64-linux"                   # 64-bit Intel/AMD Linux
"aarch64-linux"                  # 64-bit ARM Linux
"x86_64-darwin"                  # 64-bit Intel macOS
"aarch64-darwin"                 # 64-bit ARM macOS (Apple Silicon)
```

You'll see these in flakes when defining system configurations. The choice affects which binary packages are available from the cache and which ones need to be built from source.

## Flakes

Flakes are the modern approach to Nix package and configuration management. They provide reproducible builds with locked dependencies and a standardized structure for inputs and outputs. This configuration uses flakes extensively to manage both NixOS and Darwin systems.

### Flake Structure

A flake is a Nix file that defines `inputs` (dependencies) and `outputs` (what the flake provides). The structure is standardized, making flakes composable and easy to understand.

```nix
{
  description = "My configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";    # Use same nixpkgs
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.my-machine = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };     # Pass inputs to modules
      modules = [ ./configuration.nix ];
    };
  };
}
```

### Input Following

Input following is a crucial feature that prevents dependency duplication. When one flake depends on another, both might depend on `nixpkgs`. Without following, you could end up with multiple versions of nixpkgs in your dependency tree.

```nix
inputs.nixpkgs.follows = "nixpkgs";       # Use parent's nixpkgs input
```

This tells home-manager to use the same nixpkgs version as the parent flake, ensuring consistency and reducing closure size.

### Special Arguments

Special arguments allow you to pass additional parameters to modules beyond the standard ones (`config`, `pkgs`, `lib`). This is essential for passing flake inputs to your configuration modules.

```nix
specialArgs = { inherit inputs; };        # Pass to NixOS modules
extraSpecialArgs = { inherit inputs; };   # Pass to Home Manager modules
```

With this setup, your modules can access flake inputs directly:

```nix
{ config, pkgs, inputs, ... }:           # Now inputs is available
{
  # Access flake inputs like inputs.neovim-config
  # Use inputs.sops-nix.nixosModules.sops
}
```

This pattern is used throughout this configuration to access custom flakes like the Neovim configuration and SOPS secrets management.

## NixOS Module System

The NixOS module system is a powerful framework for composable configuration. Modules are functions that take certain arguments and return configuration options. They can define new options, set configuration values, and import other modules.

### Module Structure

A typical NixOS module has three main sections: imports, options, and config. Not all sections are required - simple modules often only have configuration.

```nix
{ config, pkgs, lib, ... }:
{
  imports = [                             # Import other modules
    ./hardware-configuration.nix
  ];

  options = {                             # Define new options
    myOption = lib.mkOption {
      type = lib.types.str;
      default = "value";
    };
  };

  config = {                              # Configuration values
    environment.systemPackages = with pkgs; [ git ];
  };
}
```

### Module Arguments

NixOS modules receive several standard arguments that provide access to the system state and utilities:

- `config`: The merged configuration of all modules - lets you read options set by other modules
- `pkgs`: The package set (from nixpkgs) - use this to reference software packages
- `lib`: Utility functions for building options, manipulating data, etc.
- `...`: Additional arguments passed via `specialArgs` (like flake inputs)

### Overlays

Overlays allow you to modify or extend the package set without changing nixpkgs itself.
They're functions that take the final package set and the previous package set, returning new or modified packages.

```nix
nixpkgs.overlays = [
  (final: prev: {
    myCustomPackage = prev.stdenv.mkDerivation {
      # Package definition
    };
  })
];
```

Use overlays to patch existing packages, add new ones, or override package versions.
The `final` set contains all packages (including those from other overlays), while `prev` contains packages from before this overlay was applied.

## NixOS-Specific Concepts

- **Modules**: Functions that take `{config, pkgs, ...}` and return configuration
- **Options**: Declarative configuration interface
- **Packages**: Software built with Nix expressions
- **Services**: System services configured declaratively
- **Generations**: System state snapshots for rollbacks
- **Derivations**: Build instructions for packages
