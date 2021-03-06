#!/bin/sh

xrdb ~/.Xresources &
emacs --daemon &
unclutter --timeout=1 &
picom &
mpd &

xset r rate 300 50 &
setxkbmap hu -option caps:super &
killall xcape 2>/dev/null ; xcape -e 'Super_L=Escape' &
xmodmap -e 'keycode 135 = Super_R' &

# exec qtile
exec awesome
# exec xmonad
# exec ywm
