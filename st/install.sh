#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   ln -rsf .zshrc ~/.zshrc
   echo "Please enter password to choose your shell (/bin/zsh is recommended)"
   chsh
   echo "Make sure to also run this script as root"
   sleep 1
   exit
fi
apt-get update
apt-get install -y fontconfig libfreetype6-dev libxft2-dev zsh
FOLDER="/tmp/stterm"
rm -r $FOLDER
git clone --branch 0.8 git://git.suckless.org/st $FOLDER
cp st-scrollback-0.8.diff $FOLDER/
cp st-scrollback-mouse-0.8.diff $FOLDER/
cp st-scrollback-mouse-altscreen-0.8.diff $FOLDER/
cp st-no_bold_colors-0.8.1.diff $FOLDER/
cp st-nordtheme-0.8.2.diff $FOLDER/
#cp config.patch $FOLDER/
cd $FOLDER
patch < st-scrollback-0.8.diff
patch < st-scrollback-mouse-0.8.diff
patch < st-scrollback-mouse-altscreen-0.8.diff
patch < st-no_bold_colors-0.8.1.diff
patch < st-nordtheme-0.8.2.diff
#patch < config.patch
cp config.def.h config.h
make clean install
echo "Make sure to also run this script as normal user"
sleep 1
