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

## NixOS-Specific Concepts

- **Modules**: Functions that take `{config, pkgs, ...}` and return configuration
- **Options**: Declarative configuration interface
- **Packages**: Software built with Nix expressions
- **Services**: System services configured declaratively
- **Overlays**: Package set modifications
