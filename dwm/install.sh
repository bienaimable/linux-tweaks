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
   echo "Choose default apps" 
   sleep 1
   update-alternatives --config x-www-browser
   update-alternatives --config x-terminal-emulator
   echo "Make sure to also run this script as root" 
   sleep 1
   exit 
fi
echo "Installing dwm..." 
sleep 1
apt-get install -y dpkg-dev libx11-dev libxinerama-dev feh
rm -r src
git clone https://git.suckless.org/dwm src
cd src
cp config.def.h config.h
patch config.h < ../config.h.patch
make clean install
echo "Make sure to also run this script as regular user" 
sleep 1
