#! /usr/bin/env bash


export RED="\033[0;31m"
export GREEN="\033[0;32m"
export BLUE="\033[0;34m"
export CYAN="\033[0;36m"
export YELLOW="\033[1;33m"
export NC="\033[0m"

# Config
: "${ASDF_DEVTOOLS_SHORTHAND_REPO_PATTERN:="https://github.com/%s.git"}"

if [ -n "$ASDF_CMD_FILE" ]; then
	export PLUGIN_HOME="$(printf "%s\n" "${ASDF_CMD_FILE%%/lib/commands/*}")"
else
	PLUGIN_HOME="${BASH_SOURCE[0]}"

	if ! expr "$PLUGIN_HOME" : / &> /dev/null; then
		PLUGIN_HOME="$PWD/$PLUGIN_HOME"
	fi

	export PLUGIN_HOME="${PLUGIN_HOME%%/lib/*}"
fi

export PLUGIN_NAME="$(basename "$PLUGIN_HOME")"
export CMD_PATH="$(basename "$ASDF_CMD_FILE" | sed 's/^command-//g; s/\.bash//g; s/-/ /g')"

# Common variables
export ASDF_DEVTOOLS_PLUGIN_NAME=
export ASDF_DEVTOOLS_REPO_URL=
export ASDF_DEVTOOLS_REMOTE_NAME=
export ASDF_DEVTOOLS_BRANCH_NAME=

# Usage: extract_git_metadata [PLUGIN_NAME] REPO
#
# Export git and plugin variables from a repo query
#
#   REPO  Can be a absolute git url https or ssh or by in the format user/repository,
#         in that case ASDF_DEVTOOLS_SHORTHAND_REPO_PATTERN will be used to
#         format it into a repository url, by default it builds a a github https url
extract_git_metadata() {
	local query="$1" repo_url= plugin_name= remote_name= branch=

	if [ $# -gt 1 ]; then
		query="$2"
		plugin_name="$1"
	fi

	repo_url="${query%%\#*}"

	# Shorthand format
	if expr "$repo_url" : "[a-Z-][a-Z-]*/[a-Z-][a-Z-]*" &> /dev/null; then
		repo_url="$(printf "$ASDF_DEVTOOLS_SHORTHAND_REPO_PATTERN" "$repo_url")"
	fi

	local repo_project="$repo_url"

	# Try to strip url components
	repo_project="${repo_project#http*://*/}" # http syntax
	repo_project="${repo_project#*:}" # ssh syntax

	# Text after # branch syntax
	branch_name="${query##*\#}"

	# Defaults to master
	if [ "$branch_name" = "${repo_project%%.git}" ]; then
		branch_name=master
	fi

	# Strips # branch syntax
	repo_project="${repo_project%%\#*}"
	
	# Strips .git
	repo_project="${repo_project%%.git}"

	if [ -z "$plugin_name" ]; then
		# Strip asdf-prefix, rarely used in the plugin name de facto
		plugin_name="${repo_project##*/}"
		plugin_name="${plugin_name##asdf-}"
	fi

	remote_name="${repo_project%%/*}"

	export ASDF_DEVTOOLS_PLUGIN_NAME="$plugin_name" \
		ASDF_DEVTOOLS_REPO_URL="$repo_url" \
		ASDF_DEVTOOLS_REMOTE_NAME="$remote_name" \
		ASDF_DEVTOOLS_BRANCH_NAME="$branch_name"
}
