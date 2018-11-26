#!/bin/bash
sudo apt install xserver-xorg-input-synaptics
sudo apt install xserver-xorg-input-libinput
reboot
sudo cp 70-synaptics.conf /etc/X11/xorg.conf.d/
