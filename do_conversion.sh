#!/bin/bash
# Call this script like: ./do_conversion.sh &> conversion-log

#
# Step 1: Cleanup
#
rm -f log-documentation
rm -f log-reactos
rm -rf documentation
rm -rf documentation_clone
rm -rf reactos
rm -rf reactos_clone

#
# Step 2: Conversion
#
SECONDS=0
./svn-all-fast-export ~/reactos_svnsync --rules reactos-rules --add-metadata --empty-dirs --identity-map reactos-identity-map
echo "Conversion took $SECONDS seconds"

#
# Step 3: Recompression
#
SECONDS=0
cd documentation
git repack -a -d -f
echo "Recompression of documentation took $SECONDS seconds"
cd ..

SECONDS=0
cd reactos
git repack -a -d -f
echo "Recompression of reactos took $SECONDS seconds"
cd ..

#
# Step 4: First commits
#
git config --global user.name "Colin Finck"
git config --global user.email colin@reactos.org

# r67112 had to be skipped, so moved rosdocs files were not deleted in their original location. Fix that here.
git clone documentation documentation_clone
cd documentation_clone
git rm -r ChangeLog Makefile doxygen dtd readme.dbk readme.txt rules.mk tools tutorials xsl
git commit -m "Git conversion: Fixup files that have been moved to rosdocs"
git push
cd ..

# Make reactos the root directory and shuffle the rest around.
git clone reactos reactos_clone
cd reactos_clone
git mv reactos/* .
git mv rosapps modules
git mv rostests modules
git mv wallpapers modules
git rm -r rossubsys
git commit -m "Git conversion: Make reactos the root directory, move rosapps, rostests, wallpapers into modules, and delete rossubsys."
git push

# Create the 0.4.7-dev tag for git describe.
DEV_HASH=`git log --format="%H" --grep "revision=75445"`
git tag -a -m "Git conversion: Create the 0.4.7-dev tag." "0.4.7-dev" $DEV_HASH
git push --tags
cd ..
