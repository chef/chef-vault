#!/usr/bin/env bash

# Uploads the aarch64-darwin (macOS Apple Silicon) habitat package to the
# habitat builder. This runs on the same macOS Anka VM after the build step.

set -euo pipefail

export HAB_ORIGIN='chef'
export CHEF_LICENSE="accept-no-persist"
export HAB_LICENSE="accept-no-persist"
export HAB_NONINTERACTIVE="true"

error () {
  local message="$1"
  echo -e "\nERROR: ${message}\n" >&2
  exit 1
}

echo "--- Downloading aarch64-darwin package artifact"
PKG_ARTIFACT=$(buildkite-agent meta-data get "CHEF_VAULT_HAB_ARTIFACT_DARWIN_AARCH64")
buildkite-agent artifact download "$PKG_ARTIFACT" . || error 'unable to download aarch64-darwin artifact'

echo "--- :habicat: Uploading aarch64-darwin package to habitat builder (unstable channel)"
hab pkg upload "$PKG_ARTIFACT" --auth "$HAB_AUTH_TOKEN" --channel unstable || error 'unable to upload aarch64-darwin package to habitat builder'
