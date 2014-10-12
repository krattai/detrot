#!/usr/bin/env bash
#
# Add files to playlist
#
# Copyright Â© 2013 Janne Enberg http://lietu.net/
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
#
# Copyright (C) 2014 IHDN, Uvea I. S., Kevin Rattai
#
# Eventually, it would be nice to have this script create
# log or file to indicate that it completed successfully
# this would be the last command before a the script exits
# on a success rather than a fail exit

# Where is the playlist
PLAYLIST_FILE="${HOME}/.playlist"


# Check for proper usage
if [ $# -eq 0 ]; then
        echo "
Adds files to the system playlist (${PLAYLIST_FILE})

Usage:
  playlist *.avi
  playlist /path/to/futurama/*/*

"

        exit 1
fi

# Loop through arguments given
for entry in "$@"; do
        if [ ! -f "${entry}" ]; then
                echo "Invalid entry, ${entry} .. skipping"
                continue
        fi

        # Get full path to the file
        fullPath=$(readlink -f -- "${entry}")

        # Append file to playlist
        echo "${fullPath}" >> "${PLAYLIST_FILE}"
        echo "Added ${fullPath} to system playlist"
done

