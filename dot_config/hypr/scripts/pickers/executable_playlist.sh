#!/bin/bash
# ICON: 󰎈
#
# playlist picker — load an mpc playlist and start playing
#
# Assumes repeat and random are enabled globally in mpd (persisted via state_file).

source "$(dirname "$0")/_common.sh"

playlist=$(mpc lsplaylists | sed 's/^/󰎈  /' | "${ROFI_DMENU[@]}" -p "󰎈 Playlist" | sed 's/^󰎈  //')
[[ -z "$playlist" ]] && exit 0

mpc clear
mpc load "$playlist"
mpc play
notify-send "Now Playing" "$playlist"
