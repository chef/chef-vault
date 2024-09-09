pkg_name=chef-vault
pkg_origin=core
pkg_version="4.1.12"
pkg_description="Gem that allows you to encrypt a Chef Data Bag Item using the public keys of a list of chef nodes. This allows only those chef nodes to decrypt the encrypted values."
pkg_license=('Apache-2.0')
pkg_deps=(
  core/ruby31
  core/bash
  core/git
)
pkg_build_deps=(
  core/gcc
  core/make
)
pkg_bin_dirs=(bin)

# Setup environment variables for Ruby Gems
do_setup_environment() {
  build_line "Setting up GEM_HOME and GEM_PATH"
  export GEM_HOME="$pkg_prefix/lib"
  export GEM_PATH="$GEM_HOME"
}

# Unpack the source files into the cache directory
do_unpack() {
  local unpack_dir="$HAB_CACHE_SRC_PATH/$pkg_dirname"
  build_line "Creating unpack directory: $unpack_dir"
  mkdir -pv "$unpack_dir"
  cp -RT "$PLAN_CONTEXT"/.. "$unpack_dir/"
}

# Build the gem from the gemspec file
do_build() {
  build_line "Building the gem from the gemspec file"
  pushd "$HAB_CACHE_SRC_PATH/$pkg_dirname" > /dev/null
  gem build chef-vault.gemspec
  popd > /dev/null
}

# Install the built gem into the package directory
do_install() {
  build_line "Installing the gem"
  pushd "$HAB_CACHE_SRC_PATH/$pkg_dirname" > /dev/null
  gem install chef-vault-*.gem --no-document
  popd > /dev/null

  wrap_chef_vault_bin
}

# Create a wrapper script to properly set paths and execute the chef-vault command
wrap_chef_vault_bin() {
  local bin="$pkg_prefix/bin/chef-vault"
  local real_bin="$GEM_HOME/gems/chef-vault-${pkg_version}/bin/chef-vault"
  build_line "Adding wrapper $bin to $real_bin"

#   build_line "Creating wrapper script: $bin"
  cat <<EOF > "$bin"
#!$(pkg_path_for core/bash)/bin/bash
set -e

# Set the PATH for chef-vault to include necessary binaries
export PATH="/sbin:/usr/sbin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:\$PATH"

# Set Ruby paths defined from 'do_setup_environment()'
export GEM_HOME="$GEM_HOME"
export GEM_PATH="$GEM_PATH"

# Execute the chef-vault binary
exec $(pkg_path_for core/ruby31)/bin/ruby $real_bin "\$@"
EOF

  # Ensure the wrapper script is executable
  chmod -v 755 "$bin"
}

# No additional stripping needed
do_strip() {
  return 0
}