#!/bin/bash
#
# notetaker.sh — atomic capture into the Obsidian Vault
#
# Usage:
#   notetaker.sh [kind]    kind is one of Note|Idea|Observation|Memory (default: Note)
#
# Every capture is its own markdown file. The kind selects the destination
# folder; the folder IS the type, so no `type` property is written. Output
# matches the QuickAdd "Capture" template so Bases treat scripted and in-app
# captures the same. Obsidian does not need to be running.

VAULT="$HOME/Vault"
kind="${1:-Note}"

case "$kind" in
    Note)        dir="$VAULT/Notes" ;;
    Idea)        dir="$VAULT/Ideas" ;;
    Observation) dir="$VAULT/Observations" ;;
    Memory)      dir="$VAULT/Memories" ;;
    *) notify-send "Notetaker" "Unknown kind: $kind"; exit 1 ;;
esac

# Notes and observations are timestamped; ideas and memories are named by hand.
case "$kind" in
    Idea|Memory)
        name=$(rofi -dmenu -l 0 -theme-str 'listview { enabled: false; }' -p " ${kind^} name" </dev/null)
        [[ -z "$name" ]] && exit 0
        ;;
    *)
        name=$(date +"%Y-%m-%dT%H%M%S")
        ;;
esac

mkdir -p "$dir"

# Never clobber an existing capture (e.g. two stamps in the same second);
# append an incrementing suffix instead.
file="$dir/$name.md"
n=1
while [[ -e "$file" ]]; do
    file="$dir/$name $n.md"
    ((n++))
done

# Single `created` property (second precision; the colon is safe inside
# frontmatter), then a blank line and empty body for the cursor to land in.
printf '%s\n' '---' "created: $(date +"%Y-%m-%dT%H:%M:%S")" '---' '' > "$file"

ghostty --title=Notetaker -e nvim \
    -c "normal! G" \
    -c "startinsert" \
    "$file"
