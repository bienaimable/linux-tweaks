#!/bin/sh
xrandr --newmode "2560x1600_60.00" 348.50  2560 2760 3032 3504  1600 1603 1609 1658 -hsync +vsync
xrandr --addmode Virtual1 2560x1600_60.00
xrandr --output Virtual1 --mode 2560x1600_60.00
#SECONDS=0
#while true; do
#    BATT=$(acpi -b | sed 's/Battery 0: //' | sed 's/,[^,]*$//')
#    DATELOCAL=$(date +"%k:%M - %A %B %d")
#    DATEISO=$(date -u +"%Y-%m-%dT%H:%M:%SZ");
#    if [[ $SECONDS > 9 ]]; then
#        ping -c 1 -W 1 8.8.8.8 2&> /dev/null;
#        if [[ $? != 0 ]]; then 
#            CONNECTION='Disconnected'; 
#        else 
#            CONNECTION='Connected'; 
#        fi;
#        SECONDS=0
#    fi;
#    xsetroot -name "`echo $DATELOCAL -- $DATEISO -- $CONNECTION, checked $SECONDS ago -- $BATT`"
#    sleep 1
#done &
~/linux-tweaks/dwm/header.py &
feh --bg-fill ~/wallpaper.jpg
setxkbmap -option caps:escape
export _JAVA_AWT_WM_NONREPARENTING=1 # To fix Pycharm and Android Studio blank screen in DWM
exec /usr/local/bin/dwm 2> ~/.dwm.log
