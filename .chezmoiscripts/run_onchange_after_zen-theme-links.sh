#!/bin/sh
# Links the managed Zen files into every Zen profile, since profile folder names differ per
# install. A real file at either path is left alone and reported. This runs when this file
# changes, so a profile created later isn't linked until then.
set -eu

files="$HOME/.config/zen-theme"

link() {
    if [ -e "$2" ] && [ ! -L "$2" ]; then
        echo "zen-theme: left $2 alone, it's a real file" >&2
    else
        ln -sfn "$1" "$2"
    fi
}

for root in "$HOME/.zen" "$HOME/.config/zen"; do
    [ -f "$root/profiles.ini" ] || continue
    sed -n 's/^Path=//p' "$root/profiles.ini" | while IFS= read -r path; do
        [ -d "$root/$path" ] || continue
        mkdir -p "$root/$path/chrome"
        link "$files/userChrome.css" "$root/$path/chrome/userChrome.css"
        link "$files/user.js" "$root/$path/user.js"
    done
done
