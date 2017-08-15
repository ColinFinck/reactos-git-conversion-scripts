#!/bin/bash
rm -f log-reactos
rm -rf reactos

SECONDS=0
./svn-all-fast-export ~/reactos_svnsync --rules reactos-rules --add-metadata --empty-dirs --identity-map reactos-identity-map > conversion-log 2>&1
echo "Conversion took $SECONDS seconds"

SECONDS=0
cd reactos
git repack -a -d -f
echo "Recompression took $SECONDS seconds"
