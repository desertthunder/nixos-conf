# Shell Scripts (with Gum)

Interactive shell scripts using [gum](https://github.com/charmbracelet/gum), [dust](https://github.com/bootandy/dust), and [ripgrep](https://github.com/BurntSushi/ripgrep).

## Scripts

| Script               | Description                                                  |
| -------------------- | ------------------------------------------------------------ |
| `analyze-disk.sh`    | Interactive disk storage report using dust, ripgrep, and gum |
| `analyze-project.sh` | Gitignore-aware source code analyzer (LoC, words, big files) |

## Gum Quick Reference

Gum provides composable TUI components for shell scripts. Each subcommand does one thing, writes to stdout, and exits with a meaningful exit code.

### Input & Text

```bash
# Single-line input
NAME=$(gum input --placeholder "Your name" --header "Who are you?")

# Password (masked)
SECRET=$(gum input --password --placeholder "Token")

# Multi-line editor
BODY=$(gum write --placeholder "Describe changes..." --width 80 --height 6)
```

### Selection

```bash
# Single choice
ENV=$(gum choose "dev" "staging" "prod" --header "Deploy to:")

# Multi-select (space to toggle, enter to confirm)
PKGS=$(gum choose --no-limit "git" "curl" "jq" "fzf" "ripgrep")

# Fuzzy filter (for long/dynamic lists)
FILE=$(find . -name "*.nix" | gum filter --placeholder "Search nix files...")

# File picker
FILE=$(gum file /etc/nixos)
```

### Confirmation

```bash
gum confirm "Delete this branch?" && git branch -d feature-x

# Custom labels
gum confirm --affirmative "Yes, deploy" --negative "Cancel" "Push to prod?"
```

### Spinner

```bash
gum spin --spinner dot --title "Building..." -- nix build
gum spin --spinner globe --title "Fetching..." --show-output -- curl -s "$URL"
# Styles: dot, line, minidot, jump, pulse, points, globe, moon, monkey, meter
```

### Styling & Output

```bash
# Styled text
gum style --foreground 212 --bold "Done!"

# Bordered box
gum style --border double --border-foreground 99 --padding "1 3" "Build OK"

# Horizontal join
LABEL=$(gum style --border rounded --padding "0 1" "INFO")
MSG=$(gum style --padding "0 1" "Rebuild complete")
gum join "$LABEL" "$MSG"
```

### Table

```bash
# Pipe CSV (first row = headers)
echo "Name,Size,Modified
foo.nix,4K,Mar 1
bar.nix,12K,Feb 28" | gum table

# Custom separator
printf "Name\tSize\n" && dust -b -c -n 5 . | gum table --separator $'\t'
```

### Logging

```bash
gum log --level info  "Server started"
gum log --level warn  "Config missing, using defaults"
gum log --level error "Connection failed" host db.local port 5432
# Structured fields are key=value pairs after the message
```

### Format & Pager

```bash
# Render markdown
echo "# Title\n- item one\n- item two" | gum format

# Syntax-highlighted code
gum format --type code --language bash 'echo "hello"'

# Scrollable pager
cat long-file.txt | gum pager --show-line-numbers
```

### Environment Variables

Every flag has a `GUM_*` env var equivalent for setting defaults:

```bash
export GUM_INPUT_PLACEHOLDER="Type here..."
export GUM_SPIN_SPINNER="dot"
export GUM_CHOOSE_CURSOR_PREFIX="→ "
```

## Dust Quick Reference

[dust](https://github.com/bootandy/dust) is a modern `du` replacement that shows disk usage as an ASCII tree with proportional bars.

### Basic Usage

```bash
dust                  # Current directory, auto-sized output
dust /path/to/dir     # Specific directory
dust -n 20 ~          # Show top 20 entries
dust -d 2 /           # Max depth of 2
dust -r ~/Projects    # Reverse (biggest at top)
dust -s .             # Apparent size (file length, not blocks)
```

### Filtering

```bash
dust -z 100M /        # Only entries >= 100MB
dust -D .             # Directories only
dust -F .             # Files only
dust -i .             # Ignore hidden files
dust -X node_modules  # Exclude a path
dust -e '\.log$' .    # Only paths matching regex
dust -v '\.git' .     # Exclude paths matching regex
```

### Machine-Readable Output

```bash
# JSON (pipe to jq)
dust -j /tmp | jq '.children[] | {name, size}'

# Screen-reader mode (tabular, no bars)
dust -R -n 20 .
# Columns: name  depth  size  percentage

# No bars, no colors (easy awk parsing)
dust -b -c -n 10 .
```

### Key Flags

| Flag        | Description                    |
| ----------- | ------------------------------ |
| `-n NUM`    | Number of lines to show        |
| `-d DEPTH`  | Max recursion depth            |
| `-r`        | Reverse order (biggest at top) |
| `-s`        | Apparent size (not blocks)     |
| `-b`        | No percent bars                |
| `-c`        | No colors                      |
| `-j`        | JSON output                    |
| `-R`        | Screen-reader mode (tabular)   |
| `-D` / `-F` | Directories only / Files only  |
| `-z SIZE`   | Min size filter (e.g. `10M`)   |
| `-x`        | Stay on one filesystem         |
| `-p`        | Show full paths                |

---

## Ripgrep Quick Reference

[ripgrep](https://github.com/BurntSushi/ripgrep) (`rg`) is an extremely fast recursive search tool. It respects `.gitignore` by default.

### Basic Usage

```bash
rg "pattern" .              # Search current dir recursively
rg "TODO" --type nix        # Search only .nix files
rg "fn main" -g "*.rs"     # Glob filter
rg -i "error" /var/log      # Case-insensitive
rg -w "config"              # Whole word match
```

### Output Control

```bash
rg -l "import"              # List matching files only
rg -c "TODO"                # Count matches per file
rg --json "pattern"         # JSON output (for scripting)
rg -A 3 -B 1 "fn main"     # Context lines (after/before)
rg -n "error"               # Show line numbers (default)
```

### Filtering

```bash
rg --type-list              # Show all known file types
rg -t py "import"           # Search only Python files
rg -T js "require"          # Exclude JavaScript files
rg -g '!*.min.js' "func"   # Exclude by glob
rg --hidden "secret"        # Include hidden files
rg -u "pattern"             # Unrestricted (ignore .gitignore)
rg --no-ignore "pattern"    # Don't respect ignore files
```

### Useful Flags

| Flag            | Description                   |
| --------------- | ----------------------------- |
| `-l`            | Files with matches only       |
| `-c`            | Match count per file          |
| `-i`            | Case-insensitive              |
| `-w`            | Whole word                    |
| `-F`            | Fixed string (no regex)       |
| `-g GLOB`       | Include/exclude by glob       |
| `-t TYPE`       | Filter by file type           |
| `--hidden`      | Include hidden files          |
| `-A N` / `-B N` | Lines after/before match      |
| `--json`        | Structured JSON output        |
| `-r REPLACE`    | Replace matches (stdout only) |
| `--stats`       | Show match statistics         |

### Combining with Other Tools

```bash
# Find large log files then search them
rg -l "ERROR" /var/log | xargs dust -n 10

# Search and display with gum pager
rg --color always "TODO" . | gum pager

# Interactive file selection from search results
FILE=$(rg -l "pattern" | gum filter --placeholder "Pick file...")
```
