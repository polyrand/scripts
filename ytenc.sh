#!/usr/bin/env bash

# source: https://gist.github.com/mikoim/27e4e0dc64e384adbcb91ff10a2d3678

# AAC_ENCODER=libfdk_aac
AAC_ENCODER=aac

CUT_PARAMS=""
AUDIO_PARAMS="-c:a $AAC_ENCODER -profile:a aac_low -b:a 384k"
VIDEO_PARAMS="-pix_fmt yuv420p -c:v libx264 -profile:v high -preset slow -crf 18 -g 30 -bf 2"
CONTAINER_PARAMS="-movflags faststart"

# You need to adjust the GOP length to fit your source video.
# 60 fps -> -g 30
# 23.976 (24000/1001) -> -g 24000/1001/2  (???) <- plz comment

ffmpeg -i "$1" $CUT_PARAMS $AUDIO_PARAMS $VIDEO_PARAMS $CONTAINER_PARAMS "$2"
