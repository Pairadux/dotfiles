#!/bin/bash

TODAY=$(date +"%F")

# TEMPLATE="$CLOUD/00-09 System/00 System Management/00.00 JDex/00.05 Templates/linuxQuickNoteSnippet.md"

FILE="$CLOUD/10-19 Life Admin/15 Programming & Tech/15.07 Linux Quick Notes/$TODAY.md"

if [ ! -f "$FILE" ]; then
    printf "Notes for %s" "$TODAY" > "$FILE"
    # cat "$TEMPLATE" >> "$FILE"
fi

NEOVIDE=1 neovide -- \
    -c "norm Go" \
    -c "norm Go#### $(date +%T)" \
    -c "norm G2o" \
    -c "norm zz" \
    -c "startinsert" \
    "$FILE"
