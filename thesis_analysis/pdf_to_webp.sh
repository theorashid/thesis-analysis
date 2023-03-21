#!/bin/sh

files=$(find . -type f -name '*.pdf')

for file in $files ; do
    echo $file ;
    magick -density 1200 -quality 100 $file ${file%.pdf}.webp
done
