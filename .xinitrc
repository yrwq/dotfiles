#!/bin/sh

. "$HOME/.xprofile"

yth -t pastel &
thunar --daemon &
unclutter --timeout=1 &

picom --experimental-backends &
# xcompmgr &

remaps &

# exec i3
exec awesome
# exec openbox
# exec xfce4-session
# exec xfwm4
# exec xmonad
