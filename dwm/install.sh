#!/bin/bash
echo "This script must be run twice. Once as root and once as regular user" 
sleep 1
if [[ $EUID -ne 0 ]]; then

   echo "Creating dev folder" 
   mkdir -p ~/dev
   sleep 1
   echo "Linking Downloads to tmp" 
   rm -rf ~/Downloads
   ln -rsf /tmp/ ~/Downloads
   sleep 1
   echo "Make sure to also run this script as root" 
   sleep 1
   exit 
fi
echo "Installing dependencies..." 
sleep 1
apt-get update
apt-get install -y python3-pip chromium-browser suckless-tools xdotool xclip ntpdate
pip3 install sh attrs pyyaml
apt-get install -y dpkg-dev libx11-dev libxinerama-dev feh libfreetype6-dev libxft2-dev xinit acpi x11-xkb-utils suckless-tools xbindkeys
echo "Linking helper scripts (brightness, printscreen...)"
ln -rsf brightness.sh /usr/bin/brightness
ln -rsf printscreen.sh /usr/bin/printscreen
ln -rsf screencast_window.sh /usr/bin/screencast_window
ln -rsf sleep_and_lock.sh /usr/bin/sleep_and_lock
ln -rsf ../mouse/gridclick.py /usr/bin/gridclick
chmod a+x /usr/bin/sleep_and_lock
chmod a+x brightness.sh
chmod a+x /usr/bin/brightness
echo "Choose default apps" 
sleep 1
update-alternatives --config x-www-browser
update-alternatives --config x-terminal-emulator
echo "Make sure to also run this script as regular user" 
sleep 1
