#!/bin/bash

swayidle -w timeout 300 'hyprlock' timeout 600 'systemctl suspend' before-sleep 'hyprctl dispatch dpms off' &
