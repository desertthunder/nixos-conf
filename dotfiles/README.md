# Portable Dotfiles

Canonical dotfiles for non-Nix machines and Home Manager.

Install on non-Nix machines with:

```sh
scripts/bootstrap/link-dotfiles.sh
```

Managed paths:

| Source | Target |
| ------ | ------ |
| `dotfiles/zsh/.zshrc` | `~/.zshrc` |
| `dotfiles/git/.gitconfig` | `~/.gitconfig` |
| `dotfiles/ghostty/.config/ghostty/config` | `~/.config/ghostty/config` |
| `dotfiles/ripgrep/.config/ripgrep/config` | `~/.config/ripgrep/config` |
| `dotfiles/zellij/.config/zellij` | `~/.config/zellij` |
| `dotfiles/oh-my-posh/.config/oh-my-posh/theme.json` | `~/.config/oh-my-posh/theme.json` |

Notes:

- VSCode profiles are not currently exported into this repo.
- Zathura is configured through Home Manager on Linux only; macOS support is not currently managed.
- Desired font additions to review later: Averia Libre, Newsreader, Noto Sans, Nunito Sans.
