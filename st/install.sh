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
git clone git://git.suckless.org/st $FOLDER
#IN=$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')
#arrIN=(${IN//x/ })
#if [[ $arrIN < 1400 ]] ; 
#then 
#    echo Using low resolution configuration;
#    cp low_res_config.h $FOLDER/config.h
#else
#    echo Using high resolution configuration;
#    cp high_res_config.h $FOLDER/config.h
#fi;
cp st-scrollback-20190331-21367a0.diff $FOLDER/
cp st-scrollback-mouse-0.8.diff $FOLDER/
cp st-scrollback-mouse-altscreen-20190131-e23acb9.diff $FOLDER/
cp config.patch $FOLDER/
cd $FOLDER
patch < st-scrollback-20190331-21367a0.diff
patch < st-scrollback-mouse-0.8.diff
patch < st-scrollback-mouse-altscreen-20190131-e23acb9.diff
patch < config.patch
cp config.def.h config.h
make clean install
cat >/usr/bin/st_background <<EOL
#!/bin/bash
st &
EOL
chmod a+x /usr/bin/st_background
echo "Make sure to also run this script as normal user" 
sleep 1
