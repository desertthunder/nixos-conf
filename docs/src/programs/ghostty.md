# Ghostty

## What this config does

Ghostty uses Zsh as a login shell, JetBrains Mono Nerd Font, zsh shell
integration, and a small dark palette. GNOME shortcuts launch Ghostty and
Ghostty with Zellij.

## Nix location

- `conf/shared.nix`: `programs.ghostty`
- `conf/shared.nix`: GNOME keybindings under `dconf.settings`

## Portable setup

Install Ghostty from your distro or from upstream packages. Install JetBrains
Mono Nerd Font before copying the font setting.

Create or edit `~/.config/ghostty/config`:

```text
font-family = JetBrainsMono Nerd Font Propo
font-style = SemiBold
font-size = 16
window-padding-x = 8
window-padding-y = 8
background = 1b1b1b
foreground = ffffff
cursor-color = 78a9ff
cursor-text = 161616
mouse-hide-while-typing = true
copy-on-select = false
confirm-close-surface = false
shell-integration = zsh
command = zsh --login
```

Add the palette if you want the same colors:

```text
palette = 0=#161616
palette = 1=#ee5396
palette = 2=#42be65
palette = 3=#ff7eb6
palette = 4=#33b1ff
palette = 5=#be95ff
palette = 6=#3ddbd9
palette = 7=#ffffff
palette = 8=#525252
palette = 9=#ee5396
palette = 10=#42be65
palette = 11=#ff7eb6
palette = 12=#33b1ff
palette = 13=#be95ff
palette = 14=#3ddbd9
palette = 15=#ffffff
```

On NixOS the command path is `/run/current-system/sw/bin/zsh --login`. Use
`zsh --login` outside NixOS.

## GNOME shortcuts

```bash
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
  "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty-zellij/']"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty/ name 'Ghostty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty/ command 'ghostty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty/ binding '<Control><Alt>t'

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty-zellij/ name 'Ghostty (zellij)'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty-zellij/ command 'ghostty -e zellij'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty-zellij/ binding '<Super>z'
```

## Validate

```bash
ghostty --version
fc-match 'JetBrainsMono Nerd Font Propo'
zsh --version
```
