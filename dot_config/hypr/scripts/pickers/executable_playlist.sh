#!/bin/bash
# ICON: 󰎈
#
# playlist picker — load an mpc playlist and play it shuffled on loop
#
# Forces random + repeat on every load rather than trusting mpd's persisted state.
# With both enabled, mpd reshuffles the order each time the playlist wraps.

source "$(dirname "$0")/_common.sh"

playlist=$(mpc lsplaylists | sort -f | sed 's/^/󰎈  /' | "${ROFI_DMENU[@]}" -p "󰎈 Playlist" | sed 's/^󰎈  //')
[[ -z "$playlist" ]] && exit 0

mpc -q random on
mpc -q repeat on
mpc clear
mpc load "$playlist"
mpc play
notify-send "Now Playing" "$playlist"
