#!/usr/bin/env bash
set -euo pipefail

mode="${1:-region}"
edit="${2:-edit}"
dir="${XDG_SCREENSHOTS_DIR:-$HOME/Pictures/Screenshots}"
mkdir -p "$dir"

raw="$(mktemp --tmpdir hypr-shot-XXXXXX.png)"
output="$dir/shot-$(date +%Y%m%d-%H%M%S).png"

cleanup() {
	rm -f "$raw"
}
trap cleanup EXIT

notify() {
	local urgency="$1"
	local summary="$2"
	local body="${3:-}"

	notify-send -a "Screenshot" -u "$urgency" "$summary" "$body"
}

case "$mode" in
region)
	if ! geometry="$(slurp)"; then
		exit 0
	fi

	grim -g "$geometry" "$raw"
	;;
full)
	grim "$raw"
	;;
*)
	notify critical "Screenshot failed" "Unknown mode: $mode"
	exit 2
	;;
esac

if [[ "$edit" == "no-edit" ]]; then
	cp "$raw" "$output"
	wl-copy --type image/png <"$output"
	notify low "Screenshot saved" "$output"
	exit 0
fi

if [[ "$edit" != "edit" ]]; then
	notify critical "Screenshot failed" "Unknown edit mode: $edit"
	exit 2
fi

if ! satty \
	--filename "$raw" \
	--output-filename "$output" \
	--copy-command wl-copy \
	--disable-notifications \
	--actions-on-enter save-to-file \
	--actions-on-enter save-to-clipboard \
	--actions-on-enter exit \
	--actions-on-right-click save-to-file \
	--actions-on-right-click save-to-clipboard \
	--actions-on-right-click exit \
	--actions-on-escape exit; then
	notify critical "Screenshot failed" "Satty exited with an error."
	exit 1
fi

if [[ -f "$output" ]]; then
	notify low "Screenshot saved" "$output"
fi
