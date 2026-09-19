#!/usr/bin/env zsh

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# push branch, create PR, merge, switch to main, pull
prship() {
    git push -u origin HEAD && \
        gh pr create --fill && \
        gh pr merge --rebase --delete-branch && \
        git switch main && \
        git pull origin main
    }

# fuzzy cd
fcd() {
    cd $(fd -t d | fzf)
}

scd() {
    cd
}

reload_aliases() {
    source $ZDOTDIR/extras/aliases
}

reload_comp() {
    rm -f $XDG_CACHE_HOME/zsh/zcompdump
    autoload -U compinit; compinit
}

# JD script using fzf
jd() {
    local selected_dir base_dir fd_cmd
    base_dir=~/Cloud
    fd_cmd=(fd -t d '\d\d\.\d\d' -E "00.00*" --base-directory "$base_dir")
    if [ "$#" -eq 0 ]; then
        # If no arguments, show all directories
        # selected_dir=$(fd -t d . ~/MEGA -d 3 | fzf --height 50% --reverse)
        selected_dir=$("${fd_cmd[@]}" | fzf -e)
    else
        # If argument provided, use it as initial query
        # selected_dir=$(fd -t d . ~/MEGA -d 3 | fzf --height 50% --reverse -q "$1")
        selected_dir=$("${fd_cmd[@]}" | fzf -e -q "$1")
    fi
    if [ -n "$selected_dir" ]; then
        cd "$base_dir/$selected_dir"
    else
        echo "No directory selected."
    fi
}

man() {
    # Optionally, unset LESSOPEN if it's interfering with groff formatting
    local OLD_LESSOPEN="$LESSOPEN"
    unset LESSOPEN

    # Set ANSI formatting specifically for man pages
    LESS_TERMCAP_md=$'\e[01;31m' \
        LESS_TERMCAP_me=$'\e[0m' \
        LESS_TERMCAP_se=$'\e[0m' \
        LESS_TERMCAP_so=$'\e[01;44;33m' \
        LESS_TERMCAP_ue=$'\e[0m' \
        LESS_TERMCAP_us=$'\e[01;32m' \
        command man "$@"

        # Restore previous LESSOPEN if needed
        export LESSOPEN="$OLD_LESSOPEN"
    }

pokemon() {
    pokemon-colorscripts --no-title -b -rn gengar,lugia,articuno,zapdos,giratina,scyther,scizor,bisharp,garchomp,greninja,samurott,moltres,kricketune,lucario,absol,venusaur,blastoise,zoroark
}

# yt-dlp: download mp3 (use --raw to skip metadata/thumbnail)
ytdl() {
    local raw=false
    local url=""

    for arg in "$@"; do
        case "$arg" in
            --raw) raw=true ;;
            *) url="$arg" ;;
        esac
    done

    if [[ -z "$url" ]]; then
        echo "Usage: ytdl [--raw] <url>"
        return 1
    fi

    local -a cookies_opt
    case "$OSTYPE" in
        darwin*) cookies_opt=(--cookies ~/.youtube-cookies.txt) ;;
        linux*)  cookies_opt=(--cookies-from-browser "firefox:$HOME/.zen/bju8d2g9.Default (alpha)") ;;
        *) echo "ytdl: unsupported OS: $OSTYPE"; return 1 ;;
    esac
    local output_dir="$PWD"
    local archive_file="${output_dir}/.ytdl-archive.txt"
    local opts=(--extract-audio --audio-format mp3 --audio-quality 0
        "${cookies_opt[@]}"
        --download-archive "$archive_file"
        -o "${output_dir}/%(title)s.%(ext)s")

    if [[ "$raw" = false ]]; then
        opts+=(--add-metadata --embed-thumbnail)
    fi

    yt-dlp "${opts[@]}" "$url"
}

_navi_call() {
    local result="$(navi "$@" </dev/tty)"
    printf "%s" "$result"
}

_navi_widget() {
    local -r input="${LBUFFER}"
    local -r last_command="$(echo "${input}" | navi fn widget::last_command)"
    local replacement="$last_command"

    if [ -z "$last_command" ]; then
        replacement="$(_navi_call --print)"
    elif [ "$LASTWIDGET" = "_navi_widget" ] && [ "$input" = "$previous_output" ]; then
        replacement="$(_navi_call --print --query "$_navi_original_query")"
    else
        _navi_original_query="$last_command"
        replacement="$(_navi_call --print --best-match --query "$last_command")"
    fi

    if [ -n "$replacement" ]; then
        local -r find="${last_command}_NAVIEND"
        previous_output="${input}_NAVIEND"
        previous_output="${previous_output//$find/$replacement}"
    else
        previous_output="$input"
    fi

    zle kill-whole-line
    LBUFFER="${previous_output}"
    region_highlight=("P0 100 bold")
    zle redisplay
}

zle -N _navi_widget

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

# Soundboard (pwsp) loudness as a percentage: `set-soundboard-volume 25`.
# No argument prints the current level.
#
# pwsp-cli only has a runtime setter, so the daemon's own config is edited too --
# without that the level resets the next time the daemon restarts. Percentages
# because pwsp speaks 0.0-1.0; anything above 100% amplifies, so this refuses it
# and leaves that to a direct pwsp-cli call.
set-soundboard-volume() {
    local config="${XDG_CONFIG_HOME:-$HOME/.config}/pwsp/daemon.json"

    if (( $# == 0 )); then
        local raw
        if ! raw=$(pwsp-cli get volume-multiplier 2>/dev/null); then
            echo "set-soundboard-volume: pwsp is not running" >&2
            return 1
        fi
        printf '%g%%\n' $(( ${raw##*: } * 100 ))
        return 0
    fi

    if [[ ! $1 =~ '^[0-9]+(\.[0-9]+)?$' ]] || (( $1 > 100 )); then
        echo "usage: set-soundboard-volume [0-100]" >&2
        return 1
    fi

    local value=$(printf '%g' $(( $1 / 100.0 )))

    if ! pwsp-cli set volume-multiplier "$value" > /dev/null 2>&1; then
        echo "set-soundboard-volume: pwsp is not running, saving the default anyway" >&2
    fi

    if [[ ! -f $config ]]; then
        echo "set-soundboard-volume: $config does not exist" >&2
        return 1
    fi

    # Staged beside the config so the replace is atomic and keeps its mode -- a
    # half-written daemon.json would cost the output device and the hotkeys.
    local tmp
    tmp=$(mktemp "$config.XXXXXX") || return 1
    if jq --argjson v "$value" '.default_volume_multiplier = $v' "$config" > "$tmp"; then
        chmod --reference="$config" "$tmp"
        mv -- "$tmp" "$config"
        printf 'soundboard volume %g%%\n' "$1"
    else
        rm -f -- "$tmp"
        echo "set-soundboard-volume: could not update $config" >&2
        return 1
    fi
}
