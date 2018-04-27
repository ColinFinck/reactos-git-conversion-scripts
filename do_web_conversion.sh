#!/bin/bash
# Call this script like: ./do_web_conversion.sh &> conversion-log

#
# Step 1: Cleanup
#
rm -f log-web
rm -rf web

#
# Step 2: Conversion
#
SECONDS=0
./svn-all-fast-export ~/web_svnsync --rules web-rules --add-metadata --empty-dirs --identity-map reactos-identity-map
echo "Conversion took $SECONDS seconds"

#
# Step 3: Recompression
#
SECONDS=0
cd web
git repack -a -d -f
echo "Recompression of web took $SECONDS seconds"
cd ..
