#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   sleep 1
   exit 
fi
apt-get update
apt-get install -y libncurses5-dev
apt-get install -y mupdf mpv sxiv unp
rm -rf /opt/noice
git clone git://git.2f30.org/noice.git /opt/noice
cp config.patch /opt/noice/
cd /opt/noice
cp config.def.h config.h
patch < config.patch
make
ln -rsf ./noice /usr/bin/
#cat >/usr/bin/mimeopenask <<EOL
##!/bin/sh
#mimeopen -a "\$1"
#EOL
#chmod a+x /usr/bin/mimeopenask
cat >/usr/bin/mimeopendefault <<EOL
#!/bin/sh
mimeopen "\$1"
EOL
chmod a+x /usr/bin/mimeopendefault
cat >/usr/bin/mimeopenbg <<EOL
#!/bin/sh
mimeopen "\$1" &
EOL
chmod a+x /usr/bin/mimeopenbg
cat >/usr/bin/smartless <<EOL
#!/bin/sh
lesspipe "\$1" | less
EOL
chmod a+x /usr/bin/smartless
echo "h quit" |lesskey - 
