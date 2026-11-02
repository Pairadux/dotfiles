#!/bin/bash
# ICON: 󰧔
#
# clip picker — make a cassette clip the current one, which F22 trims and F24
# plays.
#
# `cassette list -l` prints each clip's path, a tab, and the label the tray
# shows (● marks the current clip), oldest first. rofi only sees the labels,
# newest first, and -format i hands back the chosen line's index, which maps
# back to its path.

source "$(dirname "$0")/_common.sh"

if ! listing=$(cassette list -l 2>&1); then
    notify-send -u critical -a cassette "Clip picker failed" "$listing"
    exit 1
fi
if [[ -z "$listing" ]]; then
    notify-send -a cassette "Clip picker" "No clips saved yet"
    exit 0
fi

mapfile -t lines < <(tac <<< "$listing")
i=$(printf '%s\n' "${lines[@]#*$'\t'}" | "${ROFI_DMENU[@]}" -no-custom -format i -p "󰧔 Clip")
[[ -z "$i" ]] && exit 0

if ! out=$(cassette current "${lines[i]%%$'\t'*}" 2>&1); then
    notify-send -u critical -a cassette "Clip picker failed" "$out"
    exit 1
fi
