# Tools

## ripgrep

Ripgrep is installed by Home Manager and configured at
`~/.config/ripgrep/config` from `conf/shared.nix`.

Common searches:

```bash
rg pattern
rg -i pattern
rg "fn name" -t nix
rg pattern path/to/dir
rg -n -C 2 pattern
rg --files
rg --files -g '*.nix'
```

Filtering:

```bash
rg pattern -g '*.nix'
rg pattern -g '!**/node_modules/**'
rg pattern --hidden -g '!.git'
rg pattern -t md
```

Output:

```bash
rg pattern --json
rg pattern --count
rg pattern --files-with-matches
rg pattern --replace replacement
```

Project defaults:

```text
--line-number
--smart-case
--max-columns=120
--max-columns-preview
--type-add=nix:*.nix
--glob=!.git/*
--glob=!**/node_modules/**
--glob=!**/target/**
--glob=!**/.build/**
```

## OCaml

Home Manager installs `opam`, `ocaml`, `dune`, `utop`, `ocamlformat`, and the
OCaml language server.

For a new switch:

```bash
opam init
opam switch create . ocaml-base-compiler.5.4.1
opam install . --deps-only --with-test --with-doc
```

## Other CLI tools

Home Manager installs common helpers including `fd`, `jq`, `yq`, `fzf`, `bat`,
`dust`, `tree`, `zellij`, `gum`, `glow`, `vhs`, `btop`, `cava`, `shellcheck`,
`shfmt`, `zig`, `zls`, `lldb`, `typst`, and `mdbook`.
