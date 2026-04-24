#!/bin/bash
# ICON: 󰸉
#
# wallpaper picker — select and apply a wallpaper pair via hyprpaper

source "$(dirname "$0")/_common.sh"

WALLPAPER_DIR="$HOME/Cloud/Media/Pictures/wallpapers"
WALLPAPER_CONF="$HOME/.config/hypr/hyprpaper-wallpaper.conf"

# Collect folders that have a valid <name>-wallpaper/{top,bottom}.png pair
entries=()
for dir in "$WALLPAPER_DIR"/*/; do
    name=$(basename "$dir")
    pair="$dir/${name}-wallpaper"
    [[ -f "$pair/top.png" && -f "$pair/bottom.png" ]] && entries+=("$name")
done

if [[ ${#entries[@]} -eq 0 ]]; then
    notify-send "Wallpaper" "No wallpaper pairs found"
    exit 1
fi

selection=$(printf '%s\n' "${entries[@]}" | sort -f | sed 's/^/󰸉  /' | "${ROFI_DMENU[@]}" -p "󰸉 Wallpaper" | sed 's/^󰸉  //')
[[ -z "$selection" ]] && exit 0

top="$WALLPAPER_DIR/$selection/${selection}-wallpaper/top.png"
bottom="$WALLPAPER_DIR/$selection/${selection}-wallpaper/bottom.png"

# Apply live
hyprctl hyprpaper wallpaper "HDMI-A-1,$top"
hyprctl hyprpaper wallpaper "DP-2,$bottom"

# Persist for next boot
cat > "$WALLPAPER_CONF" <<EOF
\$wallpaper_top = $top
\$wallpaper_bottom = $bottom
EOF

notify-send "Wallpaper" "Applied: $selection"
