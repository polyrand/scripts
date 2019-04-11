#!/bin/bash

ID=$1

START=$2
LENGTH=$3
NAME=$4
SPEED=$5

echo "Downloading video with ID: $ID"
echo "Start time: $START"
echo "Lenght: $LENGTH"
echo "Speed: $SPEED"

ffmpeg -ss "$START" -t "$LENGTH" -i "$ID"-r "15" -vf "setpts=(1/"$SPEED")*PTS" "$NAME".gif


