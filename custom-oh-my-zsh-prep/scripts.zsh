#!/usr/bin/env zsh

MARKS_DIR="$HOME/.marks"

function mark {
    mkdir -p "$MARKS_DIR"
    ln -s "$(pwd)" "$MARKS_DIR/$1"
}

function jump {
    cd -P "$MARKS_DIR/$1" 2>/dev/null || echo "No such mark: $1"
}

function marks {
    echo "Available marks:"
    ls -l "$MARKS_DIR" | awk '{print $9, "->", $11}'
}

function unmark {
    rm -f "$MARKS_DIR/$1"
}
