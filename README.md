# Desert Thunder's Dotfiles

This book is a collection of notes and guides around my personal dotfiles. It's
a bit all over the place because as of writing (November 16, 2025), I've only
been using NixOS as one of my daily drivers for a day.

These reflect my habits and quirks as a developer. My `*.nix` files will likely
not be modular until I hit the 1000 line threshold. The neovim configuration is
a vestige of a time before I embraced the long file.

If you want to take a look at my specific configurations and settings, take a>
look at [the repo](https://github.com/desertthunder/nixos-conf) that houses
these notes. If you have any requests or suggestions, feel free to open an
issue. I haven't decided on a license but regardless of what I pick, I hope that
this ends up being a valuable resource to anyone that gives it the time.
Programming and engineering are fun, and I've always liked messing with my setup
and I hope you have fun too.

For system administration and multi-machine setup details, see the
[NixOS](./docs/src/nixos.md) and [Guides](./docs/src/guides.md) docs.

## Credits

This site was inspired by isabel's dotfiles
[book](https://dotfiles.isabelroses.com/)

![Lucy (Gleam) as Nix Logo](./docs/src/images/gleam-lucy_nix.png)

## TODO

- [ ] Dragon-type naming convention for machines

---

## Migration Guides

For detailed migration procedures and inventory management, see the [Migration
Guide](./docs/src/guides.md).

## Inventory

Date: 2025-12-08

Nix for system packages, development tools, and user applications.

| Machine | Nix                       |
| ------- | ------------------------- |
| All     | Caddy                     |
| All     | Nginx                     |
| All     | Gleam                     |
| All     | Typst                     |
| All     | Zathura (& zathura-mupdf) |
| All     | MuPdf                     |
| All     | yt-dlp                    |
| All     | slides                    |
| Mini    | supercollider             |
