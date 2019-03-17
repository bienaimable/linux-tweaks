#!/bin/bash
echo "This script must be run twice. Once as root and once as regular user" 
sleep 1
if [[ $EUID -ne 0 ]]; then
   echo "Setting up .vimrc for regular user" 
   sleep 1
   mkdir -p ~/.vim &
   ln -rsf .vimrc ~/.vimrc
   #IN=$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')
   #arrIN=(${IN//x/ })
   #if [[ $arrIN < 1400 ]] ; 
   #then 
   #    echo Using low resolution configuration;
   #    cp .vimrc.low_res ~/.vimrc
   #else
   #    echo Using high resolution configuration;
   #    cp .vimrc.high_res ~/.vimrc
   #fi;
   echo "Make sure to also run this script as root" 
   sleep 1
   exit 
fi
echo "Installing vim..." 
sleep 1
apt-get update
apt-get install -y vim-gtk3 fonts-inconsolata
