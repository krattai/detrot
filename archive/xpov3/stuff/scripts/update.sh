#!/bin/bash
# runs updates
#
# Copyright (C) 2009 IHDN, Uvea I. S., Kevin Rattai

wget -N -nd http://shop.uveais.ca/ihdn/grabfiles.sh -O $HOME/grabfiles.sh

./grabfiles.sh

totem --quit

totem --fullscreen $HOME/demo/ihdn.ca.2.9.pls

# apt-get update

# turn on CAPS and wait 5 minutes

# reboot system
