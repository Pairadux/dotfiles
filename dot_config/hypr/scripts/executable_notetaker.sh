#!/bin/bash

noteFilename="$HOME/MEGA/00-09 System/00 System Management/00.00 JDex/00.07 Linux Quick Notes/$(date +%F).md"

if [ ! -f "$noteFilename" ]; then
    echo "## Notes for $(date +%F)" > "$noteFilename"
fi

NEOVIDE=1 neovide -- \
    -c "norm Go" \
    -c "norm Go#### $(date +%T)" \
    -c "norm G2o" \
    -c "norm zz" \
    -c "startinsert" \
    "$noteFilename"
