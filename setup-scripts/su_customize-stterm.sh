#!/bin/bash
rm -r /tmp/stterm_repo
git clone git://git.suckless.org/st /tmp/stterm_repo
cp /tmp/stterm_repo/config.def.h /tmp/stterm_repo/config.h
patch /tmp/stterm_repo/config.h < ../patches/stterm_config.h.patch
cd /tmp/stterm_repo/
make clean install

