#!/bin/sh

# This file needs to be indented by tabs, because of <<-

installed_version=$(
	awk -f - ~/.local/share/OpenSCAD/libraries/BOSL2/version.scad <<-'AWK_END'
		match($0, /BOSL_VERSION = \[([[:digit:]]+),([[:digit:]]+),([[:digit:]]+)\]/, m) {
			printf("v%i.%i.%i", m[1], m[2], m[3])
		}
	AWK_END
)

latest_version=$(
	gh -R BelfrySCAD/BOSL2 release list --json isLatest,name --jq 'map(select(.isLatest))|first|.name'
)

echo
echo "Installed BOSL2 version: $installed_version"
echo "Latest BOSL2 version: $latest_version"
echo

if [ "$installed_version" = "$latest_version" ] ; then
	echo "Latest version of BOSL2 is installed."
else
	echo "BOSL2 is outdated."
fi

echo
