# TODO Comment Search

Use `ripgrep` (`rg`) to find TODO-style comments quickly across projects. This
is useful for local cleanup, release checks, and CI gates.

## Quick search

```bash
rg --no-messages --vimgrep -H --column --line-number --color never \
  -e '(TODO|FIXME|BUG|HACK|XXX)' .
```

`--vimgrep`, `-H`, `--column`, and `--line-number` produce rows in this form:

```text
path/to/file:line:column:matched text
```

## Comment-aware search

This pattern looks for common comment prefixes, markdown task/list items, or a
tag at the start of a line:

```bash
TAGS='BUG|HACK|FIXME|TODO|XXX|\[ \]|\[x\]'
PREFIX='//|#|<!--|;|/\*|^|^[[:blank:]]*(-|[0-9]+\.)'

rg --no-messages --vimgrep -H --column --line-number --color never \
  --max-columns=1000 --no-config \
  -e "(${PREFIX})[[:space:]]*(${TAGS})" \
  -g '!**/.git/**' \
  -g '!**/node_modules/**' \
  -g '!**/target/**' \
  -g '!**/.build/**' \
  .
```

Notes:

- `--no-config` keeps personal rg config from changing project results.
- `--max-columns=1000` avoids dropping long lines too early.
- Add `-i` for case-insensitive tags.
- Add `--hidden` when dotfiles should be scanned too.

## Project script

Add this as `scripts/todos`:

```bash
#!/usr/bin/env bash
set -euo pipefail

TAGS='BUG|HACK|FIXME|TODO|XXX|\[ \]|\[x\]'
PREFIX='//|#|<!--|;|/\*|^|^[[:blank:]]*(-|[0-9]+\.)'

rg --no-messages --vimgrep -H --column --line-number --color never \
  --max-columns=1000 --no-config \
  -e "(${PREFIX})[[:space:]]*(${TAGS})" \
  -g '!**/.git/**' \
  -g '!**/node_modules/**' \
  -g '!**/target/**' \
  -g '!**/.build/**' \
  "$@" \
  .
```

Then:

```bash
chmod +x scripts/todos
scripts/todos
```

## Filters

Use `-g` for include and exclude globs. A glob beginning with `!` excludes
matches.

```bash
# Only source and markdown paths
scripts/todos -g 'src/**' -g 'docs/**' -g '*.md'

# Exclude generated/vendor paths
scripts/todos -g '!**/vendor/**' -g '!**/dist/**' -g '!**/*.lock'

# Include hidden files
scripts/todos --hidden
```

## CI check

Fail when TODO-style comments are present:

```bash
if scripts/todos >/tmp/todos.txt; then
  cat /tmp/todos.txt
  echo "TODO comments found"
  exit 1
fi
```

`rg` exits with `0` when it finds a match and `1` when it finds none.
