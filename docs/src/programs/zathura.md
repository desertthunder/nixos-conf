# Zathura

Zathura is my PDF reader of choice.

Home Manager installs Zathura, the Poppler backend, and the native `zathurarc`.

## Summary

| Area          | Current shape                                              |
| ------------- | ---------------------------------------------------------- |
| Config source | `conf/modules/zathura/zathurarc`                           |
| Backend       | `zathura_pdf_poppler`                                      |
| Theme         | Dark background, light foreground, blue highlights         |
| Interface     | Status/input bars hidden; page padding and recolor enabled |

## Mappings

| Key       | Action                |
| --------- | --------------------- |
| `u`       | Scroll half page up   |
| `d`       | Scroll half page down |
| `i`       | Recolor               |
| `p`       | Print                 |
| `r`       | Reload                |
| `R`       | Rotate                |
| `K` / `J` | Zoom in / out         |
| `f`       | Toggle fullscreen     |
| `q`       | Quit                  |

## Validate

| Check   | Command             |
| ------- | ------------------- |
| Binary  | `zathura --version` |
| Backend | Open a PDF          |
