#!/bin/sh

level=$(cat /sys/class/power_supply/macsmc-battery/capacity)
if [[ $(cat /sys/class/power_supply/macsmc-battery/status) == Discharging ]]; then
    echo "$level%"
else
    echo "+ $level%"
fi
