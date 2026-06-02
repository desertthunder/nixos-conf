# Development

This repository is a NixOS flake. Most changes are edits to `conf/shared.nix`, a
machine file under `conf/machines/`, or documentation under `docs/src/`.

Common checks:

```bash
nixfmt conf/shared.nix
nix flake show --no-write-lock-file
sudo nixos-rebuild build --flake .#$(hostname)
```

Use `test` before switching when a change could affect services, desktop
startup, login shells, or Home Manager activation:

```bash
sudo nixos-rebuild test --flake .#$(hostname)
```

The zsh aliases in `conf/shared.nix` wrap the common rebuild commands:

```bash
rebuild  # switch
switch   # switch
nboot    # boot
tbuild   # test
```

Docs are an mdBook in `docs/`. Edit source files in `docs/src/`; `docs/book/` is
generated output.

```bash
cd docs
mdbook serve
```

## Dev environments

Some application projects need native Linux libraries that should not live in
this machine's global profile. Tauri is the main example: Rust crates such as
`glib-sys`, `gtk-sys`, `gdk-sys`, and `webkit2gtk-sys` discover system libraries
through `pkg-config`. On NixOS those `.pc` files are not globally visible unless
a shell or package build exposes them.

For those cases, keep the dependency set in the application project as a
`shell.nix`. This keeps the global system configuration small and makes the app
build environment explicit.

### Tauri

`dev/tauri.nix` contains a dev shell for the Tauri apps.

The shell provides:

- Rust tooling: `cargo`, `rustc`, `clippy`, `rustfmt`, `rust-analyzer`
- frontend tooling: `nodejs_24`, `pnpm`
- build discovery: `pkg-config`
- Tauri Linux libraries: GTK, GLib, WebKitGTK, libsoup, appindicator, and friends
- SQLite headers and library for `libsqlite3-sys`

If a Tauri build reports a missing package such as `glib-2.0`, `gdk-3.0`, or
`sqlite3`, add the Nix package to the app's `shell.nix`. Do not add these Tauri
libraries to `conf/shared.nix` unless they are actually useful system-wide.
