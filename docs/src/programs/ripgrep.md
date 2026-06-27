# ripgrep

## What this config does

Home Manager installs ripgrep and writes a default config to
`~/.config/ripgrep/config`.

## Nix location

- `conf/shared.nix`: installs `ripgrep`
- `conf/shared.nix`: `home.file.".config/ripgrep/config"`

## Portable setup

Install ripgrep:

Fedora:

```bash
sudo dnf install ripgrep
```

Ubuntu/Debian:

```bash
sudo apt install ripgrep
```

Create the config file:

```bash
mkdir -p ~/.config/ripgrep
cat > ~/.config/ripgrep/config <<'EOF'
--line-number
--smart-case
--max-columns=120
--max-columns-preview
--type-add=nix:*.nix
--glob=!.git/*
--glob=!**/node_modules/**
--glob=!**/target/**
--glob=!**/.build/**
EOF
```

## Common commands

```bash
rg pattern
rg -i pattern
rg "fn name" -t nix
rg pattern path/to/dir
rg -n -C 2 pattern
rg --files
rg --files -g '*.nix'
```

## Validate

```bash
rg --version
rg --files -t nix
```

Use `--no-config` when scripts need results that do not depend on personal rg
settings.
