#!/usr/bin/env bash

mode="${1:---menu}"

binds="$(hyprctl -j binds)"

# shellcheck disable=SC2016 # The jq program must not be expanded by Bash.
formatter='def has($bit): ((.modmask / $bit | floor) % 2) == 1;
def key_name:
  if . == "Return" then "Enter"
  elif . == "SPACE" then "Space"
  elif . == "slash" then "/"
  elif . == "mouse_down" then "Wheel down"
  elif . == "mouse_up" then "Wheel up"
  elif startswith("mouse:") then sub("mouse:272"; "Mouse left") | sub("mouse:273"; "Mouse right")
  else . end;
def binding:
  ([if has(64) then "Super" else empty end,
    if has(4) then "Ctrl" else empty end,
    if has(8) then "Alt" else empty end,
    if has(1) and .key != "slash" then "Shift" else empty end,
    (if has(1) and .key == "slash" then "?" else (.key | key_name) end)] |
    join(" + "));
def action: .description | sub("^\\[common\\] "; "");
map(select(.has_description and .description != "") |
  {key: binding, action: action, common: (.description | startswith("[common] "))})'

case "$mode" in
  --json)
    jq "$formatter" <<<"$binds"
    ;;
  --common-json)
    jq "$formatter | map(select(.common) | {key, action})" <<<"$binds"
    ;;
  --menu)
    jq -r "$formatter | sort_by(.action)[] | [.key, .action] | @tsv" <<<"$binds" |
      column -t -s $'\t' |
      rofi -dmenu -i -no-custom -theme keybinds -p Shortcuts \
        -mesg "Type to search · Esc to close" >/dev/null
    ;;
  *)
    printf 'Usage: hypr-keybinds [--menu|--json|--common-json]\n' >&2
    exit 2
    ;;
esac
