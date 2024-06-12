#!/usr/bin/env zsh

# +------+
# | OPTS |
# +------+
unsetopt correct_all
setopt CDABLE_VARS
setopt EXTENDED_GLOB
export BLOCK_SIZE="'1"

# +------+
# | PATH |
# +------+
typeset -U path

# +----------------+
# | TAB COMPLETION |
# +----------------+
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
setopt complete_in_word         # cd /ho/sco/tm<TAB> expands to /home/scott/tmp
setopt auto_menu                # show completion menu on succesive tab presses
setopt autocd                   # cd to a folder just by typing it's name
ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&'

# +---------+
# | ALIASES |
# +---------+
source $ZDOTDIR/extras/aliases

# +----------+
# | Antidote |
# +----------+
source $ZDOTDIR/.antidote/antidote.zsh 

antidote load

# +--------+
# | PROMPT |
# +--------+
autoload -Uz promptinit && promptinit && prompt pure

# +----------------+
# | CUSTOM SCRIPTS |
# +----------------+
source $ZDOTDIR/extras/custom-scripts/jump.zsh

# +---------+
# | Startup |
# +---------+
if [[ -z $TMUX && $TERM == "xterm-256color" ]]; then
    tmux new -A -s pairadux;
fi

# +---------+
# | BINDING |
# +---------+
bindkey -e

bindkey -r '^l'
bindkey -r '^g'
bindkey -r '^p'

bindkey '^g' .clear-screen
bindkey '^f' autosuggest-accept
bindkey ' ' magic-space
