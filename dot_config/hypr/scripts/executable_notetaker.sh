#!/bin/bash

TODAY=$(date +"%F")
YESTERDAY=$(date -d "yesterday" +"%F")
TOMORROW=$(date -d "tomorrow" +"%F")

TEMPLATE="$HOME/MEGA/00-09 System/00 System Management/00.00 JDex/00.05 Templates/dailySnippet.md"

FILE="$HOME/MEGA/00-09 System/00 System Management/00.00 JDex/00.06 Daily Notes/$(date +%F).md"

if [ ! -f "$FILE" ]; then
    sed -e "s/<% tp.date.now(\"YYYY-MM-DD\") %>/$TODAY/g" \
        -e "s/<% tp.date.now(\"YYYY-MM-DD\", -1) %>/$YESTERDAY/g" \
        -e "s/<% tp.date.now(\"YYYY-MM-DD\", 1) %>/$TOMORROW/g" \
        "$TEMPLATE" > "$FILE"
fi

NEOVIDE=1 neovide -- \
    -c "norm Go | norm Go#### $(date +%T) | norm G2o | norm zz | startinsert" \ 
    "$FILE"
