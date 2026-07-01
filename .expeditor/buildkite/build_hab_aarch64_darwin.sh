#!/usr/bin/env bash

# Builds the macOS Apple Silicon (aarch64-darwin) chef-vault habitat package.
# Expeditor's built-in habitat/build pipeline does not support aarch64-darwin
# targets, so this script handles the build on a native macOS ARM Anka VM.
#
# Prerequisites (provided by the Anka VM image):
#   - macOS on Apple Silicon (ARM64)
#   - Xcode Command Line Tools (provides git)
#   - Homebrew (for any additional dependencies)

set -euo pipefail

export HAB_ORIGIN='chef'
export PLAN='chef-vault'
export CHEF_LICENSE="accept-no-persist"
export HAB_LICENSE="accept-no-persist"
export HAB_NONINTERACTIVE="true"
export HAB_BLDR_CHANNEL="base-2025"
export HAB_REFRESH_CHANNEL="base-2025"

echo "--- :git: Checking for git"
if ! command -v git &> /dev/null; then
  echo "Git is not installed. Installing via Xcode Command Line Tools..."
  xcode-select --install 2>/dev/null || true
  # Wait for installation to complete
  until command -v git &> /dev/null; do sleep 5; done
else
  echo "Git is already installed."
  git --version
fi

echo "--- :mac: Installing Habitat"
curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo bash -s -- -t aarch64-darwin

hab_binary="/usr/local/bin/hab"
echo "--- :habicat: Hab binary: ${hab_binary} (version: $(${hab_binary} --version))"

echo "--- :key: Downloading origin keys"
${hab_binary} origin key download "$HAB_ORIGIN"
${hab_binary} origin key download "$HAB_ORIGIN" --secret

# Copy keys to system hab cache so they're available for root builds
sudo mkdir -p /hab/cache/keys
sudo cp -r ~/.hab/cache/keys/* /hab/cache/keys/ 2>/dev/null || true

echo "--- :construction: Building $PLAN aarch64-darwin package"
${hab_binary} pkg build . --refresh-channel base-2025

project_root="$(pwd)"
source "${project_root}/results/last_build.env" || { echo "ERROR: unable to determine build details"; exit 1; }

echo "--- :package: Uploading artifact to Buildkite"
cd "${project_root}/results"
buildkite-agent artifact upload "$pkg_artifact" || { echo "ERROR: unable to upload artifact"; exit 1; }

echo "--- Setting CHEF_VAULT_HAB_ARTIFACT_DARWIN_AARCH64 metadata for buildkite agent"
buildkite-agent meta-data set "CHEF_VAULT_HAB_ARTIFACT_DARWIN_AARCH64" "$pkg_artifact"
