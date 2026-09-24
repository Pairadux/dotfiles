#!/bin/bash
#
# binds-show.sh — keybind cheat sheet in rofi
#
# Usage:
#   binds-show.sh    list Hyprland's described binds; Esc closes
#
# Bound to SUPER + / in hyprland.lua. Read from `hyprctl binds` rather than the
# config file, so the sheet is always the keymap Hyprland is running. Only binds
# with a "Group: what it does" description are listed; groups and rows keep the
# order hyprland.lua declares them in, which is kept sorted most-used first.
# Consecutive rows in a group with the same description collapse into one, so
# H/L/K/J or 1..0 read as a single line. Rofi's font is monospace, so padding
# with spaces is enough to line the columns up.
#
# The shared rofi theme is a launcher: 700px wide, seven rows. Here the point is
# to see everything at once, so the sheet overrides it with two columns tall
# enough to hold every row, filled top to bottom so a group reads down the page.
# The columns split at the group boundary nearest the middle, with the left one
# padded out, so no group is ever broken across the two.

source "$(dirname -- "$(readlink -f -- "$0")")/pickers/_common.sh"

# jq has no bitwise operators, so each modifier bit is tested arithmetically.
rows=$(hyprctl binds -j | jq -r '
    .[]
    | select(.has_description)
    | .modmask as $m
    | (.description | capture("^(?<group>[^:]+):\\s*(?<text>.+)$")) as $d
    | ([[64, "SUPER"], [4, "CTRL"], [8, "ALT"], [1, "SHIFT"]]
        | map(select((($m / .[0]) | floor) % 2 == 1) | .[1])
        | join(" + ")) as $mods
    | [$d.group, $mods, .key, $d.text]
    | @tsv
')

if [[ -z "$rows" ]]; then
    notify-send "Keybinds" "No described binds found"
    exit 1
fi

sheet=$(awk -F'\t' '
    function esc(s) {
        gsub(/&/, "\\&amp;", s); gsub(/</, "\\&lt;", s); gsub(/>/, "\\&gt;", s)
        return s
    }
    function pretty(k) {
        if (k == "slash") return "/"
        if (k == "minus") return "-"
        if (k == "apostrophe") return "\047"
        if (k == "mouse:272") return "LMB"
        if (k == "mouse:273") return "RMB"
        if (length(k) > 1) return toupper(substr(k, 1, 1)) tolower(substr(k, 2))
        return k
    }
    # Four keys or fewer are spelled out; a longer run is a range, first..last.
    function flush(   keys, chord) {
        if (n == 0) return
        keys = (n <= 4) ? joined : first ".." last
        chord = (mods == "") ? keys : mods " + " keys
        printf "  %-26s %s\n", esc(chord), esc(text)
        n = 0
    }
    {
        if ($1 != group) {
            flush()
            if (group != "") print ""
            printf "<b>%s</b>\n", esc(toupper($1))
            group = $1
        }
        if (n > 0 && $2 == mods && $4 == text) {
            joined = joined "/" pretty($3); last = pretty($3); n++
            next
        }
        flush()
        mods = $2; text = $4
        first = last = joined = pretty($3); n = 1
    }
    END { flush() }
' <<< "$rows")

mapfile -t entries <<< "$sheet"

# Groups are separated by a blank row; the right column starts on the header
# after the one that leaves the taller column shortest.
split=$(( ${#entries[@]} + 1 )) lines=${#entries[@]}
for i in "${!entries[@]}"; do
    [[ -z "${entries[i]}" ]] || continue
    right=$(( ${#entries[@]} - i - 1 ))
    tallest=$(( i > right ? i : right ))
    if (( tallest < lines )); then
        split=$(( i + 1 )) lines=$tallest
    fi
done

left=("${entries[@]:0:split-1}")
while (( ${#left[@]} < lines )); do left+=(""); done
sheet=$(printf '%s\n' "${left[@]}" "${entries[@]:split}")

"${ROFI_DMENU[@]}" -markup-rows -no-custom -p " Keybinds" \
    -theme-str "window { width: 1300px; } listview { columns: 2; lines: $lines; flow: vertical; }" \
    <<< "$sheet" > /dev/null
