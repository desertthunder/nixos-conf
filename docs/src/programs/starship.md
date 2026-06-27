# Starship

Starship is the shell prompt. Home Manager installs the binary, copies the
native TOML config, and Zsh initializes it.

## Summary

| Area              | Current shape                 |
| ----------------- | ----------------------------- |
| Config source     | `conf/modules/starship.toml`  |
| Installed config  | `~/.config/starship.toml`     |
| Shell integration | `eval "$(starship init zsh)"` |

## Prompt Shape

The config keeps the prompt compact and development-focused. It emphasizes
directory, Git state, language/runtime context, command duration, jobs, status,
and shell character.

For portable use, install Starship and copy the TOML config. The only shell
requirement is that Zsh initializes Starship.

## Validate

| Check         | Command              |
| ------------- | -------------------- |
| Binary        | `starship --version` |
| Render config | `starship explain`   |

<!-- TODO: link to starship docs -->
<!-- TODO: table of nerd font symbols -->
