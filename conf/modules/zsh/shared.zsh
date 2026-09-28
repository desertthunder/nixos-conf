# Shared zsh setup. Home Manager's generated .zshrc sources this on NixOS, and
# conf/modules/zsh/zshrc sources it everywhere else. Machine-only settings and
# secrets go in ~/.config/zsh/local.zsh, which is sourced last and never
# committed.

typeset -U path
path=("$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/go/bin" $path)

export EDITOR=nvim
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"

alias ll='ls -l'
alias cat='bat --paging=never --style=plain'
alias less='bat'
alias preview='bat --style=numbers,changes --color=always'

(( $+commands[starship] )) && eval "$(starship init zsh)"

[[ -r "$HOME/.config/zsh/local.zsh" ]] && source "$HOME/.config/zsh/local.zsh"
