#!/bin/sh

if [[ $(pamixer --get-mute) == false ]]; then
    echo "󰋋 "
else
    echo "󰟎 "
fi
