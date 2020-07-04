#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   rm -rf ~/.config/fish/functions
   ln -sf $PWD/fish/functions ~/.config/fish/
   #echo "Please enter password to choose your shell (/bin/zsh is recommended)"
   #chsh -s /usr/bin/fish
   echo "Make sure to also run this script as root"
   sleep 1
   exit
fi
apt-add-repository -y ppa:fish-shell/release-3
apt-get update
apt-get install -y fontconfig libfreetype6-dev libxft2-dev fish
#echo /usr/bin/fish | sudo tee -a /etc/shells
#chsh -s /usr/bin/fish
FOLDER="/tmp/stterm"
rm -r $FOLDER
git clone --branch 0.8 git://git.suckless.org/st $FOLDER
cp st-scrollback-0.8.diff $FOLDER/
cp st-scrollback-mouse-0.8.diff $FOLDER/
cp st-scrollback-mouse-altscreen-0.8.diff $FOLDER/
cp st-no_bold_colors-0.8.1.diff $FOLDER/
cp st-nordtheme-0.8.2.diff $FOLDER/
#cp default_term.diff $FOLDER/
cd $FOLDER
patch < st-scrollback-0.8.diff
patch < st-scrollback-mouse-0.8.diff
patch < st-scrollback-mouse-altscreen-0.8.diff
patch < st-no_bold_colors-0.8.1.diff
patch < st-nordtheme-0.8.2.diff
#patch < default_term.diff
cp config.def.h config.h
make clean install

cat >/usr/bin/stbg <<EOL
#!/bin/sh
nohup st fish > /dev/null 2>&1 & disown
EOL
chmod a+x /usr/bin/stbg

echo "Make sure to also run this script as normal user"
sleep 1
