#!/bin/bash

# replaces empty spaces with underscores
# rename 's/\ /_/' *
#   $img =~ s/\s+/_/g;
rename 's/ /_/g' *.png;

# fix shitty images 
for img in `ls *.png`;
do
#   mv "$img" "${img// /_}";
  convert $img \
  -colorspace RGB +sigmoidal-contrast 11.6933 \
  -define filter:filter=Sinc -define filter:window=Jinc -define filter:lobes=3 \
  -sigmoidal-contrast 11.6933 -colorspace sRGB \
  -background white -alpha Background fixed/$img
#   -alpha set\
#   -background none -alpha Background fixed/$img
#   -fuzz XX% -fill none -draw "matte 0,0 floodfill" PNG32:fixed/$img

#   -background white -alpha Background fixed/$img
#   fixed/$img
#   -alpha Background fixed/$img
#   -background white -alpha Background fixed/$img
done

echo "done!"
 
