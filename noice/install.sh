#!/bin/bash
apt-get update
apt-get install -y libncurses5-dev
rm -rf /opt/noice
git clone git://git.2f30.org/noice.git /opt/noice
cp config.h /opt/noice/
cd /opt/noice
make
ln -rsf ./noice /usr/bin/
echo "h quit" |lesskey - 
