# Starship

## What this config does

Starship provides the shell prompt for Zsh. The prompt shows time, Nix icon,
user, host, directory, Git branch and status, command duration, Python context,
and the prompt character.

## Nix location

- `conf/shared.nix`: `programs.starship`
- `conf/shared.nix`: `programs.zsh.enableZshIntegration`

Catppuccin integration is enabled globally, but Starship's Catppuccin module is
disabled. The prompt uses explicit Starship settings instead.

## Portable setup

Install Starship:

```bash
curl -sS https://starship.rs/install.sh | sh
```

Add this to `~/.zshrc`:

```zsh
eval "$(starship init zsh)"
```

Create `~/.config/starship.toml` if you want to port the full prompt. Translate
the settings from `conf/shared.nix` under `programs.starship.settings`.

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

| Directory | Symbol |
| --- | --- |
| `Documents` | `󰈙` |
| `Downloads` | `` |
| `Music` | `` |
| `Pictures` | `` |

## Check it

```bash
starship --version
starship explain
```

Open a Git repo and run a slow command to check Git status and command duration.
