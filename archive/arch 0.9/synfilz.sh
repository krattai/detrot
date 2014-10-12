#!/usr/bin/env bash
#
# sync files
#
# Copyright (C) 2014 Uvea I. S., Kevin Rattai
#
# wget -r -nd -Nc -l2 -w 3 -i file -P $HOME/mp4 http://192.168.200.6/files/
#
# or
#
# wget -r -nd -Nc -l2 -w 3 -A.mp4 -P $HOME/mp4 http://192.168.200.6/files/
#
# or
#
# wget -b -c -q -r -nd -nc -l2 -w3 --limit-rate=50k -A.mp4 -P $HOME/mp4 http://192.168.200.6/files/
#
# -b background
# -c continue if prior broken; not working in some cases do not use
# -q quiet no output log
# -r recursive required if multiple
# -nd no direcotry so not putting paths
# -nc no clobber so not download if exist
# -l2 only 2 levels, important with http as level 2 is files
# -w3 wait 3 seconds so as not to overwhelm server with requests
# --limit-rate to save bandwidth on both client and server
# -A is files of type
# -P sends to path on client
#
# When running Wget with ‘-N’, with or without ‘-r’ or ‘-p’, the
# decision as to whether or not to download a newer copy of a file
# depends on the local and remote timestamp and size of the file (see
# Time-Stamping). ‘-nc’ may not be specified at the same time as ‘-N’. 
#
# Eventually, it would be nice to have this script create
# log or file to indicate that it completed successfully
# this would be the last command before a the script exits
# on a success rather than a fail exit

AEBL_TEST="/home/pi/.aebltest"
AEBL_SYS="/home/pi/.aeblsys"
IHDN_TEST="/home/pi/.ihdntest"
IHDN_SYS="/home/pi/.ihdnsys"
LOCAL_SYS="/home/pi/.local"
NETWORK_SYS="/home/pi/.network"
OFFLINE_SYS="/home/pi/.offline"
MACe0=$(ip link show eth0 | awk '/ether/ {print $2}')


cd $HOME

if [ -f "${NETWORK_SYS}" ]; then

#     rm $HOME/log.txt

#     touch $HOME/log.txt

    rm $HOME/test.log

    touch $HOME/test.log

    echo "${MACe0}" >> test.log
    echo "$(date +"%y-%m-%d")" >> test.log
    echo "$(date +"%T")" >> test.log

    echo "#!~~ free ~~~!#" >> test.log
    free >> test.log
    echo "#!~~ ps x ~~~!#" >> test.log
    ps x >> test.log

    echo "#!~~ ls -al ~~~!#" >> test.log
    ls -al >> test.log

#     echo "#!~~ cronttab -l ~~~!#" >> test.log

#     crontab -l >> test.log

#     echo "#!~~~~~!#" >> test.log

#     echo "#!~~ ls -al scripts ~~~!#" >> test.log
#     ls -al scripts >> test.log

#     echo "#!~~~~~!#" >> test.log

    echo "#!~~ ls -al pl ~~~!#" >> test.log
    ls -al pl >> test.log

    echo "#!~~~~~!#" >> test.log

    echo "#!~~ cat .newpl ~~~!#" >> test.log
    cat .newpl >> test.log

    echo "#!~~~~~!#" >> test.log

    echo "#!~~ ls -al mp4 ~~~!#" >> test.log
    ls -al mp4 >> test.log

    echo "#!~~ df -h ~~~!#" >> test.log
    df -h >> test.log

    echo "#!#!#!#!#" >> test.log

    $HOME/scripts/./dropbox_uploader.sh upload test.log /${MACe0}_up.txt &

#     if [ "${MACe0}" == 'b8:27:eb:a7:23:94' ]; then

#         wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/s9jv5gi0ybr3ura/process_playlist.sh"
#         chmod 755 $HOME/scripts/process_playlist.sh

#     fi
#     if [ "${MACe0}" == 'b8:27:eb:a7:23:94' ] && [ ! -f "${HOME}/.rblt" ]; then

#         touch $HOME/.rblt

#         $HOME/scripts/./create-ihdn.sh

#     fi

    if [ "${MACe0}" == 'b8:27:eb:a7:23:94' ] && [ -f "${HOME}/.rblt" ]; then

#         touch $HOME/.rblt

        rm $HOME/.rblt

#         cp "$HOME/mp4/ihdn mrkt 14051500.mp4" $HOME/pl
#         rm $HOME/mp4/*
#         cp $HOME/pl/*.mp4 $HOME/mp4

        sudo reboot

    fi
fi

if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
    echo "Check if MAC is ending :5a" >> log.txt
    echo "MAC Address is created as: $MACe0"
    echo $(date +"%T") >> log.txt
    if [ "${MACe0}" == 'b8:27:eb:37:07:5a' ] && [ -f "${AEBL_SYS}" ]; then
        echo "MAC is ending :5a and has .aeblsys but should not, so removing .aeblsys and .aeblsys_test." >> log.txt
        rm .aeblsys
        rm .aeblsys_test
    fi
fi

if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
    echo "Running sync filz." >> log.txt
    echo $(date +"%T") >> log.txt
fi

if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
    echo "!*******************!" >> log.txt
    echo "Posting log" >> log.txt
    echo $(date +"%T") >> log.txt
    echo "!*******************!" >> log.txt

    # put to dropbox
#    $HOME/scripts/./dropbox_uploader.sh upload log.txt /${MACe0}_log.txt &

    # upload to sftp server
#    curl -T "$HOME/log.txt" -k -u videouser:password "sftp://184.71.76.158:8022/home/videouser/videos/000000_uploads/ihdnpi_logs/${MACe0}_log.txt" &

#        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/lctrl.ctab

#        sudo sed -i '/\*\/3 \* \* \* \* \/home\/pi\/scripts\/l-ctrl.sh/d' /var/spool/cron/crontabs/pi

#        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/cronadd.sh

#        chmod 777 scripts/cronadd.sh

#        scripts/./cronadd.sh

#        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/cronrem.sh

#        chmod 777 scripts/cronrem.sh

#        scripts/./cronrem.sh

#        rm scripts/chkint.ctab

#        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/chckint.ctab

#        wget -N -r -nd -l2 -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/cronadd.sh

#        chmod 777 scripts/cronadd.sh

#        scripts/./cronadd.sh

fi

#Check network before syncing
if [ -f "${LOCAL_SYS}" ]; then
    rm index*
    echo "Online"

    # Check if not syncing
    # should append syncing to syncing file and dump it to dropbox

    if [ ! -f "${HOME}/syncing" ]; then
        echo "Currently not syncing." >> log.txt
        echo "Making running token."  >> log.txt
        echo $(date +"%T") >> log.txt

        touch "${HOME}/syncing"

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/getupdt.sh

        chmod 777 scripts/getupdt.sh

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/process_playlist.sh

        chmod 777 scripts/process_playlist.sh

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/grabfiles.sh

        chmod 777 scripts/grabfiles.sh

        scripts/./grabfiles.sh

        rm synfil

        if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
            wget -N -nd -w 3 -P $HOME --limit-rate=50k http://192.168.200.6/files/aebl.m3u

            cp aebl.m3u synfil

            rm aebl.m3u

        fi

        if [ -f "${IHDN_TEST}" ]; then
            wget -N -nd -w 3 -P $HOME --limit-rate=50k http://192.168.200.6/files/ihdn.m3u

            cp ihdn.m3u synfil

            rm ihdn.m3u

        fi

        if [ -f "${IHDN_TEST}" ] || [ -f "${IHDN_SYS}" ] && [ ! -f "${OFFLINE_SYS}" ]; then
            if [ -f "${LOCAL_SYS}" ]; then
                wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k http://192.168.200.6/files/ihdn_tests.sh
            else
                wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/vtm7naqg4sbq2wh/ihdn_tests.sh"
            fi
            chmod 777 scripts/ihdn_tests.sh
        fi

        GRAB_FILE="${HOME}/synfil"

        x=1

        if [ ! -d "tmp" ]; then
            mkdir tmp
        fi

        if  [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ] || [ -f "${IHDN_TEST}" ]; then
            while [ $x == 1 ]; do
                # Sleep so it's possible to kill this
        #         sleep 1

                # check file doesn't exist
                if [ ! -f "${GRAB_FILE}" ]; then
                    echo "Playlist file ${GRAB_FILE} not found"
                    continue
                fi
    
                # Get the top of the playlist
                cont=$(cat "${GRAB_FILE}" | head -n1)
    
                # And strip it off the playlist file
                cat "${GRAB_FILE}" | tail -n+2 > "${GRAB_FILE}.new"
                mv "${GRAB_FILE}.new" "${GRAB_FILE}"

                # Skip if this is empty
                if [ -z "${cont}" ]; then
                    echo "Playlist empty or bumped into an empty entry for some reason"

                    # added by Kevin: exit clean if empty
                    x=0

#                    continue

                fi

                # Check that the file exists
        #         if [ ! -f "${cont}" ]; then
        #                 echo "Playlist entry ${cont} not found"
        #                 continue
        #         fi

                clear
                echo
                echo "Getting ${cont} ..."
                echo

                if [ ! -f "$HOME/mp4/${cont}" ]; then
        #         "${PLAYER}" ${PLAYER_OPTIONS} "${cont}" > /dev/null
                    wget -N -nd -w 3 -P $HOME/mp4 --limit-rate=50k "http://192.168.200.6/files/mp4/${cont}"
                fi


                echo
                echo "File complete, continuing to next item."
                echo

            done
            rm ${GRAB_FILE}
        fi

# possible method for creating new playlist
# find "$(pwd)/aud" -maxdepth 1 -type f

#         wget -r -nd -nc -l 2 -w 3 -A mp4 -P $HOME/mp4 http://192.168.200.6/files/

#         wget -r -nd -nc -l 2 -w 3 -A mp3 -P $HOME/aud http://192.168.200.6/files/


        echo "Done syncing." >> log.txt
        echo "Removing running token."  >> log.txt
        echo $(date +"%T") >> log.txt
        rm "${HOME}/syncing"

    # Else do nothing files
    #    else
    #        echo "Already syncing!"
    fi

    if [ -f "${AEBL_TEST}" ] || [ -f "${AEBL_SYS}" ]; then
        echo "Done sync filz." >> log.txt
        echo $(date +"%T") >> log.txt
    fi

fi

#Check network before syncing
if [ -f "${HOME}/.ihdnfol26" ] && [ ! -f "${OFFLINE_SYS}" ]; then
    rm index*

    # Check if not syncing
    # should append syncing to syncing file and dump it to dropbox

    if [ ! -f "${HOME}/syncing" ]; then
        echo "Currently not syncing." >> log.txt
        echo "Making running token."  >> log.txt
        echo $(date +"%T") >> log.txt

        touch "${HOME}/syncing"

        rm mychan

        curl -o "$HOME/chan26.m3u" -k -u videouser:password "sftp://184.71.76.158:8022/home/videouser/videos/000026/chan26.m3u"

        cp chan26.m3u mychan

        rm chan26.m3u

        wget -N -nd -w 3 -P $HOME/scripts --limit-rate=50k "https://www.dropbox.com/s/vtm7naqg4sbq2wh/ihdn_tests.sh"

        GRAB_FILE="${HOME}/mychan"

        x=1

        if [ ! -d "tmp" ]; then
            mkdir tmp
        fi

        while [ $x == 1 ]; do
            # Sleep so it's possible to kill this
    #         sleep 1

            # check file doesn't exist
            if [ ! -f "${GRAB_FILE}" ]; then
                echo "Playlist file ${GRAB_FILE} not found"
                continue
            fi
    
            # Get the top of the playlist
            cont=$(cat "${GRAB_FILE}" | head -n1)
    
            # And strip it off the playlist file
            cat "${GRAB_FILE}" | tail -n+2 > "${GRAB_FILE}.new"
            mv "${GRAB_FILE}.new" "${GRAB_FILE}"

            # Skip if this is empty
            if [ -z "${cont}" ]; then
                echo "Playlist empty or bumped into an empty entry for some reason"

                # added by Kevin: exit clean if empty
                x=0

#                 continue

            fi

            # Check that the file exists
    #         if [ ! -f "${cont}" ]; then
    #                 echo "Playlist entry ${cont} not found"
    #                 continue
    #         fi

            clear
            echo
            echo "Getting ${cont} ..."
            echo
            if [ ! -f "$HOME/mp4/${cont}" ]; then

    #         "${PLAYER}" ${PLAYER_OPTIONS} "${cont}" > /dev/null
                curl -z "$HOME/mp4/${cont}" -o "$HOME/mp4/${cont}" -k -u videouser:password "sftp://184.71.76.158:8022/home/videouser/videos/000026/${cont}"
            fi

            echo
            echo "File complete, continuing to next item."
            echo

        done
        rm ${GRAB_FILE}
    fi

# possible method for creating new playlist
# find "$(pwd)/aud" -maxdepth 1 -type f

#         wget -r -nd -nc -l 2 -w 3 -A mp4 -P $HOME/mp4 http://192.168.200.6/files/

#         wget -r -nd -nc -l 2 -w 3 -A mp3 -P $HOME/aud http://192.168.200.6/files/


    echo "Done syncing." >> log.txt
    echo "Removing running token."  >> log.txt
    echo $(date +"%T") >> log.txt
    rm "${HOME}/syncing"

# Else do nothing files
#    else
#        echo "Already syncing!"
fi

# tput clear
exit 0
