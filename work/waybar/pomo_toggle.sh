#!/usr/bin/env bash
j="$(pomodoro-cli status --format json 2>/dev/null || true)"
cls="$(printf '%s' "$j" | sed -n 's/.*"class":"\([^"]*\)".*/\1/p')"
txt="$(printf '%s' "$j" | sed -n 's/.*"text":"\([^"]*\)".*/\1/p')"

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
    pomodoro-cli start --duration 25m --silent
    ;;
esac

