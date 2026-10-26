#!/bin/bash
#
# snap-step.sh — step the volume or backlight by a fixed percentage, landing
# on multiples of it. waybar's built-in scroll adds the step to whatever the
# level already is, so a level knocked off the grid (pavucontrol, an app, the
# rounding of a 509-unit Apple backlight) never gets back on it.
#
# Usage:
#   snap-step.sh volume STEP        STEP is signed: 5 steps up, -5 steps down
#   snap-step.sh brightness STEP

target="$1"
step="$2"
size="${step#-}"

# A fast flick fires several of these at once; serialize the read-modify-write
# so no step is lost.
exec 9>"$XDG_RUNTIME_DIR/waybar-snap-step.lock"
flock 9

case "$target" in
    volume)
        current=$(pactl get-sink-volume @DEFAULT_SINK@ | awk -F/ 'NR == 1 { print $2 + 0 }')
        ;;
    brightness)
        backlights=(/sys/class/backlight/*)
        backlight="${backlights[0]}"
        max=$(<"$backlight/max_brightness")
        current=$(( ($(<"$backlight/brightness") * 100 + max / 2) / max ))
        ;;
    *)
        echo "usage: $(basename "$0") volume|brightness STEP" >&2
        exit 1
        ;;
esac

# Snap onto the grid in the direction of travel, then take the step.
if (( step > 0 )); then
    next=$(( current / size * size + size ))
else
    next=$(( (current + size - 1) / size * size - size ))
fi
next=$(( next > 100 ? 100 : next < 0 ? 0 : next ))

case "$target" in
    volume)
        pactl set-sink-volume @DEFAULT_SINK@ "$next%"
        ;;
    brightness)
        # logind does the write, so no udev rule or video group is needed. The
        # raw value rounds to the nearest unit, which waybar rounds back to
        # exactly $next%.
        busctl call org.freedesktop.login1 /org/freedesktop/login1/session/auto \
            org.freedesktop.login1.Session SetBrightness ssu \
            backlight "$(basename "$backlight")" $(( (next * max + 50) / 100 ))
        ;;
esac
