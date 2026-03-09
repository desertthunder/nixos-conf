<!-- markdownlint-disable MD033 -->
# Scripts

Interactive shell scripts for system management. All scripts use [gum](https://github.com/charmbracelet/gum) for styled TUI prompts and output.

For tool reference guides (gum, dust, ripgrep), see [tools.md](tools.md).

## Dependencies

All scripts expect these tools to be available (installed via `shared/home.nix`):

- **gum** — TUI components for shell scripts (prompts, spinners, styled output)
- **dust** — Disk usage analyzer with ASCII tree visualization
- **rg** (ripgrep) — Fast recursive file/content search

<details>
<summary>
analyze-disk.sh
</summary>

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

</details>

<details>
<summary>
analyze-project.sh
</summary>

Gitignore-aware source code analyzer. Counts lines of code, words, and files by type. Can also flag files that may need splitting. **Gum is optional** — works in non-TTY / plain environments too.

### Usage

```sh
./analyze-project.sh [-h] [-d DIR] [-m MODE] [-t LINES]
```

### Options

| Flag       | Description                                                    |
| ---------- | -------------------------------------------------------------- |
| `-h`       | Show help (styled when run in a TTY with gum, plain otherwise) |
| `-d DIR`   | Target directory (skips interactive prompt)                    |
| `-m MODE`  | Analysis mode: `loc`, `words`, `files`, `big`, or `all`        |
| `-t LINES` | Line threshold for big-file detection (default: 1000)          |

### Modes

**loc** — Lines of code grouped by file extension, sorted by total lines descending.

**words** — Word count grouped by file extension.

**files** — File count grouped by file extension.

**big** — Lists all files exceeding the line threshold (`-t`), sorted largest first. Useful for finding files that may benefit from being split up.

**all** — Runs loc, words, files, and big sequentially.

### Examples

```bash
# Fully interactive — prompts for directory and mode
./analyze-project.sh

# Analyze a specific project
./analyze-project.sh -d ~/Projects/myapp

# Non-interactive LoC count
./analyze-project.sh -d . -m loc

# Find files over 500 lines
./analyze-project.sh -d . -m big -t 500
```

</details>
