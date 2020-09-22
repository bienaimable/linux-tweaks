#!/bin/bash
echo "This script must be run both as root and as a regular user" 
sleep 1
if [[ $EUID -ne 0 ]]; then
   cd
   git clone https://github.com/bienaimable/mybookmarks.git
   echo "Make sure to run this script as root" 
   sleep 1
   exit 
fi
apt-get update
apt-get install -y python3-pip chromium-browser suckless-tools xdotool xclip
pip3 install sh attrs pyyaml
ln -rsf customlauncher.py /usr/bin/customlauncher
chmod a+x customlauncher.py
chmod a+x /usr/bin/customlauncher
echo "Make sure to run this script as regular user" 
sleep 1
