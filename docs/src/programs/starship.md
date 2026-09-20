# Starship

Starship is the shell prompt. Home Manager installs the binary, copies the
native TOML config, and Zsh initializes it.

## Summary

| Area              | Current shape                 |
| ----------------- | ----------------------------- |
| Config source     | `conf/modules/starship.toml`  |
| Installed config  | `~/.config/starship.toml`     |
| Shell integration | `eval "$(starship init zsh)"` |

## Prompt shape

The prompt shows the directory, Git state, language and runtime context,
command duration, background jobs, exit status, and the shell character.

For portable use, install Starship and copy the TOML config. The only shell
requirement is that Zsh initializes Starship.

## Validate

| Check         | Command              |
| ------------- | -------------------- |
| Binary        | `starship --version` |
| Render config | `starship explain`   |

<!-- TODO: link to starship docs -->
<!-- TODO: table of nerd font symbols -->
