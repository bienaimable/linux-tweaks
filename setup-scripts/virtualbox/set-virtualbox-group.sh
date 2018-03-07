#!/bin/bash

# Mount shared drive via the VirtualBox menus then
usermod -a user -G vboxsf
reboot
