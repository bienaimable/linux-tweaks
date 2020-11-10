#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   sleep 1
   exit 
fi
apt-get update
apt-get install -y libncurses5-dev
apt-get install -y mupdf mpv sxiv unp tree
rm -rf /opt/noice
git clone --branch v0.8 git://git.2f30.org/noice.git /opt/noice
cp config.def.h /opt/noice/
cd /opt/noice
cp config.def.h config.h
make
ln -rsf ./noice /usr/bin/
# \kl stands for left arrow. Used here to quit less
echo "\kl quit" |lesskey -

#cat >/usr/bin/mimeopenask <<EOL
##!/bin/sh
#mimeopen -a "\$1"
#EOL
#chmod a+x /usr/bin/mimeopenask

cat >/usr/bin/mimeopenaskdefault <<EOL
#!/bin/sh
mimeopen -d "\$1"
EOL
chmod a+x /usr/bin/mimeopenaskdefault

cat >/usr/bin/mimeopenaskdefaultbg <<EOL
#!/bin/sh
nohup st mimeopenaskdefault "\$1" > /dev/null 2>&1 & disown
EOL
chmod a+x /usr/bin/mimeopenaskdefaultbg

cat >/usr/bin/smartless <<EOL
#!/bin/sh
lesspipe "\$1" | less
EOL
chmod a+x /usr/bin/smartless

cat >/usr/bin/treeless <<EOL
#!/bin/sh
tree "\$1" | less
EOL
chmod a+x /usr/bin/treeless

cat >/usr/bin/mimeopenbg <<EOL
#!/bin/sh
nohup mimeopen "\$1" > /dev/null 2>&1 & disown
EOL
chmod a+x /usr/bin/mimeopenbg

cat >/usr/bin/treelessbg <<EOL
#!/bin/sh
nohup st treeless "\$1" > /dev/null 2>&1 & disown
EOL
chmod a+x /usr/bin/treelessbg

cat >/usr/bin/vimbg <<EOL
#!/bin/sh
if [ -z "\$1" ]
  then
    nohup st vim > /dev/null 2>&1 & disown
  else
    nohup st vim "\$1" > /dev/null 2>&1 & disown
fi
EOL
chmod a+x /usr/bin/vimbg

cat >/usr/bin/vimrbg <<EOL
#!/bin/sh
if [ -z "\$1" ]
  then
    nohup st vim --servername MAIN > /dev/null 2>&1 & disown
  else
    nohup st vim --servername MAIN --remote-silent "\$1" > /dev/null 2>&1 & disown
fi
EOL
chmod a+x /usr/bin/vimrbg
