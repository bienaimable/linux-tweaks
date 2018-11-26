#!/bin/bash
CURRENT_BRIGHTNESS=`cat /sys/class/backlight/intel_backlight/brightness`
MAX_BRIGHTNESS=`cat /sys/class/backlight/intel_backlight/max_brightness`
MIN_BRIGHTNESS=0
BRIGHTNESS_THRESHOLD=500
if [[ $1 !=  "up" ]] && [[ $1 != "down" ]]; then
    echo "Usage: brightness [up|down]"
    exit
fi
if [[ $1 = "up" ]]; then
    NEW_BRIGHTNESS=$(($CURRENT_BRIGHTNESS+$BRIGHTNESS_THRESHOLD))
    if [[ $NEW_BRIGHTNESS -gt $MAX_BRIGHTNESS ]]; then 
        NEW_BRIGHTNESS=$MAX_BRIGHTNESS
    fi
    echo $NEW_BRIGHTNESS > /sys/class/backlight/intel_backlight/brightness
fi
if [[ $1 = "down" ]]; then
    NEW_BRIGHTNESS=$(($CURRENT_BRIGHTNESS-$BRIGHTNESS_THRESHOLD))
    if [[ $NEW_BRIGHTNESS -lt $MIN_BRIGHTNESS ]]; then 
        NEW_BRIGHTNESS=$MIN_BRIGHTNESS
    fi
    echo $NEW_BRIGHTNESS > /sys/class/backlight/intel_backlight/brightness
fi
