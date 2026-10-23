#!/bin/bash
# Toggle between the built-in primary+secondary layout and a single role-less
# external display.
#
# Toggles on whether the primary is currently up rather than on whether the
# external is connected, so it still swaps back when the external's port is
# also driving an everyday display.
#
# Needs all three declared in .chezmoidata/machines.toml: a machine without a
# primary+secondary pair plus a role-less external has nothing to switch
# between, and says so rather than half-applying a layout.

source "$(dirname "$0")/machine.sh"

if [[ "$MACHINE_MULTIHEAD" != true || -z "$MACHINE_EXTERNAL" ]]; then
    echo "monitor-switch: not applicable on $MACHINE_HOSTNAME" >&2
    exit 0
fi

if hyprctl monitors | grep -q "^Monitor $MACHINE_PRIMARY "; then
    if ! hyprctl monitors all | grep -q "^Monitor $MACHINE_EXTERNAL "; then
        echo "monitor-switch: $MACHINE_EXTERNAL is not connected" >&2
        exit 1
    fi

    # Bring the external up before the pair goes down, so Hyprland is never
    # left with no monitor at all.
    hyprctl eval "
        hl.monitor({ output = '$MACHINE_EXTERNAL', mode = 'preferred', position = '0x0', scale = 1 })
        hl.monitor({ output = '$MACHINE_PRIMARY', disabled = true })
        hl.monitor({ output = '$MACHINE_SECONDARY', disabled = true })
        hl.workspace_rule({ workspace = '1', monitor = '$MACHINE_EXTERNAL', default = true })
    "
else
    # Rules set through eval only live until a reload, which re-applies the
    # config's own monitor and workspace rules.
    hyprctl reload
fi
