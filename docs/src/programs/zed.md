# Zed

## What this config does

Zed uses Vim mode, the Oxocarbon theme, Inter for the UI, 0xProto Nerd Font for
buffers, and format-on-save. Home Manager installs language tools so Zed can
find them when launched from the desktop.

## Nix location

- `conf/shared.nix`: `programs.zed-editor`
- `conf/shared.nix`: `editor-tool-pkgs`

Configured extensions:

- `basher`
- `dart`
- `elixir`
- `flutter-snippets`
- `gleam`
- `lua`
- `nix`
- `oxocarbon`
- `zig`

## Portable setup

Install Zed and install the extensions from Zed's extension UI.

Install the language servers and formatters you need. This repo configures:

```text
bash-language-server
clang-tools
dprint
elixir
elixir-ls
eslint_d
flutter
gleam
go
gopls
gotools
lua
lua-language-server
nil
nixd
nixfmt
nodejs
rust-analyzer
rustfmt
shellcheck
shfmt
stylua
typescript
typescript-language-server
zig
zls
```

On non-Nix systems, GUI apps may not inherit your shell PATH. If Zed cannot find
a language server, launch it from a terminal:

```bash
zeditor .
```

Or set PATH for desktop sessions through your distro's environment mechanism.

## Settings

_todo_

## Verify

```bash
zeditor --version
which nixd
which typescript-language-server
which rust-analyzer
which zls
which zig
```

Open Zed's language server logs if completion or formatting fails.
