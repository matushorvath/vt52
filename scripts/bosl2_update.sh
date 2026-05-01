#!/bin/sh

# Usage:
# bosl2_update.sh
# bosl2_update.sh --install
# bosl2_update.sh --update

# This file needs to be indented by tabs, because of <<-

set -e

script_dir="$(dirname "$(readlink -f -- "$0")")"

BOSL2_DIR=~/.local/share/OpenSCAD/libraries/BOSL2
VERSION_YAML=$script_dir/../bosl2_version.yaml

# Collect version information

requested_version=$(
	yq '.version' < "$VERSION_YAML"
)
echo "Requested BOSL2 version: $requested_version"

installed_version=$(
	if [ -d "$BOSL2_DIR" ] ; then
		awk -f - "$BOSL2_DIR/version.scad" <<-'AWK_END'
			match($0, /BOSL_VERSION = \[([[:digit:]]+),([[:digit:]]+),([[:digit:]]+)\]/, m) {
				printf("%i.%i.%i", m[1], m[2], m[3])
			}
		AWK_END
	else
		echo "none"
	fi
)
echo "Installed BOSL2 version: $installed_version"

latest_version=$(
	gh -R BelfrySCAD/BOSL2 release list --json isLatest,name --jq 'map(select(.isLatest))|first|.name[1:]'
)
echo "Latest BOSL2 version: $latest_version"

install_bosl2() {
	local version=$1

	temp_file=$(mktemp -t bosl2-XXXXXXXX.tar.gz)
	wget --output-document "${temp_file}" "https://github.com/BelfrySCAD/BOSL2/archive/refs/tags/v${version}.tar.gz"

	old_dir=$(mktemp -d)
	[ -e "${BOSL2_DIR}" ] && mv "${BOSL2_DIR}" "${old_dir}"
	mkdir -p "${BOSL2_DIR}"

	tar -xzf "${temp_file}" --directory="${BOSL2_DIR}" --strip-components=1

	rm -rf "${old_dir}"
	rm -f "${temp_file}"
}

# Perform requested action, if any

if [ "$1" = "--install" ] ; then
	echo
	if [ "$installed_version" != "$requested_version" ] ; then
		install_bosl2 $requested_version
		echo "BOSL2 updated to requested version: $requested_version"
	else
		echo "Requested version of BOSL2 is already installed"
	fi
elif [ "$1" = "--update" ] ; then
	echo
	if [ "$installed_version" != "$latest_version" ] ; then
		install_bosl2 $latest_version
		echo "BOSL2 updated to latest version: $latest_version"
	else
		echo "Latest version of BOSL2 is already installed"
	fi

	if [ "$requested_version" != "$latest_version" ] ; then
		yq  -i ".version = \"$latest_version\"" $VERSION_YAML
		echo "Requested version of BOSL2 set to latest version"
	else
		echo "Requested version of BOSL2 is already the latest version"
	fi
fi
