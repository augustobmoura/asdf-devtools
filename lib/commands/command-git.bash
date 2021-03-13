#! /usr/bin/env bash

set -eu
set -o pipefail

DEVTOOLS_NAME="$(basename "${BASH_SOURCE[0]/\/lib\/commands\/*}")"

print_usage() {
	printf "%s" "\
Usage: asdf $DEVTOOLS_NAME git [PLUGIN] [ARGS...]

Executes git in PLUGIN with ARGS. PLUGIN is required if the ASDF_DEVTOOLS_PLUGIN_NAME variable is not defined
"
}

main() {
	if [ -z "${ASDF_DEVTOOLS_PLUGIN_NAME-}" ] && [ $# -lt 1 ]; then
		print_usage && exit 1
	fi

	local data_dir="${ASDF_DATA_DIR:-$ASDF_DIR}"
	local plugin="${ASDF_DEVTOOLS_PLUGIN_NAME-}"

	if [ -z "$plugin" ]; then
		plugin="$1"
		shift
	fi

	git -C "$data_dir/plugins/$plugin" "$@"
}

main "$@"
