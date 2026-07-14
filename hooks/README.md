Installing this plugin wires up two hooks automatically (via `.claude-plugin/plugin.json`'s
`hooks` field), mirroring how [ponytail](https://github.com/DietrichGebert/ponytail) persists
its own mode:

- **`baldspot-activate.sh`** (`SessionStart`) — activates baldspot every session (default
  mode `full`). Override with the `BALDSPOT_DEFAULT_MODE` env var or `defaultMode` in
  `~/.config/baldspot/config.json` (`off` disables).
- **`baldspot-mode-tracker.sh`** (`UserPromptSubmit`) — tracks `/baldspot [lite|full|ultra|off]`,
  `stop baldspot`, and `normal mode` in a flag file (`$CLAUDE_CONFIG_DIR/.baldspot-active`).

## Optional: statusline badge

**`baldspot-statusline.sh`** is not auto-installed — a plugin can't safely rewrite your
`statusLine` config, since that's cosmetic and yours to own. It reads the flag file above and
prints a `[BALDSPOT]`/`[BALDSPOT:MODE]` badge plus the current model/effort, then pipes through
`starship prompt` (if installed) with its leading segment stripped so the badge merges into
one powerline chain.

To use it, add to `settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash \"$HOME/.claude/hooks/baldspot-statusline.sh\""
  }
}
```

(copy the script into `~/.claude/hooks/` first, or point `command` at wherever this plugin is
installed). The `RED`/`ORANGE`/`YELLOW` colors and the leading-segment strip are tuned to one
gruvbox_dark `starship.toml`; adjust them to match your own palette and format.
