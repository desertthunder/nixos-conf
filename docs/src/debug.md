# Debugging System Services

This is a quick checklist for debugging services.

## Systemd Units

List failed system services:

```sh
systemctl --failed
```

List failed user services:

```sh
systemctl --user --failed
```

Inspect one unit and its recent logs:

```sh
systemctl status waybar.service
systemctl --user status hypridle.service
```

Use `status` for a human-readable snapshot. It includes runtime state and recent
journal lines, while `show` is better for scripts.[^systemctl-status]

## Journal Logs

`journalctl` reads systemd's structured journal and supports filters such as the
current boot, system or user journal, unit names, and grep-style message
matches.[^journalctl]

Read the current boot only:

```sh
journalctl -b --no-pager
journalctl --user -b --no-pager
```

Filter to a unit:

```sh
journalctl -b -u display-manager.service --no-pager
journalctl --user -b --user-unit waybar.service --no-pager
```

Search messages for a word or regex:

```sh
journalctl -b -g 'hyprlock|loginctl|pam' --no-pager
```

## Crashes

`coredumpctl debug` opens the matching core in a debugger, and `info PID` prints
metadata plus stack trace details when they are available.[^coredumpctl]

List and inspect coredumps:

```sh
coredumpctl list
coredumpctl info PID
coredumpctl debug PID
```

[^systemctl-status]: <https://man7.org/linux/man-pages/man1/systemctl.1.html>

[^journalctl]: <https://man7.org/linux/man-pages/man1/journalctl.1.html>

[^coredumpctl]: <https://man7.org/linux/man-pages/man1/coredumpctl.1.html>
