#!/bin/sh

. "$HOME/.xprofile"

# Random theme
cht -r &

# Network Manager
nm-applet &

# Turn off screenlocking applet
caffeine &

# Hide cursor after a second
unclutter --timeout=1 &

# Compositor
picom --experimental-backends &

# Lock after 10 mins
xautolock -time 10 -locker lock &

# Remap keys
remaps &

exec awesome
