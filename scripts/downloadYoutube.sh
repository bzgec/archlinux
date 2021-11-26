#!/bin/bash

declare -a videos=(
    "YOUR_VIDEOS"
    "HERE"
)

userName="PLATFORM_USERNAME"
userPass="PLATFORM_PASSWORD"

SEPARATOR="##################################################"


for video in "${videos[@]}"
do
    echo ${SEPARATOR}
    echo "Downloading ${video}"

    if youtube-dl -u ${userName} -p ${userPass} "${video}" ; then
        echo ${SEPARATOR}
        echo "Video downloaded successfully: ${video}"
    else
        echo ${SEPARATOR}
        echo "FAILED to downloaded video: ${video}"
        exit $?
    fi
done

echo ${SEPARATOR}
echo "Done downloading all videos :)"
