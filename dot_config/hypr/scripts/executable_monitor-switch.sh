#!/bin/bash
EXTERNAL_MONITOR="YOUR-EXTERNAL-MONITOR-NAME"  # Replace with actual name

# Check if external monitor is connected
if hyprctl monitors | grep -q "$EXTERNAL_MONITOR"; then
    # External monitor detected - disable your current monitors
    hyprctl keyword monitor "DP-2,disable"
    hyprctl keyword monitor "HDMI-A-1,disable"
    # Enable external monitor with your preferred settings
    hyprctl keyword monitor "$EXTERNAL_MONITOR,2560x1440@60,0x0,1"
else
    # External monitor not detected - restore your normal setup
    hyprctl keyword monitor "DP-2,2560x1440@144,0x0,1"
    hyprctl keyword monitor "HDMI-A-1,1920x1080,320x-1080,1"
fi
