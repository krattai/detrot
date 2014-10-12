#!/bin/bash
# reboots system
# NB:  Control to run su without password needs to have been set in OS
#
# Copyright (C) 2009 IHDN, Uvea I. S., Kevin Rattai

date >> $HOME/logs/adbox.log
echo '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!' >> $HOME/logs/adbox.log
echo '********************************************************' >> $HOME/logs/adbox.log
echo '~~~~~~~~~~~ S Y S T E M   R E B O O T ~~~~~~~~~~~~~~~~~~' >> $HOME/logs/adbox.log
echo '********************************************************' >> $HOME/logs/adbox.log
echo '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!' >> $HOME/logs/adbox.log

sudo reboot

