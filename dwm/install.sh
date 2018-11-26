#!/bin/bash
echo "This script must be run twice. Once as root and once as regular user" 
sleep 1
if [[ $EUID -ne 0 ]]; then
   echo "Setting up .xinitrc for regular user" 
   sleep 1
   ln -rsf .xinitrc ~/.xinitrc
   echo "Setting up wallpaper" 
   sleep 1
   ln -rsf wallpaper.jpg ~/wallpaper.jpg
   echo "Creating dev folder" 
   mkdir -p ~/dev
   sleep 1
   echo "Make sure to also run this script as root" 
   sleep 1
   exit 
fi
echo "Installing dependencies..." 
sleep 1
apt-get install -y dpkg-dev libx11-dev libxinerama-dev feh libfreetype6-dev libxft2-dev xinit acpi x11-xkb-utils suckless-tools
echo "Linking helper scripts (brightness...)"
ln -rsf brightness.sh /usr/bin/brightness
chmod a+x brightness.sh
chmod a+x /usr/bin/brightness
echo "Installing dwm..." 
sleep 1
FOLDER=/tmp/dwm_src
rm -rf $FOLDER
git clone https://git.suckless.org/dwm $FOLDER
cp config.h $FOLDER
cd $FOLDER
make clean install
echo "Choose default apps" 
sleep 1
update-alternatives --config x-www-browser
update-alternatives --config x-terminal-emulator
echo "Make sure to also run this script as regular user" 
sleep 1
