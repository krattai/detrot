#!/bin/bash
# gets update scripts
#
# Copyright (C) 2009 IHDN, Uvea I. S., Kevin Rattai

# wget -N -nd http://ihdn.ca/ftp/demoads/update.sh -O $HOME/update.sh
wget -N -nd http://206.45.113.102/ftp/forclients/update.sh -O $HOME/update.sh
cd $HOME
./update.sh
