#!/bin/sh

xset r rate 300 50 &
setxkbmap hu -option caps:super &
killall xcape 2>/dev/null ; xcape -e 'Super_L=Escape' &
xmodmap -e 'keycode 135 = Super_R' &
unclutter --timeout=1 &
xrdb ~/.Xresources

# exec awesome
exec herbstluftwm
