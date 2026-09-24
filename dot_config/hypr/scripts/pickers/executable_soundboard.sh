#!/bin/bash
# ICON: 󰐹
#
# soundboard picker — play any pwsp hotkey slot by name.
#
# Lists the same slots the soundboard keys fire, bound or not, so a sound with no
# key left is still one search away. A file only shows up once pwsp has a slot
# for it. The reply to `get hotkeys` is `true : {json}`; only the slot names are
# needed, so jq reads them from the JSON half.

source "$(dirname "$0")/_common.sh"

slots=$(pwsp-cli get hotkeys 2>/dev/null | sed 's/^[^{]*//' | jq -r '.slots[].slot' 2>/dev/null)

if [[ -z "$slots" ]]; then
    notify-send "Soundboard" "No pwsp slots found — is the daemon running?"
    exit 1
fi

selection=$(sort -f <<< "$slots" | "${ROFI_DMENU[@]}" -no-custom -p "󰐹 Sound")
[[ -z "$selection" ]] && exit 0

pwsp-cli action play-hotkey "$selection"
