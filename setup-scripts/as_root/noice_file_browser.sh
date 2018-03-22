#!/bin/bash

apt-get install libncurses5-dev
rm -rf /opt/noice
git clone git://git.2f30.org/noice.git /opt/noice
cp ../../configs/noice/config.h /opt/noice/
cd /opt/noice
make
ln -rsf ./noice /usr/bin/
