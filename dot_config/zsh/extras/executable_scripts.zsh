#!/usr/bin/env zsh

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

vault_backup() {
    git add .
    git commit -m "Vault Backup: $(date '+%Y-%m-%d %H:%M:%S')"
    git pull
    git push
}

scd() {
    cd
}

reload_aliases() {
    source $ZDOTDIR/extras/aliases
}

# JD script using fzf
jd() {
    local selected_dir
    if [ "$#" -eq 0 ]; then
        # If no arguments, show all directories
        selected_dir=$(fd -t d . ~/MEGA -d 3 | fzf --height 50% --reverse)
    else
        # If argument provided, use it as initial query
        selected_dir=$(fd -t d . ~/MEGA -d 3 | fzf --height 50% --reverse -q "$1")
    fi
    if [ -n "$selected_dir" ]; then
        cd "$selected_dir"
    else
        echo "No directory selected."
    fi
}

fcd() {
    cd
}

# JUMP {{{
# Easily jump around the file system by manually adding marks
# marks are stored as symbolic links in the directory $MARKPATH (default $HOME/.marks)
#
# jump FOO: jump to a mark named FOO
# mark FOO: create a mark named FOO
# unmark FOO: delete a mark
# marks: lists all marks
#
# export MARKPATH=$HOME/.marks
#
# jump() {
# 	local markpath="$(readlink $MARKPATH/$1)" || {echo "No such mark: $1"; return 1}
# 	builtin cd "$markpath" 2>/dev/null || {echo "Destination does not exist for mark [$1]: $markpath"; return 2}
# }
#
# mark() {
# 	if [[ $# -eq 0 || "$1" = "." ]]; then
# 		MARK=${PWD:t}
# 	else
# 		MARK="$1"
# 	fi
# 	if read -q "?Mark $PWD as ${MARK}? (y/n) "; then
# 		command mkdir -p "$MARKPATH"
# 		command ln -sfn "$PWD" "$MARKPATH/$MARK"
# 	fi
# }
#
# unmark() {
# 	LANG= command rm -i "$MARKPATH/$1"
# }
#
# marks() {
# 	local link max=0
# 	for link in $MARKPATH/{,.}*(@N); do
# 		if [[ ${#link:t} -gt $max ]]; then
# 			max=${#link:t}
# 		fi
# 	done
# 	local printf_markname_template="$(printf -- "%%%us" "$max")"
# 	for link in $MARKPATH/{,.}*(@N); do
# 		local markname="$fg[cyan]$(printf -- "$printf_markname_template" "${link:t}")$reset_color"
# 		local markpath="$fg[blue]$(readlink $link)$reset_color"
# 		printf -- "%s -> %s\n" "$markname" "$markpath"
# 	done
# }
#
# _completemarks() {
# 	reply=("${MARKPATH}"/{,.}*(@N:t))
# }
# compctl -K _completemarks jump
# compctl -K _completemarks unmark
#
# _mark_expansion() {
# 	setopt localoptions extendedglob
# 	autoload -U modify-current-argument
# 	modify-current-argument '$(readlink "$MARKPATH/$ARG" || echo "$ARG")'
# }
# zle -N _mark_expansion
# bindkey "^g" _mark_expansion# }}}
