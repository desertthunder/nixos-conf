# Other Linux distributions

This config builds a GNOME-based developer workstation on NixOS. You can get
close on Fedora, Ubuntu, Debian, or derivatives by treating the Nix files as an
inventory rather than as something your distro can apply directly.

The target system is:

- GNOME on Wayland with GDM, NetworkManager, PipeWire, printing, and OpenSSH.
- Zsh as the login shell, with Starship, Oh My Zsh, completion, autosuggestions,
  and syntax highlighting.
- Docker, PostgreSQL, and Redis available as local development services.
- Neovim, Zed, Ghostty, Zellij, Zathura, Firefox, Chrome, Spotify, mpv, and rofi.
- A broad CLI/dev-tool set for JS, Rust, Go, Elixir, Gleam, Flutter, Python,
  .NET, Android, Nix, Markdown, Typst, SQLite, and containers.
- Nerd fonts and a few UI fonts installed system-wide or per user.
- SSH keys decrypted from SOPS for GitHub, Codeberg, and Tangled.

## The portable parts

These parts translate cleanly to other distributions:

- `conf/shared.nix` package lists become distro packages, language installers,
  or Nix profile/Home Manager packages.
- `conf/modules/zellij/` can be copied to `~/.config/zellij/`.
- The Neovim config comes from `github:desertthunder/nvim`; clone it into
  `~/.config/nvim`.
- Zathura, Ghostty, Git, Ripgrep, Starship, and Zsh settings can be written as
  normal dotfiles.
- `conf/scripts/keys.sh` can extract SOPS-managed SSH keys for non-NixOS use.

These parts are NixOS-specific and need native distro equivalents:

- `services.*`, `users.users.*`, `fonts.packages`, and `environment.systemPackages`.
- SOPS secrets mounted at `/run/secrets/` by `sops-nix`.
- `nixos-rebuild` aliases.
- `programs.nix-ld`, unless you also install Nix and want similar dynamic linker
  behavior.

## Recommended approach

Use native packages for the desktop and services. Use per-language installers or
Nix for fast-moving developer tools.

1. Install a GNOME edition of your distro.
2. Install the base workstation packages.
3. Enable Docker, PostgreSQL, Redis, SSH, printing, and laptop power services.
4. Install fonts.
5. Copy dotfiles and app configs.
6. Use Nix Home Manager later if you want declarative user packages on top of
   Fedora or Ubuntu.

## Fedora setup

Start from Fedora Workstation. Then install the main packages:

```bash
sudo dnf upgrade --refresh
sudo dnf install \
  git curl wget vim neovim zsh \
  bat fd-find ripgrep fzf jq yq just tree file which \
  fastfetch btop dust gnupg2 direnv starship \
  zellij zathura zathura-pdf-poppler mpv ffmpeg yt-dlp \
  gcc gcc-c++ make pkgconf-pkg-config clang-tools-extra \
  nodejs pnpm golang gopls rust cargo rustfmt clippy \
  python3 python3-pip python3-ipython java-17-openjdk-devel \
  shellcheck ShellCheck shfmt sqlite \
  docker docker-compose postgresql-server postgresql-contrib redis \
  openssh-server cups lm_sensors lsof strace ltrace sysstat \
  pciutils usbutils ethtool iotop iftop \
  gnome-tweaks gnome-extensions-app rofi
```

Some package names vary by Fedora release. If one fails, search it:

```bash
dnf search zellij
dnf search zathura
dnf search language-server
```

Enable services:

```bash
sudo systemctl enable --now sshd
sudo systemctl enable --now cups
sudo systemctl enable --now docker
sudo systemctl enable --now redis
sudo usermod -aG docker "$USER"

sudo postgresql-setup --initdb
sudo systemctl enable --now postgresql
```

Create a local PostgreSQL role and database:

```bash
sudo -iu postgres createuser --createdb --createrole "$USER"
sudo -iu postgres createdb -O "$USER" "$USER"
```

For ThinkPad-like laptop behavior:

```bash
sudo dnf install thermald tlp tlp-rdw fprintd
sudo systemctl enable --now thermald
sudo systemctl disable --now power-profiles-daemon
sudo systemctl enable --now tlp
sudo systemctl enable --now fprintd
```

Fedora may already manage power well with `power-profiles-daemon`. Pick either
that or TLP, not both.

## Ubuntu/Debian setup

Start from Ubuntu Desktop, Debian GNOME, Pop!_OS, Linux Mint, or another
Debian-based GNOME-ish system.

```bash
sudo apt update
sudo apt upgrade
sudo apt install \
  git curl wget vim neovim zsh \
  bat fd-find ripgrep fzf jq just tree file gnupg direnv \
  btop zathura zathura-pdf-poppler mpv ffmpeg yt-dlp \
  build-essential pkg-config clangd clang-tools shellcheck shfmt sqlite3 \
  nodejs npm golang gopls rustc cargo rustfmt \
  python3 python3-pip ipython3 openjdk-17-jdk \
  docker.io docker-compose-v2 postgresql postgresql-contrib redis-server \
  openssh-server cups lm-sensors lsof strace ltrace sysstat \
  pciutils usbutils ethtool iotop iftop \
  gnome-tweaks gnome-shell-extension-manager rofi
```

On Debian and Ubuntu, the `bat` package may install the command as `batcat`.
Create a user-local shim if needed:

```bash
mkdir -p ~/.local/bin
ln -sf /usr/bin/batcat ~/.local/bin/bat
```

On Debian stable or Ubuntu LTS, several development tools will be old. Use the
upstream installer for tools where version matters:

```bash
# Starship
curl -sS https://starship.rs/install.sh | sh

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Bun
curl -fsSL https://bun.sh/install | bash

# uv
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Enable services:

```bash
sudo systemctl enable --now ssh
sudo systemctl enable --now cups
sudo systemctl enable --now docker
sudo systemctl enable --now redis-server
sudo usermod -aG docker "$USER"
```

Create a local PostgreSQL role and database:

```bash
sudo -iu postgres createuser --createdb --createrole "$USER"
sudo -iu postgres createdb -O "$USER" "$USER"
```

For laptop power and fingerprint support:

```bash
sudo apt install thermald tlp fprintd libpam-fprintd
sudo systemctl enable --now thermald
sudo systemctl disable --now power-profiles-daemon 2>/dev/null || true
sudo systemctl enable --now tlp
```

## Shell and prompt

Switch to Zsh:

```bash
chsh -s "$(command -v zsh)"
```

Install Oh My Zsh if your distro package is missing or too old:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Put the important PATH additions from `conf/shared.nix` in `~/.zshrc`:

```zsh
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

eval "$(starship init zsh)"
```

Useful aliases from the NixOS config that still make sense elsewhere:

```zsh
alias ll='ls -l'
alias cat='bat --paging=never --style=plain'
alias less='bat'
alias preview='bat --style=numbers,changes --color=always'
alias zed='zeditor'
alias zedn='zeditor --new'
```

Do not copy the `rebuild`, `switch`, `update`, `nboot`, and `tbuild` aliases.
Those call `nixos-rebuild`.

## App configs

Copy or recreate these files:

```bash
mkdir -p ~/.config
cp -r conf/modules/zellij ~/.config/zellij

git clone https://github.com/desertthunder/nvim ~/.config/nvim
```

Ripgrep config:

```bash
mkdir -p ~/.config/ripgrep
cat > ~/.config/ripgrep/config <<'EOF'
--line-number
--smart-case
--max-columns=120
--max-columns-preview
--type-add=nix:*.nix
--glob=!.git/*
--glob=!**/node_modules/**
--glob=!**/target/**
--glob=!**/.build/**
EOF
```

Zellij config can be checked with:

```bash
ZELLIJ_CONFIG_FILE="$HOME/.config/zellij/config.kdl" \
  ZELLIJ_CONFIG_DIR="$HOME/.config/zellij" \
  zellij setup --check
```

## GNOME settings

The Nix config sets the Kora icon theme and two keyboard shortcuts for Ghostty.
On other distros, install Ghostty from its upstream packages and then run:

```bash
gsettings set org.gnome.desktop.interface icon-theme 'kora'

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
  "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty-zellij/']"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty/ name 'Ghostty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty/ command 'ghostty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty/ binding '<Control><Alt>t'

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty-zellij/ name 'Ghostty (zellij)'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty-zellij/ command 'ghostty -e zellij'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty-zellij/ binding '<Super>z'
```

## Fonts

Install as many of these as your distro packages provide:

- JetBrains Mono Nerd Font
- Commit Mono Nerd Font
- Hack Nerd Font
- Monaspace Nerd Font
- 0xProto Nerd Font
- iA Writer/IM Writing Nerd Font
- Maple Mono NF
- Comic Mono
- Open Sans
- Inter
- Noto Fonts
- Ubuntu Classic
- Fira Mono

On Fedora, many base fonts are available through DNF. Nerd Fonts are often easier
with a user install:

```bash
mkdir -p ~/.local/share/fonts
# Download font zip files from https://www.nerdfonts.com/font-downloads,
# unzip them into ~/.local/share/fonts, then refresh the cache.
fc-cache -fv
```

## Secrets and SSH

NixOS uses `sops-nix` to place SSH keys in `/run/secrets/`. Other distros need a
normal file path under your home directory.

If you have the age key for this repo, put it where `conf/scripts/keys.sh`
expects it and extract the keys:

```bash
mkdir -p ~/.config/sops/age
cp age.txt ~/.config/sops/age/keys.txt
./conf/scripts/keys.sh
```

Then point SSH at the extracted files. A non-NixOS `~/.ssh/config` should look
like this:

```sshconfig
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.local/share/sops/keys_gh
  IdentitiesOnly yes

Host codeberg.org
  HostName codeberg.org
  User git
  IdentityFile ~/.local/share/sops/keys_codeberg
  IdentitiesOnly yes

Host tangled.sh
  HostName tangled.org
  User git
  IdentityFile ~/.local/share/sops/keys_tangled
  IdentitiesOnly yes
```

Set strict permissions:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config ~/.local/share/sops/keys_*
```

## Optional: install Nix on Fedora or Ubuntu

If you want the package set to behave more like this repo, install Nix and use it
for user packages:

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
```

This repository does not currently expose a standalone
`homeConfigurations.<user>` output. To use Home Manager outside NixOS, add one
or create a separate home flake that imports `(import ./conf/shared.nix).home`.
You will still need to replace the NixOS-only secret paths and any Linux desktop
assumptions that do not match your distro.

## Sanity check

After setup, log out and back in so group membership and shell changes apply.
Then check:

```bash
zsh --version
starship --version
nvim --version
zellij --version
docker run hello-world
psql -d "$USER" -c 'select version();'
redis-cli ping
ssh -T git@github.com
```

Expect package substitutions. Aim for the same working setup: GNOME, Zsh,
modern terminals and editors, local services, container tooling, language
servers, and the same dotfiles.
