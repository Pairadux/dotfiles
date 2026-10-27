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
#
# The layout itself is applied by hyprland.lua, which reads STATE on every
# reload: a reload mid-stream then keeps the stream instead of re-enabling the
# physical displays, and this script only has to set or clear the state.

OUTPUT="STREAM"
STATE="$XDG_RUNTIME_DIR/stream-display.lua"

# Sunshine runs as a systemd user service, which never gets
# HYPRLAND_INSTANCE_SIGNATURE, so address the running instance explicitly.
hypr() {
    hyprctl --instance 0 "$@"
}

# Scale a WIDTH HEIGHT mode to about 1080 logical pixels tall, so a high-DPI
# client gets the text size a 1080p one does. Hyprland only takes a scale that
# divides the mode into whole logical pixels, and otherwise swaps in the
# nearest one behind a warning, so run that same 1/120-step search here.
client_scale() {
    awk -v w="$1" -v h="$2" '
        function clean(n) { return n >= 120 && w / (n / 120) == int(w / (n / 120)) && h / (n / 120) == int(h / (n / 120)) }
        BEGIN {
            base = int(h / 1080 * 120 + 0.5)
            if (base < 120) base = 120
            for (i = 0; i < 90; i++) {
                if (clean(base + i)) { print (base + i) / 120; exit }
                if (clean(base - i)) { print (base - i) / 120; exit }
            }
            print 1
        }'
}

case "$1" in
    start)
        width="${SUNSHINE_CLIENT_WIDTH:-1920}"
        height="${SUNSHINE_CLIENT_HEIGHT:-1080}"
        mode="${width}x${height}@${SUNSHINE_CLIENT_FPS:-60}"
        scale=$(client_scale "$width" "$height")

        # A session that ended without its undo leaves the output behind.
        hypr monitors | grep -q "^Monitor $OUTPUT " || hypr output create headless "$OUTPUT"

        # The config only applies the layout once it sees the virtual output, so
        # wait for it before reloading. That also means Hyprland is never left
        # with no monitor at all.
        for _ in {1..20}; do
            hypr monitors | grep -q "^Monitor $OUTPUT " && break
            sleep 0.1
        done
        echo "return { output = '$OUTPUT', mode = '$mode', scale = $scale }" > "$STATE"
        hypr reload

        # hyprpaper only covers the outputs its config names, so hand the
        # virtual one the primary display's wallpaper: the bottom slice of a
        # stacked pair, or the whole image on a single display. It rejects an
        # output it has not seen yet, so retry until the new one reaches it.
        wallpaper=$(sed -nE 's/^\$wallpaper_(bottom|main) = //p' "$HOME/.config/hypr/hyprpaper-wallpaper.conf")
        for _ in {1..20}; do
            hypr hyprpaper wallpaper "$OUTPUT,$wallpaper" && break
            sleep 0.1
        done
        ;;
    stop)
        rm -f "$STATE"
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
