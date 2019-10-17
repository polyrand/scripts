#!/bin/bash


if [ $# -eq 0 ]; then
    echo "Usage: ytc [ID] [START] [LENGTH] [NAME] [SPEED]
Example: ytc rHLEWRxRGiM 00:01:30 15 test 1.5 ¿sound?"
    exit 1
fi

ID=$1
START=$2
LENGTH=$3
NAME=$4
SPEED=$5

echo "Downloading video with ID: $ID"
echo "Start time: $START"
echo "Lenght: $LENGTH"
echo "Speed: $SPEED"


youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' --no-playlist -o 'dl.%(ext)s' $ID



if [ $6 == 'sound' ]; then
    ffmpeg -ss "$START" -t "$LENGTH" -i dl.mp4 "$NAME".mp4
else
    ffmpeg -ss "$START" -t "$LENGTH" -i dl.mp4 -an -vf "setpts=(1/"$SPEED")*PTS" "$NAME".mp4
fi


echo " ===> Removing files..."
rm dl.mp4
echo " ===> Done! "
