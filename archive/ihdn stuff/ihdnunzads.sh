#!/bin/bash
# unzip ads
#
# Copyright (C) 2009 IHDN, Uvea I. S., Kevin Rattai

date >> $HOME/logs/adsys.log
echo 'start ad unzip script run' >> $HOME/logs/adsys.log

cd $HOME/demo

7z e -ppassword testad01.7z -aos
7z e -ppassword testad02.7z -aos
7z e -ppassword testad03.7z -aos
7z e -ppassword testad04.7z -aos

date >> $HOME/logs/adsys.log
echo 'end ad unzip script run' >> $HOME/logs/adsys.log

# tput clear
exit 0
