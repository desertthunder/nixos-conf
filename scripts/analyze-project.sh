#!/usr/bin/env bash
set -euo pipefail

HAS_GUM=false
IS_TTY=false
if command -v gum &>/dev/null; then HAS_GUM=true; fi
if [[ -t 1 ]]; then IS_TTY=true; fi

interactive() { $HAS_GUM && $IS_TTY; }

header() {
    if interactive; then
        gum style --bold --foreground 99 "$1"
    else
        echo "=== $1 ==="
    fi
}

info() {
    if interactive; then
        gum log --level info "$@"
    else
        echo "[info] $*"
    fi
}

warn() {
    if interactive; then
        gum log --level warn "$@"
    else
        echo "[warn] $*" >&2
    fi
}

error() {
    if interactive; then
        gum log --level error "$@"
    else
        echo "[error] $*" >&2
    fi
}

usage() {
    if interactive; then
        gum style \
            --border rounded \
            --border-foreground 99 \
            --padding "1 2" \
            --bold --foreground 212 \
            "Source Code Analyzer"

        echo ""
        gum style --faint "Gitignore-aware source code analyzer using ripgrep and gum."
        gum style --faint "Counts lines of code or words across your project."
        echo ""

        gum style --bold --foreground 99 "USAGE"
        gum style "  analyze-project.sh [-h] [-d DIR] [-m MODE] [-t LINES]"
        echo ""

        gum style --bold --foreground 99 "OPTIONS"
        gum format --type template \
            '  {{ Color "82" "" "-h" }}        Show this help message
  {{ Color "82" "" "-d DIR" }}   Target directory {{ Faint "(default: interactive prompt → .)" }}
  {{ Color "82" "" "-m MODE" }}  Run a specific mode non-interactively
  {{ Color "82" "" "-t LINES" }} Line threshold for big files {{ Faint "(default: 1000)" }}'
        echo ""

        gum style --bold --foreground 99 "MODES"
        gum format --type template \
            '  {{ Color "214" "" "loc" }}        Lines of code per file type
  {{ Color "214" "" "words" }}      Word count per file type
  {{ Color "214" "" "files" }}      File count per file type
  {{ Color "214" "" "big" }}        Files exceeding the line threshold
  {{ Color "214" "" "all" }}        Run all modes sequentially'
        echo ""

        gum style --bold --foreground 99 "EXAMPLES"
        gum format --type template \
            '  {{ Faint "#" }} Fully interactive
  analyze-project.sh

  {{ Faint "#" }} Skip the directory prompt
  analyze-project.sh {{ Color "82" "" "-d ~/Projects/myapp" }}

  {{ Faint "#" }} Non-interactive LoC count
  analyze-project.sh {{ Color "82" "" "-d . -m loc" }}

  {{ Faint "#" }} Find files over 500 lines
  analyze-project.sh {{ Color "82" "" "-d . -m big -t 500" }}'
        echo ""

        gum style --bold --foreground 99 "DEPENDENCIES"
        gum format --type template \
            '  {{ Color "212" "" "gum" }}  charmbracelet/gum   TUI components (optional)
  {{ Color "212" "" "rg" }}   BurntSushi/ripgrep  Fast recursive search'
    else
        cat <<'EOF'
Usage: analyze-project.sh [-h] [-d DIR] [-m MODE] [-t LINES]

Gitignore-aware source code analyzer using ripgrep and gum.
Counts lines of code or words across your project.

Options:
  -h        Show this help message
  -d DIR    Target directory (default: interactive prompt, falls back to .)
  -m MODE   Run a specific mode non-interactively:
              loc        Lines of code per file type
              words      Word count per file type
              files      File count per file type
              big        Files exceeding the line threshold
              all        Run all modes sequentially
  -t LINES  Line threshold for big files (default: 1000)

Examples:
  analyze-project.sh                       # Fully interactive
  analyze-project.sh -d ~/Projects/myapp   # Skip directory prompt
  analyze-project.sh -m loc                # Skip mode prompt
  analyze-project.sh -d . -m loc           # Non-interactive LoC count
  analyze-project.sh -d . -m big -t 500    # Find files over 500 lines

Dependencies: rg (ripgrep), gum (optional, for interactive TUI)
EOF
    fi
}

ARG_DIR=""
ARG_MODE=""
ARG_THRESHOLD=""

while getopts ":hd:m:t:" opt; do
    case "$opt" in
    h)
        usage
        exit 0
        ;;
    d) ARG_DIR="$OPTARG" ;;
    m) ARG_MODE="$OPTARG" ;;
    t) ARG_THRESHOLD="$OPTARG" ;;
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

if ! command -v rg &>/dev/null; then
    echo "Error: 'rg' (ripgrep) is not installed." >&2
    exit 1
fi

if interactive; then
    gum style \
        --border double \
        --border-foreground 99 \
        --padding "1 3" \
        --bold \
        --foreground 212 \
        "Source Code Analyzer" \
        "Gitignore-aware — counts LoC, words, and files"
fi

if [[ -n "$ARG_DIR" ]]; then
    TARGET="$ARG_DIR"
elif interactive; then
    TARGET=$(gum input \
        --placeholder "." \
        --header "Directory to analyze (leave blank for current):" \
        --width 60)
    TARGET="${TARGET:-.}"
else
    TARGET="."
fi

if [[ ! -d "$TARGET" ]]; then
    error "Not a directory: $TARGET"
    exit 1
fi

TARGET=$(cd "$TARGET" && pwd)
info "Analyzing" path "$TARGET"

THRESHOLD="${ARG_THRESHOLD:-1000}"
if ! [[ "$THRESHOLD" =~ ^[0-9]+$ ]]; then
    echo "Error: threshold must be a number, got '$THRESHOLD'" >&2
    exit 1
fi

if [[ -n "$ARG_MODE" ]]; then
    case "$ARG_MODE" in
    loc) ACTION="Lines of code per file type" ;;
    words) ACTION="Word count per file type" ;;
    files) ACTION="File count per file type" ;;
    big) ACTION="Big files — may need splitting" ;;
    all) ACTION="All of the above" ;;
    *)
        echo "Error: unknown mode '$ARG_MODE' (use loc, words, files, big, or all)" >&2
        exit 1
        ;;
    esac
elif interactive; then
    ACTION=$(gum choose \
        --header "What would you like to count?" \
        "Lines of code per file type" \
        "Word count per file type" \
        "File count per file type" \
        "Big files — may need splitting" \
        "All of the above")
else
    ACTION="All of the above"
fi

get_files() {
    rg --files "$TARGET" 2>/dev/null
}

file_ext() {
    local name
    name=$(basename "$1")
    if [[ "$name" == .* && ! "$name" == *.*.* ]]; then
        echo "$name"
    elif [[ "$name" == *"."* ]]; then
        echo ".${name##*.}" | tr '[:upper:]' '[:lower:]'
    else
        echo "(no ext)"
    fi
}

run_loc() {
    echo ""
    header "Lines of Code by File Type"
    echo ""

    local -A ext_lines ext_files
    local total_lines=0 total_files=0

    while IFS= read -r file; do
        local ext lc
        ext=$(file_ext "$file")
        lc=$(wc -l <"$file" 2>/dev/null || echo 0)
        lc=$(echo "$lc" | tr -d ' ')
        ext_lines[$ext]=$((${ext_lines[$ext]:-0} + lc))
        ext_files[$ext]=$((${ext_files[$ext]:-0} + 1))
        total_lines=$((total_lines + lc))
        total_files=$((total_files + 1))
    done < <(get_files)

    local sorted
    sorted=$(for ext in "${!ext_lines[@]}"; do
        printf "%d\t%d\t%s\n" "${ext_lines[$ext]}" "${ext_files[$ext]}" "$ext"
    done | sort -t$'\t' -k1 -rn)

    if interactive; then
        {
            echo "Extension,Lines,Files,%"
            while IFS=$'\t' read -r lines files ext; do
                local pct=0
                if ((total_lines > 0)); then
                    pct=$((lines * 100 / total_lines))
                fi
                echo "$ext,$lines,$files,${pct}%"
            done <<<"$sorted"
            echo "TOTAL,$total_lines,$total_files,100%"
        } | gum table
    else
        printf "%-20s %10s %8s %6s\n" "Extension" "Lines" "Files" "%"
        printf "%-20s %10s %8s %6s\n" "--------------------" "----------" "--------" "------"
        while IFS=$'\t' read -r lines files ext; do
            local pct=0
            if ((total_lines > 0)); then
                pct=$((lines * 100 / total_lines))
            fi
            printf "%-20s %10d %8d %5d%%\n" "$ext" "$lines" "$files" "$pct"
        done <<<"$sorted"
        printf "%-20s %10d %8d %5s\n" "TOTAL" "$total_lines" "$total_files" "100%"
    fi

    echo ""
    info "Total: $total_lines lines across $total_files files"
}

run_words() {
    echo ""
    header "Word Count by File Type"
    echo ""

    local -A ext_words ext_files
    local total_words=0 total_files=0

    while IFS= read -r file; do
        local ext wc_out
        ext=$(file_ext "$file")
        wc_out=$(wc -w <"$file" 2>/dev/null || echo 0)
        wc_out=$(echo "$wc_out" | tr -d ' ')
        ext_words[$ext]=$((${ext_words[$ext]:-0} + wc_out))
        ext_files[$ext]=$((${ext_files[$ext]:-0} + 1))
        total_words=$((total_words + wc_out))
        total_files=$((total_files + 1))
    done < <(get_files)

    local sorted
    sorted=$(for ext in "${!ext_words[@]}"; do
        printf "%d\t%d\t%s\n" "${ext_words[$ext]}" "${ext_files[$ext]}" "$ext"
    done | sort -t$'\t' -k1 -rn)

    if interactive; then
        {
            echo "Extension,Words,Files,%"
            while IFS=$'\t' read -r words files ext; do
                local pct=0
                if ((total_words > 0)); then
                    pct=$((words * 100 / total_words))
                fi
                echo "$ext,$words,$files,${pct}%"
            done <<<"$sorted"
            echo "TOTAL,$total_words,$total_files,100%"
        } | gum table
    else
        printf "%-20s %10s %8s %6s\n" "Extension" "Words" "Files" "%"
        printf "%-20s %10s %8s %6s\n" "--------------------" "----------" "--------" "------"
        while IFS=$'\t' read -r words files ext; do
            local pct=0
            if ((total_words > 0)); then
                pct=$((words * 100 / total_words))
            fi
            printf "%-20s %10d %8d %5d%%\n" "$ext" "$words" "$files" "$pct"
        done <<<"$sorted"
        printf "%-20s %10d %8d %5s\n" "TOTAL" "$total_words" "$total_files" "100%"
    fi

    echo ""
    info "Total: $total_words words across $total_files files"
}

run_files() {
    echo ""
    header "File Count by Type"
    echo ""

    local -A ext_files
    local total_files=0

    while IFS= read -r file; do
        local ext
        ext=$(file_ext "$file")
        ext_files[$ext]=$((${ext_files[$ext]:-0} + 1))
        total_files=$((total_files + 1))
    done < <(get_files)

    local sorted
    sorted=$(for ext in "${!ext_files[@]}"; do
        printf "%d\t%s\n" "${ext_files[$ext]}" "$ext"
    done | sort -t$'\t' -k1 -rn)

    if interactive; then
        {
            echo "Extension,Files,%"
            while IFS=$'\t' read -r files ext; do
                local pct=0
                if ((total_files > 0)); then
                    pct=$((files * 100 / total_files))
                fi
                echo "$ext,$files,${pct}%"
            done <<<"$sorted"
            echo "TOTAL,$total_files,100%"
        } | gum table
    else
        printf "%-20s %10s %6s\n" "Extension" "Files" "%"
        printf "%-20s %10s %6s\n" "--------------------" "----------" "------"
        while IFS=$'\t' read -r files ext; do
            local pct=0
            if ((total_files > 0)); then
                pct=$((files * 100 / total_files))
            fi
            printf "%-20s %10d %5d%%\n" "$ext" "$files" "$pct"
        done <<<"$sorted"
        printf "%-20s %10d %5s\n" "TOTAL" "$total_files" "100%"
    fi

    echo ""
    info "Total: $total_files files"
}

run_big() {
    echo ""
    header "Files exceeding $THRESHOLD lines (candidates for splitting)"
    echo ""

    local -a big_files=()

    while IFS= read -r file; do
        local lc
        lc=$(wc -l <"$file" 2>/dev/null || echo 0)
        lc=$(echo "$lc" | tr -d ' ')
        if ((lc >= THRESHOLD)); then
            big_files+=("$lc"$'\t'"$file")
        fi
    done < <(get_files)

    if ((${#big_files[@]} == 0)); then
        info "No files found with >= $THRESHOLD lines"
        return
    fi

    local sorted
    sorted=$(printf '%s\n' "${big_files[@]}" | sort -t$'\t' -k1 -rn)

    if interactive; then
        {
            echo "Lines,File"
            while IFS=$'\t' read -r lines file; do
                local relpath="${file#"$TARGET"/}"
                echo "$lines,$relpath"
            done <<<"$sorted"
        } | gum table
    else
        printf "%10s  %s\n" "Lines" "File"
        printf "%10s  %s\n" "----------" "----"
        while IFS=$'\t' read -r lines file; do
            local relpath="${file#"$TARGET"/}"
            printf "%10d  %s\n" "$lines" "$relpath"
        done <<<"$sorted"
    fi

    local count=${#big_files[@]}
    echo ""
    info "Found $count file(s) with >= $THRESHOLD lines"
}

case "$ACTION" in
"Lines of code"*) run_loc ;;
"Word count"*) run_words ;;
"File count"*) run_files ;;
"Big files"*) run_big ;;
"All of the above")
    run_loc
    echo ""
    if interactive; then
        gum style --border normal --border-foreground 240 --padding "0 1" "Next: Word count"
    fi
    echo ""
    run_words
    echo ""
    if interactive; then
        gum style --border normal --border-foreground 240 --padding "0 1" "Next: File count"
    fi
    echo ""
    run_files
    echo ""
    if interactive; then
        gum style --border normal --border-foreground 240 --padding "0 1" "Next: Big files (>= $THRESHOLD lines)"
    fi
    echo ""
    run_big
    ;;
esac

echo ""
if interactive; then
    gum style --foreground 82 --bold "Analysis complete."
else
    echo "Analysis complete."
fi
