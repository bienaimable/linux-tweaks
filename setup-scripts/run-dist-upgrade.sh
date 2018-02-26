#!/bin/bash

# Full dist-upgrade for Debian (run with sudo in Ubuntu)
apt-get clean && apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get autoremove --purge -y && apt-get clean
