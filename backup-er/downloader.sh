#!/bin/bash

## Cannot currently open-source the rest of this script in good consience because of how insecure it is.

# Get files from Google Drive
# Source: https://stackoverflow.com/a/50573452/2382312
# Usage: ./downloader.sh [ID]

# $1 = file ID
# $2 = file name

URL="https://drive.google.com/uc?export=download&id=$1"
date=$(date +%b-%d-%y)

wget --load-cookies /tmp/cookies.txt "https://drive.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate $URL -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$1" -O backup-$date && rm -rf /tmp/cookies.txt
