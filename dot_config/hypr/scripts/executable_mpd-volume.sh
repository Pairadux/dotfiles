#!/bin/bash
#
# mpd-volume.sh — nudge mpd's volume and flash the new level
#
# Usage:
#   mpd-volume.sh <delta>    a relative step as mpc takes it, e.g. +5 or -5
#
# The popup is a dunst progress bar. Sharing one stack tag makes repeated
# presses update a single notification in place rather than piling up; the
# matching [mpd-volume] rule in dunstrc keeps it out of history.

notify() {
    notify-send -a mpd -u low -t 1500 -e \
        -h string:x-dunst-stack-tag:mpd-volume \
        "$@"
}

mpc -q volume "$1"

# %volume% is " 60%" normally, "n/a" without a mixer, empty if mpd is down.
vol=$(mpc status '%volume%' 2>/dev/null)
vol=${vol//[ %]/}

if [[ ! "$vol" =~ ^[0-9]+$ ]]; then
    notify "󰝛  MPD volume" "Unavailable"
    exit 1
fi

notify -h "int:value:$vol" "󰝚  MPD volume" "$vol%"
