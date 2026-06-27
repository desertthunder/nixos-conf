# Neovim

## What this config does

Home Manager enables Neovim, sets it as the default editor, and copies the
external Neovim config into `~/.config/nvim`.

## Nix location

- `flake.nix`: `neovim-config` input
- `conf/shared.nix`: `programs.neovim`
- `conf/shared.nix`: `home.file.".config/nvim"`

The flake input points at:

```text
github:desertthunder/nvim
```

## Portable setup

Clone the config directly:

```bash
git clone https://github.com/desertthunder/nvim ~/.config/nvim
```

Install Neovim and the language tools used by your projects. The broader editor
tool list lives in `conf/shared.nix` under `editor-tool-pkgs`.

## Nix workflow

Update the external config input from this repo:

```bash
nix flake update --update-input neovim-config
sudo nixos-rebuild switch --flake .#$(hostname)
```

## Portable workflow

Update the cloned config directly:

```bash
cd ~/.config/nvim
git pull
```

## Validate

Inside Neovim:

```vim
:checkhealth
:map
:Telescope keymaps
```

From the shell:

```bash
nvim --version
```
