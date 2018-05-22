#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   sleep 1
   exit 
fi
apt-get update
apt-get install -y libncurses5-dev
rm -rf /opt/noice
git clone git://git.2f30.org/noice.git /opt/noice
cp config.h /opt/noice/
cd /opt/noice
make
ln -rsf ./noice /usr/bin/
echo "h quit" |lesskey - 
