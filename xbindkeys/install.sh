#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "Setting up .xbindkeysrc for regular user"
    sleep 1
    ln -rsf .xbindkeysrc ~/.xbindkeysrc
    sleep 1
    killall xbindkeys; xbindkeys -f ~/.xbindkeysrc
    exit
fi
echo "This must be run as regular user"
sleep 1
