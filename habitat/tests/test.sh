#!/bin/bash

set -euo pipefail

project_root="$(git rev-parse --show-toplevel)"

# print error message followed by usage and exit
error () {
  local message="$1"

  echo -e "\nERROR: ${message}\n" >&2

  exit 1
}
echo "--- :mag_right: Starting the testing"

[[ -n "$pkg_ident" ]] || error 'no hab package identity provided'

package_version=$(awk -F / '{print $3}' <<<"$pkg_ident")

cd "${project_root}"

echo "--- :mag_right: Testing ${pkg_ident} executables"
help_message=$(hab pkg exec "${pkg_ident}" -- chef-vault -h)
original_help="Usage: chef-vault"
[[ $help_message =~ $original_help ]] || error "chef-vault help command is not as expected"
