#!/bin/bash
# Shell script to put log files, etc to server
#
# Copyright (C) 2009 IHDN, Uvea I. S., Kevin Rattai
 
date >> $HOME/logs/adsys.log
echo 'start putfiles script run' >> $HOME/logs/adsys.log

cd $HOME/logs

NUMBER=$RANDOM

cp adsys.log adsys$NUMBER.log

ncftpput -u brent -p tnerb 206.45.113.102 fromclients adsys$NUMBER.log

date >> $HOME/logs/adsys.log
echo 'end putfiles script run' >> $HOME/logs/adsys.log

# tput clear
exit 0
