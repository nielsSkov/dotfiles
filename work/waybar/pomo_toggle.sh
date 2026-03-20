#!/usr/bin/env bash
j="$(pomodoro-cli status --format json 2>/dev/null || true)"
cls="$(printf '%s' "$j" | jq -r '.class // empty')"
txt="$(printf '%s' "$j" | jq -r '.text // empty')"

case "$cls" in
  running)
    pomodoro-cli pause
    ;;
  paused)
    # pause toggles resume in this tool
    pomodoro-cli pause
    ;;
  *)
    # inactive/finished/stopped/unknown -> start
    CANCEL="${XDG_CACHE_HOME:-$HOME/.cache}/pomo_cancel"
    rm -f "$CANCEL"
    pomodoro-cli start --duration 25m --silent
    (
      while sleep 5; do
        [ -f "$CANCEL" ] && rm -f "$CANCEL" && exit 0
        s="$(pomodoro-cli status --format json 2>/dev/null || true)"
        c="$(printf '%s' "$s" | jq -r '.class // empty')"
        case "$c" in
          finished) hyprlock; exit 0 ;;
          running|paused) ;;
          *) exit 0 ;;
        esac
      done
    ) >/dev/null 2>&1 &
    ;;
esac
