while true; do
    BATT=$(acpi -b | sed 's/Battery 0: //' | sed 's/,[^,]*$//')
    DATE=$(date +"%k:%M - %A %d %B %Y (%d/%m/%y) -- ")
    xsetroot -name "`echo $DATE $BATT`"
    sleep 1
done &
feh --bg-fill ~/wallpaper.jpg
exec /usr/local/bin/dwm
