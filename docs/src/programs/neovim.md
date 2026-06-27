# Neovim

Home Manager enables Neovim, sets it as the default editor, and copies the
external Neovim config from the `neovim-config` flake input.

## Summary

| Area             | Current shape                               |
| ---------------- | ------------------------------------------- |
| Config source    | `github:desertthunder/nvim` flake input     |
| Installed config | `~/.config/nvim`                            |
| Aliases          | `vi`, `vim`                                 |
| Default editor   | Neovim                                      |
| Provider support | Python 3 and Ruby enabled                   |
| Tooling          | Language servers live in `editor-tool-pkgs` |

## Workflow

Update editor behavior in the Neovim config repo. Update this repo when the
flake input should move to a newer revision or when system language tools need
to change.

## Validate

| Check          | Command               |
| -------------- | --------------------- |
| Binary         | `nvim --version`      |
| Config health  | `nvim '+checkhealth'` |
| Default editor | `echo "$EDITOR"`      |
