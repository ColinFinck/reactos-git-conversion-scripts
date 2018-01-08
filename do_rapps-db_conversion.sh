#!/bin/bash
# Call this script like: ./do_rapps-db-conversion.sh &> conversion-log

#
# Step 1: Cleanup
#
rm -f log-rapps-db
rm -rf rapps-db

#
# Step 2: Conversion
#
SECONDS=0
./svn-all-fast-export ~/reactos_svnsync --rules rapps-db-rules --add-metadata --empty-dirs --identity-map reactos-identity-map
echo "Conversion took $SECONDS seconds"

#
# Step 3: Recompression
#
SECONDS=0
cd rapps-db
git repack -a -d -f
echo "Recompression of rapps-db took $SECONDS seconds"
cd ..
