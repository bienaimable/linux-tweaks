#!/bin/bash

dpkg -l gcc;
gcc_installed=$?
dpkg -l make;
make_installed=$?
dpkg -l dkms;
dkms_installed=$?
if [ $gcc_installed == 0 ] && [ $make_installed == 0 ] && [ $dkms_installed == 0 ]; then 
    apt-get install -y linux-headers-$(uname -r);
    mkdir /media/cdrom;
    echo "Mounting Guest Additions CD. Make sure you have it inserted.";
    sleep 10
    mount /dev/cdrom /media/cdrom;
    sh /media/cdrom/VBoxLinuxAdditions.run;
    echo "Installation complete. Rebooting";
    sleep 3
    reboot;
else 
    apt-get install -y make gcc dkms;
    echo "WARNING";
    echo "Please run this script again after reboot";
    sleep 3
    reboot;
fi
