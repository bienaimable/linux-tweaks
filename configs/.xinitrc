#!/bin/sh
xrandr --newmode "2560x1600_60.00" 348.50  2560 2760 3032 3504  1600 1603 1609 1658 -hsync +vsync
xrandr --addmode Virtual1 2560x1600_60.00
xrandr --output Virtual1 --mode 2560x1600_60.00
while true; do
    BATT=$(acpi -b | sed 's/Battery 0: //' | sed 's/,[^,]*$//')
    DATELOCAL=$(date +"%k:%M - %A %d %B %Y")
    DATEISO=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    xsetroot -name "`echo $DATELOCAL -- $DATEISO -- $BATT`"
    sleep 1
done &
feh --bg-fill ~/wallpaper.jpg
exec /usr/local/bin/dwm
