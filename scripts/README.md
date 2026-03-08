# Scripts

Interactive shell scripts for system management. All scripts use [gum](https://github.com/charmbracelet/gum) for styled TUI prompts and output.

For tool reference guides (gum, dust, ripgrep), see [tools.md](tools.md).

## Dependencies

All scripts expect these tools to be available (installed via `shared/home.nix`):

- **gum** — TUI components for shell scripts (prompts, spinners, styled output)
- **dust** — Disk usage analyzer with ASCII tree visualization
- **rg** (ripgrep) — Fast recursive file/content search

## analyze-disk.sh

Interactive disk storage report. Helps identify what's consuming space so you can make informed cleanup decisions. **Read-only** — no files are modified or deleted.

### Usage

```sh
./analyze-disk.sh [-h] [-d DIR] [-m MODE]
```

### Options

| Flag      | Description                                            |
| --------- | ------------------------------------------------------ |
| `-h`      | Show help (styled when run in a TTY, plain otherwise)  |
| `-d DIR`  | Target directory (skips interactive prompt)            |
| `-m MODE` | Analysis mode: `overview`, `large`, `search`, or `all` |

### Modes

**overview** — Shows the top space consumers as a `dust` tree. Optionally filters to directories only.

**large** — Finds files above a chosen size threshold (1M to 1G). Also scans for common large file types: logs, archives, disk images, videos, and caches (node_modules, .cache, \_\_pycache\_\_).

**search** — Two sub-modes:

- _Filename pattern_ — finds files by name regex, shows each with its size
- _File content_ — uses ripgrep to find files containing a pattern, shows size and match count

**all** — Runs overview, large, and search sequentially.

### Examples

```bash
# Fully interactive — prompts for directory and mode
./analyze-disk.sh

# Analyze ~/Projects, skip directory prompt
./analyze-disk.sh -d ~/Projects

# Jump straight to overview mode
./analyze-disk.sh -m overview

# Non-interactive: find large files on the entire disk
./analyze-disk.sh -d / -m large
```
