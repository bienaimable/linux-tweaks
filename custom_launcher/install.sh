#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   sleep 1
   exit 
fi
ln -rsf customlauncher.py /usr/bin/customlauncher
chmod a+x customlauncher.py
chmod a+x /usr/bin/customlauncher
