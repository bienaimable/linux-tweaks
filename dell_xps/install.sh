#!/bin/bash
sudo qpt update
sudo apt install xserver-xorg-core
sudo apt install xserver-xorg-input-synaptics
sudo apt install xserver-xorg-input-libinput
sudo cp 70-synaptics.conf /etc/X11/xorg.conf.d/
reboot
