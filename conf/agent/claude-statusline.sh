#!/bin/sh
# Claude Code status line: directory, git branch, model, and remaining context
# and rate-limit budget. Claude Code pipes a JSON status payload on stdin and
# renders whatever this script writes to stdout.
#
# Referenced from conf/agent/claude-settings.json as $HOME/.claude/statusline.sh.

input=$(cat)

# One jq pass for every field; the status line re-renders constantly, so five
# separate jq invocations are worth avoiding. Percentages are reported as
# "used", and the status line shows what is left.
fields=$(
  printf '%s' "$input" | jq -r '
    def left(p): if (p | type) == "number" then (100 - p | round | tostring) else "" end;
    [
      (.workspace.current_dir // .cwd // ""),
      (.model.display_name // ""),
      left(.context_window.used_percentage),
      left(.rate_limits.five_hour.used_percentage),
      left(.rate_limits.seven_day.used_percentage)
    ] | @tsv
  '
)

IFS='	' read -r dir model ctx five week <<EOT
$fields
EOT

branch=$(git -C "$dir" --no-optional-locks branch --show-current 2>/dev/null)

display_dir="$dir"
case "$dir" in
  "$HOME" | "$HOME"/*) display_dir="~${dir#"$HOME"}" ;;
esac

BLUE=$(tput setaf 4 2>/dev/null)
DIM=$(tput setaf 8 2>/dev/null)
RESET=$(tput sgr0 2>/dev/null)

out="${BLUE}${display_dir}${RESET}"
[ -n "$branch" ] && out="${out} ${DIM}  ${branch}${RESET}"
out="${out} ${DIM}${model}${RESET}"

usage=""
[ -n "$ctx" ] && usage="Ctx:$ctx%"
[ -n "$five" ] && usage="${usage:+$usage }5h:$five%"
[ -n "$week" ] && usage="${usage:+$usage }7d:$week%"
[ -n "$usage" ] && out="${out} ${DIM}${usage} left${RESET}"

printf '%s' "$out"
