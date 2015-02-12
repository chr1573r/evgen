#!/bin/sh
# run like this:
#	./evgen.sh "Østsia" "17. november, Kl. 18.00-22.00" "Åpent for alle!"
echo Lager overlay med teksten:

echo
echo $1
echo $2
echo $3
echo $(pwd)

convert -background transparent -fill grey100 -font Typomodernobold -size 784x295  -pointsize 24 -gravity southeast label:"$1 \n $2 \n $3 \n" ./static/output.png ; composite -quality 100 ./static/output.png ./static/kodekveld_nusize_blank.png ./static/output.png
echo
echo Ferdig!
