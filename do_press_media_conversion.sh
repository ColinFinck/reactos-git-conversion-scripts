#!/bin/bash
# Call this script like: ./do_press_media_conversion.sh &> conversion-log

#
# Step 1: Cleanup
#
rm -f log-press-media
rm -rf press-media

#
# Step 2: Conversion
#
SECONDS=0
./svn-all-fast-export ~/press-media_svnsync --rules press-media-rules --add-metadata --empty-dirs --identity-map reactos-identity-map
echo "Conversion took $SECONDS seconds"

#
# Step 3: Recompression
#
SECONDS=0
cd press-media
git repack -a -d -f
echo "Recompression of web took $SECONDS seconds"
cd ..
