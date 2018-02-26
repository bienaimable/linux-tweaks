apt-get install -y dpkg-dev libx11-dev libxinerama-dev
rm -r dwm_source_tmp
git clone https://git.suckless.org/dwm dwm_source_tmp
cd dwm_source_tmp
cp config.def.h config.h
patch config.h < ../patches/config.h.patch
make clean install
