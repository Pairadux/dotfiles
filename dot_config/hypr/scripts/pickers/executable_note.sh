#!/bin/bash
# ICON:  
#
# note picker — pick a capture kind and hand it to the notetaker
#
# Each kind maps 1:1 to a top-level Obsidian Vault folder; the notetaker does
# the actual file creation. The folder IS the type, so nothing is tagged here.

source "$(dirname "$0")/_common.sh"

kind=$(printf '%s\n' note idea observation memory \
    | sed 's/^/  /' \
    | "${ROFI_DMENU[@]}" -p " Note" \
    | sed 's/^.*  //')
[[ -z "$kind" ]] && exit 0

exec "$(dirname "$0")/../notetaker.sh" "$kind"
