#!/bin/bash
# runs updates
#
# Copyright (C) 2009 IHDN, Uvea I. S., Kevin Rattai

xset led 3

sleep 10

wget -N -nd http://shop.uveais.ca/ihdn/grabfiles.sh -O $HOME/grabfiles.sh

./grabfiles.sh

totem --quit &

wait

wget -N -nd http://shop.uveais.ca/ihdn/ihdn.ca.2.9.pls -O $HOME/demo/ihdn.ca.2.9.pls &

wait

xset -led 3

sleep 10

totem --fullscreen $HOME/demo/ihdn.ca.2.9.pls


# apt-get update

# turn on CAPS and wait 5 minutes

# reboot system
