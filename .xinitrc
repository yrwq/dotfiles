#!/bin/sh

# xinitrc runs automatically when you run startx.

if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/x11/xprofile" ]; then
	. "${XDG_CONFIG_HOME:-$HOME/.config}/x11/xprofile"
else
	. "$HOME/.xprofile"
fi

pulseaudio --start
unclutter --timeout=1 &
mpd-discord-rpc &
chth -r &
setxkbmap hu
sleep 1
exec awesome
# exec xmonad
# exec openbox-session
