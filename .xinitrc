#!/bin/sh

if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/x11/xprofile" ]; then
	. "${XDG_CONFIG_HOME:-$HOME/.config}/x11/xprofile"
else
	. "$HOME/.xprofile"
fi

unclutter --timeout=1 &
mpd-discord-rpc &
chth -r &
setxkbmap hu &

exec awesome
# exec xmonad
# exec openbox-session
