#!/bin/bash

TODAY=$(date +"%F")
TIME=$(date +"%H:%M")

FILE="$HOME/Documents/notes/$TODAY.md"

if [ ! -f "$FILE" ]; then
    echo "# Notes for $TODAY" > $FILE
fi

NEOVIDE=1 neovide -- \
    -c "call append(line('$'), ['', '## $TIME', '', ''])" \
    -c "normal! Gzz" \
    -c "startinsert" \
    "$FILE"
