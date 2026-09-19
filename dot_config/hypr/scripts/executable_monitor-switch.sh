#!/bin/bash
# Swap between the built-in primary+secondary layout and a single role-less
# external display.
#
# Needs all three declared in .chezmoidata/machines.toml: a machine without a
# primary+secondary pair plus a role-less external has nothing to switch
# between, and says so rather than half-applying a layout.

source "$(dirname "$0")/machine.sh"

if [[ "$MACHINE_MULTIHEAD" != true || -z "$MACHINE_EXTERNAL" ]]; then
    echo "monitor-switch: not applicable on $MACHINE_HOSTNAME" >&2
    exit 0
fi

if hyprctl monitors | grep -q "$MACHINE_EXTERNAL"; then
    # External monitor detected - disable the built-in pair
    hyprctl keyword monitor "$MACHINE_PRIMARY,disable"
    hyprctl keyword monitor "$MACHINE_SECONDARY,disable"
    # Enable external monitor with its preferred settings
    hyprctl keyword monitor "$MACHINE_EXTERNAL,preferred,0x0,1"
    # Set workspace 1 as default on external monitor
    hyprctl keyword workspace "1,monitor:$MACHINE_EXTERNAL,default:true"
else
    # External monitor not detected - restore the normal setup
    hyprctl keyword monitor "$MACHINE_PRIMARY,$MACHINE_PRIMARY_MODE,$MACHINE_PRIMARY_POSITION,$MACHINE_PRIMARY_SCALE"

    secondary="$MACHINE_SECONDARY,$MACHINE_SECONDARY_MODE,$MACHINE_SECONDARY_POSITION,$MACHINE_SECONDARY_SCALE"
    [[ -n "$MACHINE_SECONDARY_TRANSFORM" ]] && secondary="$secondary,transform,$MACHINE_SECONDARY_TRANSFORM"
    hyprctl keyword monitor "$secondary"

    # Restore original workspace assignments
    hyprctl keyword workspace "1,monitor:$MACHINE_PRIMARY,default:true,persistent:true"
    hyprctl keyword workspace "2,monitor:$MACHINE_SECONDARY,persistent:true"
fi
