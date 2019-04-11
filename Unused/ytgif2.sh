#!/bin/bash


ID=$1

START=$2
LENGTH=$3
NAME=$4

echo "$3"
echo "$2"
echo "$4"


youtube-dl -f 'best[height<=720][ext=mp4]' --no-playlist -o 'dl.%(ext)s' $ID



# ffmpeg -i $(youtube-dl -f 136 --no-playlist --get-url $ID) -ss $START -t $LENGTH -c:v copy -c:a copy $NAME.mp4

# fetch the video file with youtube-dl
# convert it to MP4 (not really needed, but keeps the filename predictable)
# if [ ! -f $ID.mp4 ]; then
#   youtube-dl --output '%(id)s.%(ext)s' --recode-video mp4 $ID
# fi
# 
# # convert the video file to GIF with ffmpeg
# START='00:00:20.000' # start 20 seconds in
# LENGTH='00:00:06.000' # end after 6 seconds
# SIZE='400x300' # size of the output GIF
# ffmpeg -ss $START -i $ID.mp4 -pix_fmt rgb24 -r 10 -s $SIZE -t $LENGTH $ID-unoptimized.gif

ffmpeg -ss "$START" -t "$LENGTH" -i dl.mp4 -filter_complex "[0:v] palettegen" palette.png
ffmpeg -ss "$START" -t "$LENGTH" -i dl.mp4 -i palette.png -filter_complex "[0:v][1:v] paletteuse" "$NAME".gif

# mv dl.gif "$NAME".gif
echo "Removing files..."
rm dl.mp4
rm palette.png
echo "Done"

# optimize the GIF with imagemagick
# convert -layers Optimize $ID-unoptimized.gif $ID.gif

# credits:
# http://www.commandlinefu.com/commands/view/10002/create-an-animated-gif-from-a-youtube-video
# http://superuser.com/a/436109/106809
# https://gist.github.com/hubgit/636946
# https://engineering.giphy.com/how-to-make-gifs-with-ffmpeg/
