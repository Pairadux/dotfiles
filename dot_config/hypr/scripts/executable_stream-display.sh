#!/bin/bash
#
# stream-display.sh — swap the physical displays for one virtual display while
# Sunshine streams, so the Moonlight client gets the desktop at its own
# resolution and nothing is left lit at the desk.
#
# Usage:
#   stream-display.sh start    create the virtual output, disable the rest
#   stream-display.sh stop     restore the configured layout, drop the output
#
# Meant for Sunshine's global prep command (do = start, undo = stop), which
# supplies the client's mode in SUNSHINE_CLIENT_WIDTH/HEIGHT/FPS. Sunshine has to
# capture with `capture = wlr` and no `output_name`: KMS cannot see a headless
# output, and once the physical displays are off the virtual one is the only
# output, so Sunshine's default of the first output is the right one.

OUTPUT="STREAM"

# Sunshine runs as a systemd user service, which never gets
# HYPRLAND_INSTANCE_SIGNATURE, so address the running instance explicitly.
hypr() {
    hyprctl --instance 0 "$@"
}

case "$1" in
    start)
        mode="${SUNSHINE_CLIENT_WIDTH:-1920}x${SUNSHINE_CLIENT_HEIGHT:-1080}@${SUNSHINE_CLIENT_FPS:-60}"

        # A session that ended without its undo leaves the output behind.
        hypr monitors | grep -q "^Monitor $OUTPUT " || hypr output create headless "$OUTPUT"
        hypr eval "hl.monitor({ output = '$OUTPUT', mode = '$mode', position = 'auto', scale = 1 })"

        # Disable the rest only once the virtual output is up, so Hyprland is
        # never left with no monitor at all.
        hypr eval "for _, m in ipairs(hl.get_monitors()) do if m.name ~= '$OUTPUT' then hl.monitor({ output = m.name, disabled = true }) end end"
        ;;
    stop)
        # The rules set above only live until a reload, which re-applies the
        # config's own monitor rules and so re-enables the physical displays.
        hypr reload

        # Same ordering concern as start: wait for a physical display to come
        # back before removing the only one that is up.
        for _ in {1..20}; do
            hypr monitors | grep "^Monitor " | grep -qv "^Monitor $OUTPUT " && break
            sleep 0.1
        done
        hypr output remove "$OUTPUT"
        ;;
    *)
        echo "usage: $(basename "$0") start|stop" >&2
        exit 1
        ;;
esac
