#!/usr/bin/env bash
# baldspot: UserPromptSubmit hook that tracks /baldspot mode in a flag file for the statusline badge.
# Mirrors ponytail-mode-tracker.js's approach, scoped to baldspot's own skill commands.
flag="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.baldspot-active"

prompt=$(jq -r '.prompt // ""' 2>/dev/null)
lower=$(printf '%s' "$prompt" | tr '[:upper:]' '[:lower:]')
trimmed=$(printf '%s' "$lower" | sed -E 's/[.!?[:space:]]+$//; s/^[[:space:]]+//')

if [[ "$trimmed" == "stop baldspot" || "$trimmed" == "normal mode" ]]; then
  rm -f "$flag"
  exit 0
fi

if [[ "$lower" =~ ^/baldspot([[:space:]]|$) ]]; then
  arg=$(printf '%s' "$lower" | awk '{print $2}')
  case "$arg" in
    lite|full|ultra) printf '%s' "$arg" > "$flag" ;;
    off) rm -f "$flag" ;;
    *) printf 'full' > "$flag" ;;
  esac
fi

exit 0
