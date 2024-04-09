export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN

timezsh() {
        shell=${1-$SHELL}
        for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}
