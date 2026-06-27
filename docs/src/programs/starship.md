# Starship

## What this config does

Starship provides the shell prompt for Zsh. The prompt shows time, Nix icon,
user, host, directory, Git branch and status, command duration, Python context,
and the prompt character.

## Nix location

- `conf/shared.nix`: installs `starship`
- `conf/shared.nix`: runs `eval "$(starship init zsh)"` from zsh init
- `conf/shared.nix`: copies `conf/modules/starship.toml`
- `conf/modules/starship.toml`: native Starship prompt config

Catppuccin integration is enabled globally, but Starship's Catppuccin module is
disabled. The prompt uses the explicit Starship TOML config instead.

## Portable setup

Install Starship:

```bash
curl -sS https://starship.rs/install.sh | sh
```

Add this to `~/.zshrc`:

```zsh
eval "$(starship init zsh)"
```

Copy `conf/modules/starship.toml` to `~/.config/starship.toml` if you want to
port the full prompt.

## Prompt pieces

Configured modules:

- time
- username
- hostname
- directory
- Git branch
- Git state
- Git status
- command duration
- Python
- character

Directory substitutions:

| Directory   | Symbol |
| ----------- | ------ |
| `Documents` | `󰈙`    |
| `Downloads` | ``    |
| `Music`     | ``    |
| `Pictures`  | ``    |

## Validate

```bash
starship --version
starship explain
```

Open a Git repo and run a slow command to check Git status and command duration.
