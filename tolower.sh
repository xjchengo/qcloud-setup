#!/bin/bash
#convert all the filenames in some directory to lowercase
#-n just display the changes and don't change actually
find_file () {
    directory=$1
    if [ -d "$directory" ];then
        for file in "$directory"/*
        do
            if [ -d "$file" ];then
                find_file "$file"
            else
                echo $file
            fi
        done
    else
        echo $directory
    fi
}

notolower=false
while getopts n OPTION
do
    case $OPTION in
        n)
            notolower=true
            ;;
    esac
done

shift $(($OPTIND - 1))

if [ "$#" -gt 0 ];then
    directory=${1%/}
else
    directory=`pwd`
fi

for file in `find_file $directory`
do
    current_dir=`dirname $file`
    current_base=`basename $file`
    new_base=${current_base%\~}
    new_base=${new_base,,}
    if [ "$notolower" = false ];then
        mv ${current_dir}/{$current_base,$new_base}
    fi
    echo "$current_dir/$current_base renamed $current_dir/$new_base"
done