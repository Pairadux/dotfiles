export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="eastwood"

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"
#
# Uncomment the following line to disable auto-setting terminal title.
#
# DISABLE_AUTO_TITLE="true"
#
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
	jump
	aliases
	# pyenv
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

alias doocommit="dooitcommit.sh"
alias doopull="dooitpull.sh"
alias c="clear"
alias nv="nvim"

eval "$(zoxide init zsh)"
