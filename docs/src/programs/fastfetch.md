# Fastfetch

- `conf/shared.nix`: installs `fastfetch`
- `conf/shared.nix`: copies `conf/modules/fastfetch`
- `conf/modules/fastfetch/config.jsonc`: module layout

## Setup

Install Fastfetch, then copy the config:

```bash
mkdir -p ~/.config
cp -r conf/modules/fastfetch ~/.config/fastfetch
```

Run it:

```bash
fastfetch
```

Validate the repo copy while editing:

```bash
fastfetch --config conf/modules/fastfetch/config.jsonc \
  --pipe true \
  --show-errors true
```

## Notes

- host
- OS
- kernel
- window manager
- terminal
- shell
- CPU
- disk
- memory
- GPU
- swap
- display
- install age
- terminal colors
