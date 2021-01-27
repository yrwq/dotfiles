#!/bin/sh

. "$HOME/.xprofile"

xrdb ~/.Xresources &
feh --bg-scale ~/.wp/abstract.png
thunar --daemon &
unclutter --timeout=1 &
emacs --daemon &
picom --experimental-backends &

remaps &

exec awesome
