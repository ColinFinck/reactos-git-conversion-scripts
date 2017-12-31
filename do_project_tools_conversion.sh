#!/bin/bash
# Call this script like: ./do_project_tools_conversion.sh &> conversion-log

REPOS="ahk_tests buildbot_config git-tools irc Message_Translator monitoring packmgr Qemu_GUI reactosdbg Release_Engineering rosev_ircsystem rosev_jameicaplugin RosBE RosTE sysreg2 sysreg3 vmwaregateway project-tools-archive"

#
# Step 1: Cleanup
#
for i in $REPOS; do
	rm -f log-$i
	rm -rf $i
done

#
# Step 2: Conversion
#
SECONDS=0
./svn-all-fast-export ~/project-tools_svnsync --rules project-tools-rules --add-metadata --empty-dirs --identity-map reactos-identity-map
echo "Conversion took $SECONDS seconds"

#
# Step 3: Recompression
#
for i in $REPOS; do
	SECONDS=0
	cd $i
	git repack -a -d -f
	echo "Recompression of $i took $SECONDS seconds"
	cd ..
done
