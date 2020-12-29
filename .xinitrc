#!/bin/sh

. "$HOME/.xprofile"

unclutter --timeout=1 &
setxkbmap hu &
remaps &

exec awesome
# exec xmonad
# exec openbox-session
