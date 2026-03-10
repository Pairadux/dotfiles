#!/bin/bash
#
# picker.sh — rofi-based picker dispatcher
#
# Usage:
#   picker.sh              show a meta-picker of available pickers
#   picker.sh <name>       run a specific picker directly
#
# Add new pickers by dropping scripts into the pickers/ directory.
# Each script should be a self-contained rofi workflow.
#
# Picker ideas for later:
#   - wallpaper: dir of folders with top+bottom image variants, apply via hyprpaper
#   - emoji: search + copy emoji/nerdfont glyphs via wl-copy
#   - color: trigger hyprpicker, copy hex/rgb to clipboard
#   - calc: rofi-calc plugin, result to clipboard

PICKER_DIR="$(dirname "$0")/pickers"

if [[ -n "$1" ]]; then
    script="$PICKER_DIR/$1.sh"
    if [[ -x "$script" ]]; then
        exec "$script"
    else
        notify-send "Picker" "Unknown picker: $1"
        exit 1
    fi
fi

picker=$(find "$PICKER_DIR" -name '*.sh' -executable -printf '%f\n' \
    | sed 's/\.sh$//' \
    | sort \
    | rofi -dmenu -p "picker")

[[ -n "$picker" ]] && exec "$PICKER_DIR/$picker.sh"
