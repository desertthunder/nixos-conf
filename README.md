# Desert Thunder's Dotfiles

Personal machine configuration for three paths:

1. Macs without Nix, using Homebrew, portable dotfiles, SOPS/age, and `dotfiler`
2. Ubuntu/Fedora, using distro packages, portable dotfiles, SOPS/age, and `dotfiler`
3. NixOS, using the flake and modules under `lib/nix/`

Documentation content now lives under [`site/content`](./site/content) and is built with the custom Go static site generator in [`app/cmd/site`](./app/cmd/site).

```sh
cd app
go run ./cmd/site preview
```

## Planning

Repo organization and migration tasks are tracked in [todo.md](./todo.md).

## Credits

This site was inspired by isabel's dotfiles [book](https://dotfiles.isabelroses.com/).

![Lucy (Gleam) as Nix Logo](./site/assets/images/gleam-lucy_nix.png)
