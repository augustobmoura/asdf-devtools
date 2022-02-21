#! /usr/bin/env bash

set -ue
set -o pipefail

: "${ASDF_CMD_FILE:=${BASH_SOURCE[0]:-$0}}"

PLUGIN_HOME="$(printf "%s\n" "${ASDF_CMD_FILE/\/lib\/commands\/*}")"

. "$PLUGIN_HOME/lib/common.sh"

ERR_MISSING_ARGUMENTS=1

print_usage() {
  printf "\
Usage: asdf %s {--all | <plugin>} []
Aliases: alternative reset, alt reset

Resets plugin to the most recent offical revision, alias to \`asdf plugin-update\`
" "$PLUGIN_NAME $CMD_PATH"
}

if [ $# -lt 1 ]; then
  print_usage
  exit $ERR_MISSING_ARGUMENTS
fi

asdf plugin-update "$@" || exit $?
