#!/usr/bin/env bash
# baldspot: SessionStart hook, mirrors ponytail-activate.js — auto-activates baldspot every session.
# Default mode resolution: BALDSPOT_DEFAULT_MODE env var -> ~/.config/baldspot/config.json "defaultMode" -> full.
claude_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
flag="$claude_dir/.baldspot-active"
config="$HOME/.config/baldspot/config.json"

mode="${BALDSPOT_DEFAULT_MODE:-}"
if [ -z "$mode" ] && [ -f "$config" ]; then
  mode=$(jq -r '.defaultMode // empty' "$config" 2>/dev/null)
fi
mode=$(printf '%s' "${mode:-full}" | tr '[:upper:]' '[:lower:]')

case "$mode" in
  lite|full|ultra) : ;;
  off) rm -f "$flag"; exit 0 ;;
  *) mode="full" ;;
esac

printf '%s' "$mode" > "$flag"

# ${CLAUDE_PLUGIN_ROOT} is set when running as an installed plugin hook (skill ships
# alongside this script); falls back to a manually symlinked/copied skill under $claude_dir.
skill="${CLAUDE_PLUGIN_ROOT:-$claude_dir}/skills/baldspot/SKILL.md"
if [ -f "$skill" ]; then
  body=$(awk '/^---$/{c++; next} c>=2' "$skill")
  printf 'BALDSPOT MODE ACTIVE — level: %s\n\n%s\n' "$mode" "$body"
else
  printf 'BALDSPOT MODE ACTIVE — level: %s\n' "$mode"
fi
