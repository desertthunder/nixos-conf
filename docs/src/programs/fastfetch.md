# Fastfetch

[Fastfetch](https://github.com/fastfetch-cli/fastfetch) is installed by Home Manager and
configured from `conf/modules/fastfetch` as a quick host, desktop, shell, package, and
hardware overview.

## Summary

| Area             | Current shape            |
| ---------------- | ------------------------ |
| Config source    | `conf/modules/fastfetch` |
| Installed config | `~/.config/fastfetch`    |

The config is app-native JSONC.

## Validate

| Check          | Command                                                  |
| -------------- | -------------------------------------------------------- |
| Default config | `fastfetch`                                              |
| Repo config    | `fastfetch --config conf/modules/fastfetch/config.jsonc` |
