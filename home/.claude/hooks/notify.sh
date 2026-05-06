#!/usr/bin/env bash
# Notify via terminal-notifier; suppress if terminal app is frontmost.
title="${1:-Claude Code}"
message="${2:-Claude}"
sound="${3:-Glass}"

front=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)

case "$front" in
  Ghostty|Terminal|iTerm2|iTerm|kitty|Alacritty|WezTerm|Hyper|"Warp"|"Tabby")
    exit 0
    ;;
esac

terminal-notifier -title "$title" -message "$message" -sound "$sound" -group claude-code -activate com.mitchellh.ghostty -appIcon "$HOME/.claude/assets/claude.png" -contentImage "$HOME/.claude/assets/claude.png" >/dev/null 2>&1 || true
