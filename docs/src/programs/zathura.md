# Zathura

## What this config does

Zathura uses a dark Catppuccin-like palette, clipboard selection, zero page
padding, custom navigation keys, and the Poppler PDF backend.

## Nix location

- `conf/shared.nix`: installs `zathura` and `zathura_pdf_poppler`
- `conf/shared.nix`: copies `conf/modules/zathura/zathurarc`
- `conf/modules/zathura/zathurarc`: native Zathura config

## Portable setup

Install Zathura and the PDF plugin.

Fedora:

```bash
sudo dnf install zathura zathura-pdf-poppler
```

Ubuntu/Debian:

```bash
sudo apt install zathura zathura-pdf-poppler
```

Create `~/.config/zathura/zathurarc` and copy the settings you want from
`conf/modules/zathura/zathurarc`.

## Mappings

| Key | Action            |
| --- | ----------------- |
| `u` | half page up      |
| `d` | half page down    |
| `J` | full page down    |
| `K` | full page up      |
| `T` | toggle page mode  |
| `r` | reload            |
| `R` | rotate            |
| `A` | zoom in           |
| `D` | zoom out          |
| `i` | recolor           |
| `p` | print             |
| `b` | toggle status bar |

## Useful portable config

```text
set selection-clipboard clipboard
set recolor false
set page-padding 0

map u scroll half-up
map d scroll half-down
map J scroll full-down
map K scroll full-up
map T toggle_page_mode
map r reload
map R rotate
map A zoom in
map D zoom out
map i recolor
map p print
map b toggle_statusbar
```

## Validate

```bash
zathura --version
zathura sample.pdf
```
