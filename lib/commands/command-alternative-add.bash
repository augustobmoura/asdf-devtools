#! /usr/bin/env bash

set -ue
set -o pipefail

: "${ASDF_CMD_FILE:=${BASH_SOURCE[0]:-$0}}"

PLUGIN_HOME="$(printf "%s\n" "${ASDF_CMD_FILE/\/lib\/commands\/*}")"

. "$PLUGIN_HOME/lib/common.sh"

# Error codes
ERR_MISSING_ARGUMENTS=1
ERR_REMOTE_ALREADY_EXISTS_AND_IS_INCOMPATIBLE=2

print_usage() {
	printf "\
Usage: asdf %s [<plugin>] <repo_query>
Aliases: alternative add, alternative, alt add, alt

Add and checkouts a remote and alternative repo to the target plugin

  plugin_name  Target plugin to add the alternative repo, if ommited it will be
               deduced from REPO_QUERY as the repo name withtout the asdf-
               prefix if any

  repo_query   A absolute git url or in the format \"user/repo\"
               Eg: asdf-vm/asdf-nodejs, in that case the url will be used using
               the ASDF_DEVTOOLS_SHORTHAND_REPO_PATTERN variable, a
               printf pattern that defaults to a github https url. It can point
               to a specific branch adding #branch_name to the end of the query.
               Eg: asdf-vm/asdf-nodejs#branch_name
" "$PLUGIN_NAME $CMD_PATH"
}

# Plugin git wrapper
pgit() {
	asdf devtools git "$@"
}

ensure_git_remote() {
	local repo_url="${ASDF_DEVTOOLS_REPO_URL:-${1-}}"
	local remote_name="${ASDF_DEVTOOLS_REMOTE_NAME:-${2-}}"

	if ! pgit remote get-url "$remote_name" &> /dev/null; then
		printf "Adding remote %s as %s\n" "$repo_url" "$remote_name"
		pgit remote add "$remote_name" "$repo_url"
	fi

	local current_url="$(pgit remote get-url "$remote_name")"

	if [ "$current_url" != "$repo_url" ]; then
		printf "Remote %s for the repository %s already exists with a different url: %s\n" "$remote_name" "$repo_url" "$current_url"
		return $ERR_REMOTE_ALREADY_EXISTS_AND_IS_INCOMPATIBLE
	fi

	printf "Fetching remote ${YELLOW}%s${NC} ...\n" "$repo_url"
	pgit fetch "$remote_name" || printf "Couldn't fetch remote %s, ignoring for now\n" "$remote_name"
}

checkout_remote_branch() {
	local remote_name="${ASDF_DEVTOOLS_REMOTE_NAME:-${1-}}"
	local remote_branch_name="${ASDF_DEVTOOLS_BRANCH_NAME:-${2-}}"

	local full_name="$remote_name/$branch_name"

	printf "Switching to branch ${BLUE}%s${NC} ...\n" "$full_name"
	pgit checkout "$full_name" &> /dev/null
}

print_available_branches() {
	local remote_name="${ASDF_DEVTOOLS_REMOTE_NAME:-${2-}}"

	printf "Available branches for remote %s:\n" "$remote_name"

	pgit branch -r --list "$remote_name/*"
}

main() {
	if [ $# -lt 1 ]; then
		print_usage
		return $ERR_MISSING_ARGUMENTS
	fi

	extract_git_metadata "$@" || return
	ensure_git_remote || return
	checkout_remote_branch || return
	print_available_branches || return
}

main "$@" || exit $?
