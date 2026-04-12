#!/usr/bin/env bash
set -euo pipefail

# ── helpers ──────────────────────────────────────────────────────────────────

header() { gum style --bold --foreground 99 "$1"; }
info()   { gum log --level info "$@"; }
warn()   { gum log --level warn "$@"; }
error()  { gum log --level error "$@"; }

usage() {
    if command -v gum &>/dev/null; then
        gum style \
            --border rounded \
            --border-foreground 99 \
            --padding "1 2" \
            --bold --foreground 212 \
            "GitHub Sparse Clone"

        echo ""
        gum style --faint "Fetch a GitHub repo's file tree, pick a directory, and sparse-clone just that path."
        echo ""

        gum style --bold --foreground 99 "USAGE"
        gum style "  ghsparse.sh --url <github-url> [--path <dir>] [--dest <dir>]"
        echo ""

        gum style --bold --foreground 99 "OPTIONS"
        gum format --type template \
            '  {{ Color "82" "" "--url URL" }}    GitHub repo URL {{ Faint "(required)" }}
  {{ Color "82" "" "--path DIR" }}   Directory to clone {{ Faint "(skips interactive picker)" }}
  {{ Color "82" "" "--dest DIR" }}   Local destination directory {{ Faint "(default: repo-basename)" }}
  {{ Color "82" "" "-h, --help" }}   Show this help message'
        echo ""

        gum style --bold --foreground 99 "EXAMPLES"
        gum format --type template \
            '  {{ Faint "#" }} Browse repo tree and sparse-clone a directory
  ghsparse.sh {{ Color "82" "" "--url https://github.com/owner/repo" }}

  {{ Faint "#" }} Non-interactively clone a specific path
  ghsparse.sh {{ Color "82" "" "--url https://github.com/owner/repo --path src/components" }}

  {{ Faint "#" }} Clone to a specific destination
  ghsparse.sh {{ Color "82" "" "--url https://github.com/owner/repo --path src --dest ./my-src" }}'
        echo ""

        gum style --bold --foreground 99 "ENVIRONMENT"
        gum format --type template \
            '  {{ Color "214" "" "GITHUB_TOKEN" }}  Set to avoid API rate limits (60 req/hr unauthenticated)'
        echo ""

        gum style --bold --foreground 99 "DEPENDENCIES"
        gum format --type template \
            '  {{ Color "212" "" "gum" }}   charmbracelet/gum  TUI components
  {{ Color "212" "" "curl" }}  curl               HTTP requests
  {{ Color "212" "" "jq" }}    jq                 JSON parsing
  {{ Color "212" "" "git" }}   git                sparse-checkout clone'
    else
        cat <<'EOF'
Usage: ghsparse.sh --url <github-url> [--path <dir>] [--dest <dir>]

Fetch a GitHub repo's file tree, pick a directory, and sparse-clone just that path.

Options:
  --url URL    GitHub repo URL (required)
  --path DIR   Directory to clone (skips interactive picker)
  --dest DIR   Local destination directory (default: repo-basename)
  -h, --help   Show this help message

Environment:
  GITHUB_TOKEN  Set to avoid API rate limits (60 req/hr unauthenticated)

Dependencies: gum, curl, jq, git
EOF
    fi
}

# ── arg parsing ───────────────────────────────────────────────────────────────

URL=""
PATH_ARG=""
DEST_ARG=""

while [[ $# -gt 0 ]]; do
    case "$1" in
    --url)     URL="$2";                shift 2 ;;
    --url=*)   URL="${1#--url=}";       shift   ;;
    --path)    PATH_ARG="$2";           shift 2 ;;
    --path=*)  PATH_ARG="${1#--path=}"; shift   ;;
    --dest)    DEST_ARG="$2";           shift 2 ;;
    --dest=*)  DEST_ARG="${1#--dest=}"; shift   ;;
    -h|--help) usage; exit 0 ;;
    *)
        echo "Error: unknown option '$1'" >&2
        echo ""
        usage
        exit 1
        ;;
    esac
done

# ── dependency check ──────────────────────────────────────────────────────────

for cmd in gum curl jq git; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Error: '$cmd' is not installed." >&2
        exit 1
    fi
done

# ── validate ──────────────────────────────────────────────────────────────────

if [[ -z "$URL" ]]; then
    error "--url is required"
    echo ""
    usage
    exit 1
fi

# ── parse GitHub URL ──────────────────────────────────────────────────────────
# Handles:
#   https://github.com/owner/repo
#   https://github.com/owner/repo.git
#   https://github.com/owner/repo/tree/branch
#   https://github.com/owner/repo/tree/branch/sub/path

URL="${URL%.git}"
URL="${URL%/}"

_remainder="${URL#https://github.com/}"
OWNER="${_remainder%%/*}"
_remainder="${_remainder#"$OWNER"/}"
REPO="${_remainder%%/*}"
_remainder="${_remainder#"$REPO"}"

BRANCH="HEAD"
if [[ "$_remainder" == /tree/* ]]; then
    _remainder="${_remainder#/tree/}"
    BRANCH="${_remainder%%/*}"
fi

CLONE_URL="https://github.com/$OWNER/$REPO.git"

# ── API helper ────────────────────────────────────────────────────────────────

_api_headers=(-H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28")
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    _api_headers+=(-H "Authorization: Bearer $GITHUB_TOKEN")
fi

api_get() {
    local url="$1"
    local out
    out=$(curl -sf "${_api_headers[@]}" "$url") || {
        error "GitHub API request failed: $url"
        exit 1
    }
    echo "$out"
}

# ── sparse clone function ─────────────────────────────────────────────────────

do_sparse_clone() {
    local selected="$1"
    local dest="$2"

    echo ""
    header "Sparse-cloning ${OWNER}/${REPO} → ${dest}/${selected}"
    echo ""

    gum spin --spinner dot --title "Cloning (no-checkout, blob filter)..." -- \
        git clone --no-checkout --depth=1 --filter=blob:none "$CLONE_URL" "$dest"

    (
        cd "$dest"
        git sparse-checkout init --cone

        if [[ "$selected" == "." ]]; then
            git sparse-checkout disable
        else
            git sparse-checkout set "$selected"
        fi

        gum spin --spinner dot --title "Checking out ${selected}..." -- git checkout
    )

    echo ""

    local checkout_root="$dest"
    [[ "$selected" != "." ]] && checkout_root="$dest/$selected"

    local file_count dir_count
    file_count=$(find "$checkout_root" -type f | wc -l | tr -d ' ')
    dir_count=$(find  "$checkout_root" -type d | wc -l | tr -d ' ')

    {
        echo "Field,Value"
        echo "Destination,$dest"
        echo "Checked-out path,$checkout_root"
        echo "Files,$file_count"
        echo "Directories,$dir_count"
    } | gum table

    echo ""
    gum style --foreground 82 --bold "Done. Sparse clone complete."
}

# ── banner ────────────────────────────────────────────────────────────────────

gum style \
    --border double \
    --border-foreground 99 \
    --padding "1 3" \
    --bold --foreground 212 \
    "GitHub Sparse Clone" \
    "$OWNER/$REPO  (branch: $BRANCH)"

echo ""

# ═════════════════════════════════════════════════════════════════════════════
# --path mode: non-interactive sparse clone of a specific directory
# ═════════════════════════════════════════════════════════════════════════════

if [[ -n "$PATH_ARG" ]]; then
    PATH_ARG="${PATH_ARG#/}"
    PATH_ARG="${PATH_ARG%/}"

    selected="$PATH_ARG"

    if [[ -n "$DEST_ARG" ]]; then
        dest="$DEST_ARG"
    elif [[ "$selected" == "." ]]; then
        dest="$REPO"
    else
        dest="${REPO}-$(basename "$selected")"
    fi

    if [[ -e "$dest" ]]; then
        error "Destination already exists: $dest"
        exit 1
    fi

    do_sparse_clone "$selected" "$dest"
    exit 0
fi

# ═════════════════════════════════════════════════════════════════════════════
# interactive mode: fetch full tree, select directory, sparse-clone
# ═════════════════════════════════════════════════════════════════════════════

info "Fetching file tree..." ref "$BRANCH"
tree_json=$(api_get \
    "https://api.github.com/repos/$OWNER/$REPO/git/trees/$BRANCH?recursive=1")

if echo "$tree_json" | jq -e '.message' &>/dev/null; then
    msg=$(echo "$tree_json" | jq -r '.message')
    error "GitHub API error: $msg"
    exit 1
fi

if [[ "$(echo "$tree_json" | jq '.truncated')" == "true" ]]; then
    warn "Tree is truncated — repo is very large, only partial results shown"
fi

# Build directory list (type=tree entries) prepended with "." for repo root
dirs=$(echo "$tree_json" | jq -r '.tree[] | select(.type=="tree") | .path' | sort)
dir_list=$(printf '.\n%s' "$dirs")

header "Select a directory to clone"
echo ""

selected=$(echo "$dir_list" | gum filter \
    --placeholder "Type to filter directories..." \
    --height 20 \
    --prompt "> " \
    --header "  ${OWNER}/${REPO} — choose a directory")

if [[ -z "$selected" ]]; then
    warn "No directory selected."
    exit 0
fi

echo ""
info "Selected" path "$selected"

# ── choose destination dir ────────────────────────────────────────────────────

if [[ "$selected" == "." ]]; then
    default_dest="$REPO"
else
    default_dest="${REPO}-$(basename "$selected")"
fi

dest=$(gum input \
    --placeholder "$default_dest" \
    --header "Clone into (leave blank for '$default_dest'):" \
    --width 60)
dest="${dest:-$default_dest}"

if [[ -e "$dest" ]]; then
    error "Destination already exists: $dest"
    exit 1
fi

do_sparse_clone "$selected" "$dest"
