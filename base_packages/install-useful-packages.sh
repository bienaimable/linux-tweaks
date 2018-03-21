#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi
apt-get update
apt-get install -y git stterm suckless-tools xfe chromium python3-pip
