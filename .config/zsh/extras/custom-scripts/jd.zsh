#!/usr/bin/env zsh

# JD script not using fzf
# jd() {
#     local dir
#     dir=$(fd -t d "^$1.*$" ~/Documents/SyncFolder -d 3 | head -n 1)
#     if [ -n "$dir" ]; then
#         builtin cd "$dir" 2>/dev/null || echo "Cannot change to directory: $dir"
#     else
#         echo "No matching directory found for $1"
#     fi
# }

# JD script using fzf
jd() {
    local selected_dir

    if [ "$#" -eq 0 ]; then
        # If no arguments, show all directories
        selected_dir=$(fd -t d . ~/Documents/SyncFolder -d 3 | fzf --height 50% --reverse)
    else
        # If argument provided, use it as initial query
        selected_dir=$(fd -t d . ~/Documents/SyncFolder -d 3 | fzf --height 50% --reverse -q "$1")
    fi

    if [ -n "$selected_dir" ]; then
        cd "$selected_dir"
    else
        echo "No directory selected."
    fi
}
