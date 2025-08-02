#!/bin/bash
MAIN_MONITOR="DP-2"
SECONDARY_MONITOR="HDMI-A-1" 
EXTERNAL_MONITOR="HDMI-A-2"

# Check if external monitor is connected
if hyprctl monitors | grep -q "$EXTERNAL_MONITOR"; then
    # External monitor detected - disable your current monitors
    hyprctl keyword monitor "$MAIN_MONITOR,disable"
    hyprctl keyword monitor "$SECONDARY_MONITOR,disable"
    # Enable external monitor with your preferred settings
    hyprctl keyword monitor "$EXTERNAL_MONITOR,3840x2160@30,0x0,1"
    # Set workspace 1 as default on external monitor
    hyprctl keyword workspace "1,monitor:$EXTERNAL_MONITOR,default:true"
else
    # External monitor not detected - restore your normal setup
    hyprctl keyword monitor "$MAIN_MONITOR,2560x1440@144,0x0,1"
    hyprctl keyword monitor "$SECONDARY_MONITOR,1920x1080,320x-1080,1,transform,2"
    # Restore original workspace assignments
    hyprctl keyword workspace "1,monitor:$MAIN_MONITOR,default:true,persistent:true"
    hyprctl keyword workspace "2,monitor:$SECONDARY_MONITOR,persistent:true"
fi
