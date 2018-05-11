apt-get install -y libxft2 libxft-dev xinit dpkg-dev libx11-dev libxinerama-dev
rm -r /tmp/dwm_source_tmp
git clone https://git.suckless.org/dwm /tmp/dwm_source_tmp
cp /tmp/dwm_source_tmp/config.def.h /tmp/dwm_source_tmp/config.h
patch /tmp/dwm_source_tmp/config.h < ../patches/dwm_config.h.patch
cd /tmp/dwm_source_tmp
make clean install
