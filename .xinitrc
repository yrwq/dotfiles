#!/bin/sh

. "$HOME/.xprofile"

cht -t rosepine &
nm-applet &
unclutter --timeout=1 &
picom --experimental-backends &

# Notify before lock
xautolock -time 9 -locker lock -n &
# Lock after 10 mins
xautolock -time 10 -locker lock &

remaps &
setxkbmap hu &

exec awesome
