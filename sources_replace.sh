#!/bin/bash
# replace default sources.list with 
# 163_sources.list to get faster
# installation speed.
ROOT_UID=0
E_NOTROOT=87

# Run as root
if [ "$UID" -ne "$ROOT_UID" ]
then
    echo "Must be root to run this script" >&2
    exit $E_NOTROOT
fi


new_sources_list_file='163_sources.list'

# if execute the script with argument
# take first argument as new sources list file
if [ "$#" -ge '1' ]
then
    new_sources_list_file=$1
fi

# check if the replaced script exits
if [ ! -e "$new_sources_list_file" ]
then
    echo "$new_sources_list_file doesn't exit" >&2
    exit 1
fi

# backup original sources list
sudo mv /etc/apt/sources.list /etc/apt/sources.list.backup

cp "$new_sources_list_file" /etc/apt/sources.list || {
    echo "copy $new_sources_list_file failed" >&2
    exit 1
}

sudo apt-get update