#!/usr/bin/env zsh

jd() {
    local dir
    dir=$(fd -t d "^$1.*$" ~/Documents/SyncFolder -d 3 | head -n 1)
    if [ -n "$dir" ]; then
        builtin cd "$dir" 2>/dev/null || echo "Cannot change to directory: $dir"
    else
        echo "No matching directory found for $1"
    fi
}

# _completejd() {
#     local prefix="$1"
#     local completions
#
#     if [[ "$prefix" =~ ^[0-9]{2}$ ]]; then
#         # If two digits are entered, complete with matching xx.yy patterns
#         completions=($(fd -t d "^$prefix\.[0-9]{2}" ~/Documents/SyncFolder -d 3 | sed -E 's|.*/([0-9]{2}\.[0-9]{2}).*|\1|' | sort -u))
#     elif [[ "$prefix" =~ ^[0-9]$ ]]; then
#         # If one digit is entered, complete with matching xy patterns where x is the entered digit
#         completions=($(fd -t d "^$prefix[0-9]-" ~/Documents/SyncFolder -d 2 | sed -E 's|.*/([0-9]{2})-.*|\1|' | sort -u))
#     else
#         # If no digits are entered, show all top-level categories
#         completions=($(fd -t d "^[0-9]{2}-" ~/Documents/SyncFolder -d 2 | sed -E 's|.*/([0-9]{2})-.*|\1|' | sort -u))
#     fi
#
#     reply=("${completions[@]}")
# }
#
# compctl -K _completejd jd
