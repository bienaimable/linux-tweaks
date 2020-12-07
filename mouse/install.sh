#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root first"
   sleep 1
   gridclick --setup
   exit
fi
apt-get update
apt install -y python3-pip
pip3 install --upgrade Xlib click pyyaml
