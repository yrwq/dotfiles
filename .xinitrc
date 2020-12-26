#!/bin/sh

if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/x11/xprofile" ]; then
	. "${XDG_CONFIG_HOME:-$HOME/.config}/x11/xprofile"
else
	. "$HOME/.xprofile"
fi

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh) &

export SSH_AUTH_SOCK &

unclutter --timeout=1 &
mpd-discord-rpc &
chth -r &
setxkbmap hu &

exec awesome
# exec xmonad
# exec openbox-session
