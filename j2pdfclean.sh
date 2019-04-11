#!/bin/bash

# FOLDER="$1"
if [ $# -eq 0 ]; then
    echo "Usage: j2pdfclean [PATH] ==> Example: j2pdfclean /Users/r/Desktop/Folder/*.jpg"
    exit 1
fi

for file in "$@"; do
    exiftool -all= "$file"
done

#cd "$1"
#rm *_original

# for file in "$1"_original; do
#     rm "$file"
# done

#if (("${@: -1}" == 1)); then
echo "=================================================="
echo "=================================================="
echo "=================================================="
echo "======== Checking proper metadata removal ========"
echo "=================================================="
echo "=================================================="
echo "=================================================="
for data in "$@"; do
    exiftool "$data"
    echo " ############################################### " 
    echo " ############################################### "
    echo " ############################################### "
    echo " ############################################### "
done
#fi

convert -compress jpeg "$@" output.pdf

exiftool -all= output.pdf
rm output.pdf_original
exiftool output.pdf
