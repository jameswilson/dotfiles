#!/bin/bash

#
# script requires mplayer and lame!
#

for i in *.wma do mplayer -ao pcm -aofile "${i%.wma}.wav" "$i" && lame --preset hifi "${i%.wma}.wav" "${i%.wma}.mp3"
rm "${i%.wma}.wav"
done
