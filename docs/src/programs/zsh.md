# Zsh

Zsh has been my go-to shell for the past decade.

Home Manager adds completion, autosuggestions, syntax highlighting, Oh My Zsh,
Starship initialization, and a small alias set.

## Summary

| Area              | Current shape                                         |
| ----------------- | ----------------------------------------------------- |
| Login shell       | `pkgs.zsh` from NixOS user config                     |
| Oh My Zsh plugins | `git`, `z`                                            |
| Prompt            | Starship initialized from zsh init                    |
| PATH additions    | `~/.local/bin`, `~/.cargo/bin`, `~/go/bin`            |
| NixOS config path | `NIXOS_CONFIG`, defaulting to `~/Projects/nixos-conf` |

## Aliases

| Alias                                            | Purpose                                |
| ------------------------------------------------ | -------------------------------------- |
| `ll`                                             | Long `ls`.                             |
| `cat`                                            | `bat` without paging or decorations.   |
| `less`                                           | `bat` pager.                           |
| `preview`                                        | `bat` with numbers and change markers. |
| `zed`, `zedn`                                    | Zed shortcuts.                         |
| `rebuild`, `switch`, `update`, `nboot`, `tbuild` | NixOS rebuild helpers.                 |
