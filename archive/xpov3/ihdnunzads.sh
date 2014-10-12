#!/bin/bash
# unzip ads
#
# Copyright (C) 2009 IHDN, Uvea I. S., Kevin Rattai

date >> $HOME/logs/adsys.log
echo 'start ad unzip script run' >> $HOME/logs/adsys.log

cd $HOME/Videos

7z e -ppassword testad01.7z -aos
7z e -ppassword testad02.7z -aos
7z e -ppassword testad03.7z -aos
7z e -ppassword testad04.7z -aos
7z e -ppassword 0912230000.7z -aos
7z e -ppassword 0912230001.7z -aos
7z e -ppassword 0912230002.7z -aos
7z e -ppassword 0912230003.7z -aos
7z e -ppassword 0912230004.7z -aos
7z e -ppassword 0912230005.7z -aos
7z e -ppassword 0912230006.7z -aos
7z e -ppassword 0912230007.7z -aos
7z e -ppassword 0912230008.7z -aos
7z e -ppassword 0912230009.7z -aos
7z e -ppassword 0912230010.7z -aos
7z e -ppassword 0912230011.7z -aos

date >> $HOME/logs/adsys.log
echo 'end ad unzip script run' >> $HOME/logs/adsys.log

# tput clear
exit 0
