#!/bin/bash

TODAY=$(date +"%F")

TEMPLATE="$CLOUD/00-09 System/00 System Management/00.05 Templates/Daily-Note-Template.md"

FILE="$CLOUD/10-19 Life Admin/19 Atomica/19.06 Daily Notes/$TODAY.md"

if [ ! -f "$FILE" ]; then
    cat "$TEMPLATE" >> "$FILE"
fi

NEOVIDE=1 neovide -- \
    -c "norm Gkkk] jI- $(date +%H%M)-  " \
    -c "norm zz" \
    -c "startinsert" \
    "$FILE"
