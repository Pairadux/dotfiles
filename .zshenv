#!/usr/bin/env zsh

######################################## EXPORT ENVIRONMENT VARIABLE ########################################

export DOTFILES="$HOME/.dotfiles"
export WORKSPACE="$HOME/workspace"

# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# editor
export EDITOR="nvim"
export VISUAL="nvim"

# zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH="$ZDOTDIR"
export HISTFILE="$ZDOTDIR/.zhistory"
export HISTSIZE=10000
export SAVEHIST=10000
. "$HOME/.cargo/env"
