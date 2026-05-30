path_prepend() {
  [[ -d "$1" ]] || return 0
  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$1:$PATH" ;;
  esac
}

path_append() {
  [[ -d "$1" ]] || return 0
  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$PATH:$1" ;;
  esac
}

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.npm-global/bin"
path_prepend "$HOME/.cargo/bin"
path_prepend "$HOME/go/bin"

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

export npm_config_prefix="$HOME/.npm-global"

if [[ "$(uname -s)" == "Darwin" ]]; then
  if command -v xcrun >/dev/null 2>&1; then
    export CGO_LDFLAGS="-L$(xcrun --show-sdk-path)/usr/lib"
  fi
  export LIBRARY_PATH="/usr/lib"

  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export ANDROID_SDK_ROOT="$ANDROID_HOME"
  path_prepend "$ANDROID_HOME/cmdline-tools/latest/bin"
  path_prepend "$ANDROID_HOME/platform-tools"

  path_prepend "$HOME/Library/pnpm"
  path_prepend "$HOME/SDKs/flutter/bin"
  path_prepend "$HOME/SDKs/flutter/bin/cache/dart-sdk/bin"
  path_append "$HOME/.pub-cache/bin"

  export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
  path_prepend "$JAVA_HOME/bin"
fi

[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

if [[ -d "$HOME/.oh-my-zsh" ]]; then
  export ZSH="$HOME/.oh-my-zsh"

  if command -v brew >/dev/null 2>&1; then
    brew_prefix="$(brew --prefix)"
    [[ -f "$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    [[ -f "$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  fi

  plugins=(git z)
  source "$ZSH/oh-my-zsh.sh"
fi

if command -v oh-my-posh >/dev/null 2>&1; then
  if [[ -f "$HOME/.config/oh-my-posh/theme.json" ]]; then
    eval "$(oh-my-posh init zsh --config "$HOME/.config/oh-my-posh/theme.json")"
  else
    eval "$(oh-my-posh init zsh)"
  fi
fi

autoload -Uz compinit && compinit

alias ll="ls -l"
if [[ -e /etc/NIXOS ]]; then
  alias update="sudo nixos-rebuild switch"
fi
