# Neovim

Neovim is managed by Home Manager in `conf/shared.nix`, while the actual editor
configuration comes from the external `neovim-config` flake input.

```nix
home.file.".config/nvim" = {
  source = neovim-config;
  recursive = true;
};
```

## Defaults

- `programs.neovim.enable = true`
- `viAlias`, `vimAlias`, and `defaultEditor` are enabled.
- Python and Ruby providers are kept enabled for compatibility.

## Workflow

- Edit the upstream Neovim config repo for plugin/keymap/theme changes.
- Run `nix flake update --update-input neovim-config` here to pull changes.
- Rebuild this system to install the updated config.

## Quick keys

Common habits preserved from the existing config:

- `<leader>` opens the main custom mappings namespace.
- Telescope-style pickers are used for files, text, buffers, and help.
- LSP mappings cover definition, references, rename, code actions, and hover.
- Formatting and diagnostics are available through normal LSP commands.

Use Neovim's built-in helpers when unsure:

```vim
:map
:Telescope keymaps
:checkhealth
```
