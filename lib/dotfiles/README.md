# Portable Dotfiles

Canonical dotfiles for non-Nix machines and Home Manager.

Install on non-Nix machines with:

```sh
scripts/bootstrap/link-dotfiles.sh
```

Managed paths:

| Source | Target |
| ------ | ------ |
| `lib/dotfiles/zsh/.zshrc` | `~/.zshrc` |
| `lib/dotfiles/git/.gitconfig` | `~/.gitconfig` |
| `lib/dotfiles/ghostty/.config/ghostty/config` | `~/.config/ghostty/config` |
| `lib/dotfiles/ripgrep/.config/ripgrep/config` | `~/.config/ripgrep/config` |
| `lib/dotfiles/zellij/.config/zellij` | `~/.config/zellij` |
| `lib/dotfiles/oh-my-posh/.config/oh-my-posh/theme.json` | `~/.config/oh-my-posh/theme.json` |

Notes:

- VSCode profiles are not currently exported into this repo.
- Zathura is configured through Home Manager on Linux only; macOS support is not currently managed.
- Desired font additions to review later: Averia Libre, Newsreader, Noto Sans, Nunito Sans.
