#!/bin/sh

. "$HOME/.xprofile"

unclutter --timeout=1 &
chth -r &
setxkbmap hu &

exec awesome
# exec xmonad
# exec openbox-session
