#!/bin/bash
# ICON: ⏻
#
# power picker — lock, suspend, log out, reboot or shut down.

source "$(dirname "$0")/_common.sh"

# Fixed order, mildest first, so the destructive entries sit furthest from the
# top of the list.
selection=$(printf '%s\n' "󰌾  Lock" "󰤄  Suspend" "󰍃  Log out" "󰜉  Reboot" "⏻  Shut down" \
    | "${ROFI_DMENU[@]}" -p "⏻ Power")

case "$selection" in
    *Lock)        hyprlock ;;
    *Suspend)     systemctl suspend ;;
    *"Log out")   hyprctl eval "hl.dispatch(hl.dsp.exit())" ;;
    *Reboot)      systemctl reboot ;;
    *"Shut down") systemctl poweroff ;;
esac
