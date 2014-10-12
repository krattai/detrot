#!/bin/bash
# runs updates
#
# Copyright (C) 2009 IHDN, Uvea I. S., Kevin Rattai

xset led 3

sleep 10

wget -N -nd http://206.45.113.102/ftp/forclients/getupdt.sh -O $HOME/getupdt.sh

sleep 10

sudo reboot
