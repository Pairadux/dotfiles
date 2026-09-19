#!/bin/bash
#
# soundboard-show.sh — toggle the soundboard cheat sheet on screen
#
# Usage:
#   soundboard-show.sh    show the sheet, or dismiss it if already up
#
# Bound to SUPER + ? in hyprland.lua. The sheet is redrawn on every press rather
# than read from the copy chezmoi deploys: drawing costs milliseconds, so the
# picture is always the keymap Hyprland is running, never the one committed last.
#
# feh decodes SVG through imlib2's librsvg loader, so nothing is rasterised
# first. The viewer's pid is recorded rather than matched with `pkill -f`: that
# pattern also matches any other command line merely mentioning it, and the cost
# of a wrong match is killing something unrelated.

TITLE="Soundboard Cheat Sheet"
SHEET="${XDG_CACHE_HOME:-$HOME/.cache}/soundboard.svg"
PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/soundboard-sheet.pid"
here="$(dirname -- "$(readlink -f -- "$0")")"

# A pid can be recycled, so only ever signal one that is still a live feh.
pid="$(cat "$PIDFILE" 2>/dev/null)"
if [[ -n "$pid" && "$(ps -p "$pid" -o comm= 2>/dev/null)" == "feh" ]]; then
    kill "$pid"
    rm -f "$PIDFILE"
    exit 0
fi

mkdir -p -- "$(dirname -- "$SHEET")"
if ! lua "$here/soundboard-cheatsheet.lua" -o "$SHEET"; then
    notify-send "Soundboard" "Could not draw the cheat sheet"
    exit 1
fi

# exec keeps this pid, so the file ends up naming feh itself.
echo $$ > "$PIDFILE"
exec feh --title "$TITLE" --scale-down --auto-zoom --image-bg "#0f172a" "$SHEET"
