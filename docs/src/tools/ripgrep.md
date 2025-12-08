# Ripgrep

Notes on a grep replacement built in Rust (`rg`).

## Basic Usage

### Simple Search

```bash
rg "pattern"                     # Search in current directory recursively
rg "pattern" file.txt           # Search in specific file
rg "pattern" src/               # Search in specific directory
```

### Case Sensitivity

```bash
rg -i "pattern"                 # Case-insensitive search
rg --smart-case "Pattern"       # Smart case (case-sensitive if uppercase present)
rg "PATTERN"                    # Exact case match
```

### Common Patterns

```bash
rg "function\s+\w+"             # Find function definitions
rg "TODO|FIXME|HACK"            # Find code comments
rg "import\s+.*from"            # Find import statements
rg "\b\w+Error\b"               # Find error classes/variables
```

## File Filtering

### By File Type

```bash
# Search only specific file types
rg "pattern" -t rust            # Only Rust files
rg "pattern" -t js -t ts        # JavaScript and TypeScript files
rg "pattern" -t py              # Python files

# Exclude file types
rg "pattern" -T rust            # Exclude Rust files
rg "pattern" -T test            # Exclude test files

# See all available types
rg --type-list
```

### By File Pattern (Globs)

```bash
# Include patterns
rg "pattern" -g '*.toml'        # Only .toml files
rg "pattern" -g '*.{js,ts}'     # JavaScript and TypeScript files
rg "pattern" -g 'src/**/*.rs'   # Rust files in src/ subdirectories

# Exclude patterns
rg "pattern" -g '!*.md'                # Exclude markdown files
rg "pattern" -g '!test*'               # Exclude files starting with "test"
rg "pattern" -g '!**/node_modules/**'  # Exclude node_modules
```

### Multiple Filters

```bash
rg "pattern" -t rust -g '!**/target/**'    # Rust files, excluding target dir
rg "pattern" -g '*.nix' -g '!flake.nix'    # All .nix files except flake.nix
```

## Output Control

### Context Lines

```bash
rg "pattern" -C 2               # 2 lines before and after
rg "pattern" -A 3               # 3 lines after
rg "pattern" -B 1               # 1 line before
```

### Output Formatting

```bash
rg "pattern" -l                 # Only show filenames with matches
rg "pattern" -c                 # Count matches per file
rg "pattern" --no-line-number   # Hide line numbers
rg "pattern" --no-filename      # Hide filenames
rg "pattern" -o                 # Only show matching part
```

### Limiting Output

```bash
rg "pattern" -m 5               # Maximum 5 matches per file
rg "pattern" --max-columns 100  # Limit line length display
rg "pattern" --max-filesize 1M  # Skip files larger than 1MB
```

## Advanced Features

### Multiline Search

```bash
rg -U "pattern1.*pattern2"      # Multiline mode (dot matches newline)
rg -U "struct\s+\w+\s*\{"       # Find struct definitions across lines
```

### Replace Mode

```bash
rg "old_pattern" -r "new_text"               # Show what replace would look like
rg "fn\s+(\w+)" -r "function $1" --passthru  # Show all lines with replacements highlighted
```

### Search Statistics

```bash
rg "pattern" --stats  # Show search statistics
rg "pattern" --debug  # Debug information
```

## Configuration

### Config File

This configuration includes a ripgrep config file at `~/.config/ripgrep/config`:

```sh
# Always show line numbers
--line-number

# Smart case sensitivity
--smart-case

# Limit column width and show preview
--max-columns=120
--max-columns-preview

# Exclude git directory
--glob=!.git/*

# Add custom file type for Nix files
--type-add=nix:*.nix

# Exclude common directories
--glob=!**/node_modules/**
--glob=!**/target/**
--glob=!**/.build/**
```

### Custom File Types

```bash
# Add custom type temporarily
rg "pattern" --type-add 'config:*.{yml,yaml,toml,json}' -t config

# Add to config file permanently
--type-add=web:*.{html,css,js,jsx,ts,tsx}
--type-add=docs:*.{md,rst,txt}
```

## Common Workflows

### Code Review

```bash
# Find potential issues
rg "TODO|FIXME|HACK|XXX"
rg "console\.log|println!|print\("     # Debug statements
rg "unwrap\(\)|expect\("               # Potential panics (Rust)

# Check imports/dependencies
rg "^import\s+" -t js -t ts
rg "^use\s+" -t rust
```

### Refactoring

```bash
# Find all usages of a function/variable
rg "\bmyFunction\b"

# Find specific patterns in specific contexts
rg "\.unwrap\(\)" -t rust -g 'src/**'
rg "any\(" -t py -g 'tests/**'
```

### Documentation

```bash
# Find documentation patterns
rg "///|//!" -t rust                   # Rust doc comments
rg "#.*TODO" -g '*.py'                 # Python TODOs
rg "@param|@return" -t js              # JSDoc patterns
```

### Git

```bash
# Search only tracked files
rg "pattern" $(git ls-files)

# Search only modified files
rg "pattern" $(git diff --name-only)

# Search in specific commit
git show COMMIT_SHA | rg "pattern"
```

## Tips and Tricks

1. **Use smart-case by default**: Add `--smart-case` to config
2. **Combine with other tools**:

   ```bash
   rg -l "pattern" | xargs wc -l        # Count lines in matching files
   rg "pattern" -l | xargs ls -la       # List details of matching files
   ```

3. **Pipe to other tools**:

   ```bash
   rg "error" -t log | head -20         # First 20 error lines
   rg "function" -o | sort | uniq -c    # Count unique function names
   ```

4. **Use file lists for complex searches**:

   ```bash
   find . -name "*.nix" | rg -f - "pattern"
   ```
