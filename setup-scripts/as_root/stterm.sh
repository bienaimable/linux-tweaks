#!/bin/bash
FOLDER="/tmp/stterm"
rm -r $FOLDER
git clone git://git.suckless.org/st $FOLDER
cp ../../configs/st/config.h $FOLDER/config.h
#patch /tmp/stterm_repo/config.h < ../../patches/stterm_config.h.patch
cd $FOLDER
make clean install
cat >/usr/bin/st_background <<EOL
#!/bin/bash
st &
EOL
chmod a+x /usr/bin/st_background
