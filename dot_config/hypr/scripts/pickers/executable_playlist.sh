#!/bin/bash
#
# playlist picker — load an mpc playlist and start playing
#
# Assumes repeat and random are enabled globally in mpd (persisted via state_file).

playlist=$(mpc lsplaylists | rofi -dmenu -p "playlist")
[[ -z "$playlist" ]] && exit 0

mpc clear
mpc load "$playlist"
mpc play
notify-send "Now Playing" "$playlist"
