# Zsh

## What this config does

NixOS sets Zsh as the login shell for user `owais`. Home Manager enables
completion, autosuggestions, syntax highlighting, Oh My Zsh, and Starship.

## Nix location

- `conf/shared.nix`: `programs.zsh.enable` for NixOS
- `conf/shared.nix`: `users.users.owais.shell`
- `conf/shared.nix`: Home Manager `programs.zsh`

Oh My Zsh plugins:

- `git`
- `z`

## Portable setup

Install Zsh and make it your login shell:

```bash
chsh -s "$(command -v zsh)"
```

Install Oh My Zsh if your distro does not package it:

```bash
sh -c "$(
  curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
)"
```

Add PATH entries to `~/.zshrc`:

```zsh
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
```

Initialize Starship:

```zsh
eval "$(starship init zsh)"
```

## Aliases worth copying

```zsh
alias ll='ls -l'
alias cat='bat --paging=never --style=plain'
alias less='bat'
alias preview='bat --style=numbers,changes --color=always'
alias zed='zeditor'
alias zedn='zeditor --new'
```

Do not copy these outside NixOS:

```zsh
export NIXOS_CONFIG=${NIXOS_CONFIG:-$HOME/Projects/nixos-conf}
alias rebuild='sudo nixos-rebuild switch --flake "$NIXOS_CONFIG#$(hostname)"'
alias switch='sudo nixos-rebuild switch --flake "$NIXOS_CONFIG#$(hostname)"'
alias update='nix flake update --flake "$NIXOS_CONFIG" && \
  sudo nixos-rebuild switch --flake "$NIXOS_CONFIG#$(hostname)"'
alias nboot='sudo nixos-rebuild boot --flake "$NIXOS_CONFIG#$(hostname)"'
alias tbuild='sudo nixos-rebuild test --flake "$NIXOS_CONFIG#$(hostname)"'
```

## Validate

```bash
zsh --version
echo "$SHELL"
starship --version
```

Log out and back in after changing the login shell.
