#!/bin/sh
# Records the non-Nix workflow demos into docs/src/assets/demos.
#
# VHS tapes record GIFs. Freeze renders stills of config files and command
# output. Freeze has a fixed ANSI palette, so its SVGs are recoloured to the
# Ghostty Oxocarbon palette and converted to PNG with rsvg-convert.
#
# Commands that change files run in a throwaway home directory, so recording
# never touches the real one.
#
# Usage: docs/demos/record.sh [tape...]   (default: every tape)

set -eu

repo=$(CDPATH='' cd -- "$(dirname -- "$0")/../.." && pwd)
demos="$repo/docs/demos"
out="$repo/docs/src/assets/demos"

for tool in vhs freeze rsvg-convert bat dots; do
  command -v "$tool" >/dev/null 2>&1 || {
    echo "record.sh: $tool is missing; run dots doctor --install" >&2
    exit 1
  }
done

DEMO_HOME=$(mktemp -d "${TMPDIR:-/tmp}/dots-demo.XXXXXX")
export DEMO_HOME
trap 'rm -rf "$DEMO_HOME"' EXIT

# A home with a hand-written zshrc and gitconfig for dots to back up, and an
# existing Neovim checkout so the demo does not clone over the network.
printf '# zshrc from before the dotfiles\n' >"$DEMO_HOME/.zshrc"
printf '[user]\n\tname = Demo\n' >"$DEMO_HOME/.gitconfig"
mkdir -p "$DEMO_HOME/.config/nvim"
git -C "$DEMO_HOME/.config/nvim" init --quiet
git -C "$DEMO_HOME/.config/nvim" remote add origin git@github.com:desertthunder/nvim.git

cd "$repo"
mkdir -p "$out"

if [ $# -eq 0 ]; then
  set -- "$demos"/*.tape
fi
for tape in "$@"; do
  [ "$(basename "$tape")" = settings.tape ] && continue
  echo "recording $tape"
  vhs "$tape"
done

# Maps Freeze's default text colour and ANSI colours (ansiPalette and the first
# 16 entries of palette in freeze's ansi.go) to the Ghostty palette in
# conf/modules/ghostty/config. It also quotes the font family, because a CSS
# family name that starts with a digit is invalid without quotes.
recolor() {
  sed -e "s/font-family=\"\([^\"]*\)\"/font-family=\"'\1', monospace\"/g" \
    -e 's/#c4c4c4/#ffffff/g; s/#282a2e/#161616/g; s/#D74E6F/#ee5396/g; s/#31BB71/#42be65/g; s/#D3E561/#ff7eb6/g' \
    -e 's/#8056FF/#33b1ff/g; s/#ED61D7/#be95ff/g; s/#04D7D7/#3ddbd9/g; s/#C5C8C6/#ffffff/g' \
    -e 's/#4B4B4B/#8d8d8d/g; s/#FE5F86/#ee5396/g; s/#00D787/#42be65/g; s/#EBFF71/#ff7eb6/g' \
    -e 's/#8F69FF/#33b1ff/g; s/#FF7AEA/#be95ff/g; s/#00FEFE/#3ddbd9/g' \
    -e 's/"#000000"/"#161616"/g; s/"#800000"/"#ee5396"/g; s/"#008000"/"#42be65"/g; s/"#808000"/"#ff7eb6"/g' \
    -e 's/"#000080"/"#33b1ff"/g; s/"#800080"/"#be95ff"/g; s/"#008080"/"#3ddbd9"/g; s/"#c0c0c0"/"#ffffff"/g' \
    -e 's/"#808080"/"#8d8d8d"/g; s/"#ff0000"/"#ee5396"/g; s/"#00ff00"/"#42be65"/g; s/"#ffff00"/"#ff7eb6"/g' \
    -e 's/"#0000ff"/"#33b1ff"/g; s/"#ff00ff"/"#be95ff"/g; s/"#00ffff"/"#3ddbd9"/g'
}

# still NAME COMMAND renders COMMAND's output to $out/NAME.png.
still() {
  svg="$DEMO_HOME/$1.svg"
  COLUMNS=96 freeze --config "$demos/freeze.json" --execute "$2" --output "$svg" </dev/null >/dev/null
  recolor <"$svg" >"$svg.tmp"
  rsvg-convert --zoom 2 "$svg.tmp" --output "$out/$1.png"
  echo "rendered $out/$1.png"
}

show() {
  echo "bat --paging=never --color=always --style=plain --theme=ansi $*"
}

still mise-config "$(show conf/modules/mise/config.toml)"
still brewfile-demo-tools "$(show --line-range "$(grep -n '^# Demo recording' conf/packages/Brewfile | cut -d: -f1):+4" conf/packages/Brewfile)"
still dots-mcp-entry "$(show --line-range "$(grep -n '^# mise exec finds' conf/dots.toml | cut -d: -f1):" conf/dots.toml)"

# The last still shows a fully linked home, so switch to the throwaway one.
export HOME="$DEMO_HOME"
dots link --apply >/dev/null
still dots-status "dots status"
