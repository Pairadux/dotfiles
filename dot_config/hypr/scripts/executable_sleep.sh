#!/bin/bash

# swayidle -w timeout 300 'hyprlock' \
#             timeout 600 'hyprctl dispatch dpms off' \
#             resume 'hyprctl dispatch dpms on' \
#             timeout 900 'systemctl suspend' \
#             before-sleep 'hyprlock' &

swayidle -w timeout 300 'hyprlock' \
            timeout 600 'systemctl suspend' \
            before-sleep 'hyprlock' &
