#!/bin/bash
#
# lock.sh — run hyprlock, and bring it back if it crashes while the session is
# still locked.
#
# hyprlock aborts when the compositor drops its connection, which swapping
# outputs can provoke, and stream-display.sh swaps them on every stream (see
# hyprwm/hyprlock#1064). The compositor rightly stays locked, but with nothing
# left to type a password into, so getting out takes an SSH login and
# hl.clear_crashed_lockscreen(). A new hyprlock can only take over that abandoned
# lock because hyprland.lua sets misc.allow_session_lock_restore.

MAX_CRASHES=5
CRASH_WINDOW=60 # seconds a hyprlock has to stay up to clear the crash count

# Allowing lock restore also stops the compositor refusing a second lock client.
pidof hyprlock >/dev/null && exit 0

crashes=0
while true; do
    started=$SECONDS
    hyprlock
    status=$?

    # 128 + SIGILL, SIGABRT, SIGBUS, SIGFPE or SIGSEGV. Anything else is an unlock
    # or a deliberate kill, and neither should bring the lock screen back.
    case "$status" in
        132 | 134 | 135 | 136 | 139) ;;
        *) exit "$status" ;;
    esac
    [[ "$(hyprctl locked)" == true ]] || exit "$status"

    ((SECONDS - started >= CRASH_WINDOW)) && crashes=0
    if ((++crashes > MAX_CRASHES)); then
        logger -t lock.sh "hyprlock keeps crashing (status $status), giving up"
        exit "$status"
    fi
    logger -t lock.sh "hyprlock crashed (status $status), restarting ($crashes/$MAX_CRASHES)"

    # Let whatever took it down, usually an output swap, finish first.
    sleep 1
done
