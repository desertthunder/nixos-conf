#!/usr/bin/env bash
set -euo pipefail

choice="$(
  printf '%s\n' "Lock" "Logout" "Reboot" "Shutdown" |
    rofi -dmenu -i -p "Power"
)"

case "$choice" in
  Lock)
    hyprlock --immediate-render --no-fade-in
    ;;
  Logout)
    if command -v uwsm >/dev/null 2>&1; then
      uwsm stop
    else
      hyprctl dispatch exit
    fi
    ;;
  Reboot)
    systemctl reboot
    ;;
  Shutdown)
    systemctl poweroff
    ;;
esac
