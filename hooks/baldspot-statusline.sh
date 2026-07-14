#!/usr/bin/env bash
# baldspot mode badge + model/effort, rendered as extra powerline segments in the same
# style as a gruvbox_dark Starship palette (badge in red, model/effort in orange — pick
# colors unused elsewhere in your own starship.toml so they read as an extension, not a
# clash). Merged directly into the Starship prompt with its leading (e.g. os/username)
# segment stripped here, without touching starship.toml.
#
# This script is an example tuned to one specific gruvbox_dark palette — see hooks/README.md
# before wiring it into statusLine.
flag="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.baldspot-active"
input=$(cat)

SEP_LEAD=$'\xee\x82\xb6'
SEP_ARROW=$'\xee\x82\xb0'
RED='204;36;29'
ORANGE='214;93;14'
YELLOW='215;153;33'
FG0='251;241;199'

seg() { printf '\033[48;2;%sm\033[38;2;%sm %s ' "$1" "$FG0" "$2"; }
lead() { printf '\033[38;2;%sm%s' "$1" "$SEP_LEAD"; }
join() { printf '\033[38;2;%sm\033[48;2;%sm%s' "$1" "$2" "$SEP_ARROW"; }

badge=""
if [ -f "$flag" ]; then
  mode=$(head -n1 "$flag" | tr -d '[:space:]')
  if [ -z "$mode" ] || [ "$mode" = "full" ]; then
    badge="BALDSPOT"
  else
    badge="BALDSPOT:$(printf '%s' "$mode" | tr '[:lower:]' '[:upper:]')"
  fi
fi

model=$(printf '%s' "$input" | jq -r '.model.display_name // empty' 2>/dev/null)
effort=$(printf '%s' "$input" | jq -r '.effort.level // empty' 2>/dev/null)
info="$model"
[ -n "$effort" ] && info="${info} (${effort})"

last=""
if [ -n "$badge" ]; then
  lead "$RED"
  seg "$RED" "$badge"
  last="$RED"
fi
if [ -n "$info" ]; then
  if [ -n "$last" ]; then join "$last" "$ORANGE"; else lead "$ORANGE"; fi
  seg "$ORANGE" "$info"
  last="$ORANGE"
fi

cwd=$(printf '%s' "$input" | jq -r '.cwd // .workspace.current_dir // empty' 2>/dev/null)
[ -n "$cwd" ] || cwd="$PWD"

if command -v starship >/dev/null 2>&1; then
  raw=$(env -u STARSHIP_SHELL starship prompt --path "$cwd" 2>/dev/null | grep -v '^$' | head -n1)
  # drop starship's own leading segment (everything through its first arrow separator)
  rest="${raw#*"$SEP_ARROW"}"
  if [ -n "$last" ]; then join "$last" "$YELLOW"; else lead "$YELLOW"; fi
  printf '%s' "$rest"
fi
