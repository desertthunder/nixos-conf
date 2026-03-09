#!/usr/bin/env bash
set -euo pipefail

usage() {
    if command -v gum &>/dev/null && [[ -t 1 ]]; then
        gum style \
            --border rounded \
            --border-foreground 99 \
            --padding "1 2" \
            --bold --foreground 212 \
            "Disk Storage Analyzer"

        echo ""
        gum style --faint "Interactive disk analyzer using dust, ripgrep, and gum."
        gum style --faint "Read-only — no files will be modified or deleted."
        echo ""

        gum style --bold --foreground 99 "USAGE"
        gum style "  analyze-disk.sh [-h] [-d DIR] [-m MODE]"
        echo ""

        gum style --bold --foreground 99 "OPTIONS"
        gum format --type template \
            '  {{ Color "82" "" "-h" }}        Show this help message
  {{ Color "82" "" "-d DIR" }}   Target directory {{ Faint "(default: interactive prompt → $HOME)" }}
  {{ Color "82" "" "-m MODE" }}  Run a specific mode non-interactively'
        echo ""

        gum style --bold --foreground 99 "MODES"
        gum format --type template \
            '  {{ Color "214" "" "overview" }}   Top space consumers (dust tree)
  {{ Color "214" "" "large" }}      Find files above a size threshold
  {{ Color "214" "" "search" }}     Find files by name or content pattern
  {{ Color "214" "" "all" }}        Run all modes sequentially'
        echo ""

        gum style --bold --foreground 99 "EXAMPLES"
        gum format --type template \
            '  {{ Faint "#" }} Fully interactive
  analyze-disk.sh

  {{ Faint "#" }} Skip the directory prompt
  analyze-disk.sh {{ Color "82" "" "-d ~/Projects" }}

  {{ Faint "#" }} Skip the mode prompt
  analyze-disk.sh {{ Color "82" "" "-m overview" }}

  {{ Faint "#" }} Non-interactive: large files on /
  analyze-disk.sh {{ Color "82" "" "-d / -m large" }}'
        echo ""

        gum style --bold --foreground 99 "DEPENDENCIES"
        gum format --type template \
            '  {{ Color "212" "" "gum" }}  charmbracelet/gum   TUI components
  {{ Color "212" "" "dust" }} bootandy/dust       Disk usage analyzer
  {{ Color "212" "" "rg" }}   BurntSushi/ripgrep  Fast recursive search'
    else
        cat <<'EOF'
Usage: analyze-disk.sh [-h] [-d DIR] [-m MODE]

Interactive disk storage analyzer using dust, ripgrep, and gum.
Read-only — no files will be modified or deleted.

Options:
  -h        Show this help message
  -d DIR    Target directory (default: interactive prompt, falls back to $HOME)
  -m MODE   Run a specific mode non-interactively:
              overview   Top space consumers (dust tree)
              large      Find files above a size threshold
              search     Find files by name or content pattern
              all        Run all modes sequentially

Examples:
  analyze-disk.sh                  # Fully interactive
  analyze-disk.sh -d ~/Projects    # Skip directory prompt
  analyze-disk.sh -m overview      # Skip mode prompt
  analyze-disk.sh -d / -m large    # Non-interactive: large files on /

Dependencies: gum, dust (du-dust), rg (ripgrep)
EOF
    fi
}

while getopts ":hd:m:" opt; do
    case "$opt" in
    h)
        usage
        exit 0
        ;;
    d) ARG_DIR="$OPTARG" ;;
    m) ARG_MODE="$OPTARG" ;;
    :)
        echo "Error: -$OPTARG requires an argument" >&2
        usage
        exit 1
        ;;
    *)
        echo "Error: unknown option -$OPTARG" >&2
        usage
        exit 1
        ;;
    esac
done

for cmd in gum dust rg; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Error: '$cmd' is not installed." >&2
        exit 1
    fi
done

gum style \
    --border double \
    --border-foreground 99 \
    --padding "1 3" \
    --bold \
    --foreground 212 \
    "Disk Storage Analyzer" \
    "Read-only — no files will be modified or deleted"

if [[ -n "${ARG_DIR:-}" ]]; then
    TARGET="$ARG_DIR"
else
    TARGET=$(gum input \
        --placeholder "$HOME" \
        --header "Directory to analyze (leave blank for home):" \
        --width 60)
    TARGET="${TARGET:-$HOME}"
fi

if [[ ! -d "$TARGET" ]]; then
    gum log --level error "Not a directory: $TARGET"
    exit 1
fi

gum log --level info "Analyzing" path "$TARGET"

if [[ -n "${ARG_MODE:-}" ]]; then
    case "$ARG_MODE" in
    overview) ACTION="Overview — top space consumers" ;;
    large) ACTION="Large files — find files above a size threshold" ;;
    search) ACTION="Search — find files by name or content pattern" ;;
    all) ACTION="All of the above" ;;
    *)
        echo "Error: unknown mode '$ARG_MODE' (use overview, large, search, or all)" >&2
        exit 1
        ;;
    esac
else
    ACTION=$(gum choose \
        --header "What would you like to do?" \
        "Overview — top space consumers" \
        "Large files — find files above a size threshold" \
        "Search — find files by name or content pattern" \
        "All of the above")
fi

run_overview() {
    local lines
    lines=$(gum input --placeholder "20" --header "How many entries to show?")
    lines="${lines:-20}"

    echo ""
    gum style --bold --foreground 99 "Top $lines space consumers in $TARGET"
    echo ""
    dust -n "$lines" -r "$TARGET"
    echo ""

    if gum confirm "Show directories only?"; then
        echo ""
        gum style --bold --foreground 99 "Directories only"
        echo ""
        dust -n "$lines" -r -D "$TARGET"
    fi
}

run_large_files() {
    local threshold
    threshold=$(gum choose \
        --header "Minimum file size:" \
        "1M" "10M" "50M" "100M" "500M" "1G")

    echo ""
    gum style --bold --foreground 99 "Files >= $threshold in $TARGET"
    echo ""
    dust -n 30 -r -F -z "$threshold" "$TARGET" || true
    echo ""

    gum style --bold --foreground 99 "Searching for common large file types..."
    echo ""

    local patterns=(
        '\.log$'
        '\.zip$|\.tar|\.gz$|\.bz2$|\.xz$|\.zst$'
        '\.iso$|\.img$|\.dmg$'
        '\.mp4$|\.mkv$|\.avi$|\.mov$'
        '\.node_modules|\.cache|__pycache__'
    )
    local labels=(
        "Log files"
        "Archives"
        "Disk images"
        "Videos"
        "Caches (node_modules, .cache, __pycache__)"
    )

    for i in "${!patterns[@]}"; do
        local matches
        matches=$(rg --files --hidden --no-ignore -g '!.Trash' "$TARGET" 2>/dev/null |
            rg "${patterns[$i]}" 2>/dev/null | head -20 || true)
        if [[ -n "$matches" ]]; then
            gum style --foreground 214 "${labels[$i]}:"
            echo "$matches" | while read -r f; do
                if [[ -f "$f" ]]; then
                    local sz
                    sz=$(du -sh "$f" 2>/dev/null | cut -f1)
                    printf "  %8s  %s\n" "$sz" "$f"
                fi
            done
            echo ""
        fi
    done
}

run_search() {
    local mode
    mode=$(gum choose \
        --header "Search by:" \
        "Filename pattern" \
        "File content (ripgrep)")

    if [[ "$mode" == "Filename pattern" ]]; then
        local pattern
        pattern=$(gum input --placeholder "*.log" --header "Glob or regex pattern:")
        if [[ -z "$pattern" ]]; then
            gum log --level warn "No pattern provided"
            return
        fi

        echo ""
        gum style --bold --foreground 99 "Files matching '$pattern' in $TARGET"
        echo ""

        local results
        results=$(rg --files --hidden --no-ignore -g '!.Trash' "$TARGET" 2>/dev/null |
            rg "$pattern" 2>/dev/null | head -50 || true)

        if [[ -z "$results" ]]; then
            gum log --level warn "No files found matching '$pattern'"
        else
            local count
            count=$(echo "$results" | wc -l | tr -d ' ')
            gum log --level info "Found $count file(s)"
            echo ""
            echo "$results" | while read -r f; do
                if [[ -e "$f" ]]; then
                    local sz
                    sz=$(du -sh "$f" 2>/dev/null | cut -f1)
                    printf "  %8s  %s\n" "$sz" "$f"
                fi
            done
        fi

    else
        local pattern
        pattern=$(gum input --placeholder "TODO|FIXME|HACK" --header "Content regex:")
        if [[ -z "$pattern" ]]; then
            gum log --level warn "No pattern provided"
            return
        fi

        echo ""
        gum style --bold --foreground 99 "Files containing '$pattern' in $TARGET"
        echo ""

        local results
        results=$(rg -l --hidden "$pattern" "$TARGET" 2>/dev/null | head -50 || true)

        if [[ -z "$results" ]]; then
            gum log --level warn "No files found containing '$pattern'"
        else
            local count
            count=$(echo "$results" | wc -l | tr -d ' ')
            gum log --level info "Found $count file(s) with matches"
            echo ""
            echo "$results" | while read -r f; do
                if [[ -f "$f" ]]; then
                    local sz mc
                    sz=$(du -sh "$f" 2>/dev/null | cut -f1)
                    mc=$(rg -c "$pattern" "$f" 2>/dev/null || echo 0)
                    printf "  %8s  (%s matches)  %s\n" "$sz" "$mc" "$f"
                fi
            done
        fi
    fi
}

case "$ACTION" in
"Overview"*) run_overview ;;
"Large files"*) run_large_files ;;
"Search"*) run_search ;;
"All of the above")
    run_overview
    echo ""
    gum style --border normal --border-foreground 240 --padding "0 1" "Next: Large files"
    echo ""
    run_large_files
    echo ""
    gum style --border normal --border-foreground 240 --padding "0 1" "Next: Search"
    echo ""
    run_search
    ;;
esac

echo ""
gum style --foreground 82 --bold "Analysis complete. No files were modified."
