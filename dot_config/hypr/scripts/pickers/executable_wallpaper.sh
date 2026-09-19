#!/bin/bash
# ICON: 󰸉
#
# wallpaper picker — select and apply a wallpaper via hyprpaper.
#
# A machine with a real primary+secondary pair uses the top/bottom slices under
# <name>-wallpaper/, cut for that stacked layout by ~/.bin/wallpaper-ctl. A
# single display uses the unsliced <name>-wallpaper.png instead.

source "$(dirname "$0")/_common.sh"
source "$(dirname "$0")/../machine.sh"

WALLPAPER_CONF="$HOME/.config/hypr/hyprpaper-wallpaper.conf"

# Collect folders carrying the sources this machine's layout needs.
entries=()
for dir in "$MACHINE_WALLPAPER_DIR"/*/; do
    name=$(basename "$dir")
    if [[ "$MACHINE_MULTIHEAD" == true ]]; then
        pair="$dir/${name}-wallpaper"
        [[ -f "$pair/top.png" && -f "$pair/bottom.png" ]] && entries+=("$name")
    else
        [[ -f "$dir/${name}-wallpaper.png" ]] && entries+=("$name")
    fi
done

if [[ ${#entries[@]} -eq 0 ]]; then
    notify-send "Wallpaper" "No wallpapers found"
    exit 1
fi

selection=$(printf '%s\n' "${entries[@]}" | sort -f | sed 's/^/󰸉  /' | "${ROFI_DMENU[@]}" -p "󰸉 Wallpaper" | sed 's/^󰸉  //')
[[ -z "$selection" ]] && exit 0

if [[ "$MACHINE_MULTIHEAD" == true ]]; then
    top="$MACHINE_WALLPAPER_DIR/$selection/${selection}-wallpaper/top.png"
    bottom="$MACHINE_WALLPAPER_DIR/$selection/${selection}-wallpaper/bottom.png"

    # Apply live
    hyprctl hyprpaper wallpaper "$MACHINE_SECONDARY,$top"
    hyprctl hyprpaper wallpaper "$MACHINE_PRIMARY,$bottom"

    # Persist for next boot
    cat > "$WALLPAPER_CONF" <<EOF
\$wallpaper_top = $top
\$wallpaper_bottom = $bottom
EOF
else
    main="$MACHINE_WALLPAPER_DIR/$selection/${selection}-wallpaper.png"

    # Apply live
    hyprctl hyprpaper wallpaper "$MACHINE_PRIMARY,$main"

    # Persist for next boot
    cat > "$WALLPAPER_CONF" <<EOF
\$wallpaper_main = $main
EOF
fi

notify-send "Wallpaper" "Applied: $selection"
