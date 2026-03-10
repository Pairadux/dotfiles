#!/bin/bash
# ICON: 󰅇
#
# clipboard picker — select from clipboard history
#
# Usage:
#   clipboard.sh          show all entries (text + images)
#   clipboard.sh text     show text entries only
#   clipboard.sh image    show image entries only

SELF="$(realpath "$0")"
tmp_dir="/tmp/cliphist"

# --- rofi script-mode callbacks ---
# rofi sets ROFI_RETV when running in script mode
if [[ -n "$ROFI_RETV" ]]; then
    # user selected an entry — decode from original via ROFI_INFO and copy
    if [[ "$ROFI_RETV" -gt 0 && -n "$ROFI_INFO" ]]; then
        cliphist decode <<<"$ROFI_INFO" | wl-copy
        exit
    fi

    # first call — generate the entry list
    rm -rf "$tmp_dir"
    mkdir -p "$tmp_dir"

    read -r -d '' prog <<'GAWK'
/^[0-9]+\s<meta http-equiv=/ { next }
match($0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
    if (ENVIRON["CLIPHIST_FILTER"] == "text") next
    system("echo " grp[1] "\\\t | cliphist decode >" ENVIRON["TMP"] "/" grp[1] "." grp[3])
    print $0 "\0icon\x1f" ENVIRON["TMP"] "/" grp[1] "." grp[3] "\x1finfo\x1f" $0
    next
}
{
    if (ENVIRON["CLIPHIST_FILTER"] == "image") next
    orig = $0

    # extract text content after the id+tab
    idx = index($0, "\t")
    text = substr($0, idx + 1)

    # escape pango special chars
    gsub(/&/, "\\&amp;", text)
    gsub(/</, "\\&lt;", text)
    gsub(/>/, "\\&gt;", text)

    # word-wrap at ~80 chars, max 3 lines
    wrapped = ""
    line = ""
    lines = 1
    n = split(text, words, " ")
    for (i = 1; i <= n && lines <= 3; i++) {
        test = (line == "" ? words[i] : line " " words[i])
        if (length(test) > 80 && line != "") {
            wrapped = wrapped (wrapped == "" ? "" : "&#10;") line
            line = words[i]
            lines++
        } else {
            line = test
        }
    }
    if (lines <= 3 && line != "")
        wrapped = wrapped (wrapped == "" ? "" : "&#10;") line
    if (i <= n) wrapped = wrapped "…"

    print wrapped "\0info\x1f" orig
}
GAWK

    TMP="$tmp_dir" cliphist list -preview-width 300 | gawk "$prog"
    exit
fi

# --- initial launch ---
export CLIPHIST_FILTER="${1:-all}"
rofi -modi "clipboard:$SELF" -show clipboard -show-icons -markup-rows -eh 3
