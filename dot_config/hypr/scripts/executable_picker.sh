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
source "$PICKER_DIR/_common.sh"

if [[ -n "$1" ]]; then
    script="$PICKER_DIR/$1.sh"
    if [[ -x "$script" ]]; then
        exec "$script" "${@:2}"
    else
        notify-send "Picker" "Unknown picker: $1"
        exit 1
    fi
fi

# Build menu entries with icons from each picker's # ICON: comment
entries=""
for script in "$PICKER_DIR"/*.sh; do
    [[ -x "$script" ]] || continue
    name=$(basename "$script" .sh)
    [[ "$name" == _* ]] && continue
    label=$(echo "$name" | sed 's/\b\(.\)/\u\1/g; s/-/ /g')
    icon=$(grep -m1 '^# ICON:' "$script" | sed 's/^# ICON: *//')
    if [[ -n "$icon" ]]; then
        entries+="$icon  $label"$'\n'
    else
        entries+="$label"$'\n'
    fi
done

selection=$(printf '%s' "$entries" | sort -f -t' ' -k2 | "${ROFI_DMENU[@]}" -p " Picker")
[[ -z "$selection" ]] && exit 0

# Strip icon prefix and convert label back to filename
picker=$(echo "$selection" | sed 's/^.*  //; s/ /-/g' | tr '[:upper:]' '[:lower:]')
exec "$PICKER_DIR/$picker.sh"
