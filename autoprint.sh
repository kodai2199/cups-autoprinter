#!/bin/bash
echo "[$(date +'%Y-%m-%d %T')] SCRIPT STARTED"
cd to_print
shopt -s nullglob
while :
do
    HOUR="$(date +'%H')"
    DAY="$(date +'%u')"
    if [ $HOUR -ge $WORK_START_HOUR -a $HOUR -lt $WORK_STOP_HOUR -a $DAY -ge $WORK_START_DAY -a $DAY -lt $WORK_STOP_DAY ] ; then
        for file in ./*.pdf;
        do
            echo "[$(date +'%Y-%m-%d %T')] Printing $file, and moving it to the respective folder"
            lp "$file"
            mv "$file" "../printed/$file"
        done
    fi
    sleep 10
done