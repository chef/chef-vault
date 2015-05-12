## Planned (Unreleased)
## v2.6.0

This release will focus on adding any new features covered by open issues
* ChefVault::Item#clients can now accept a Chef::ApiClient object instead of a search string.  Requested by @lamont-granquist to make implementing chef-vault into `knife bootstrap` easier

* allow Ruby 1.9.3 failures to not cause the overall build to fail on Travis
* switch to latest 2.0.x, 2.1.x, and 2.2.x releases of Ruby

* add --clean-unknown-clients switch to `knife vault refresh`
* as a side effect, `ChefVault::Item` now has a `#refresh` method which can be used to programatically perform the same operation as `knife vault refresh`
* ChefVault::Item#clients can now accept a Chef::ApiClient object instead of a search string.  Requested by @lamont-granquist to make implementing chef-vault into `knife bootstrap` easier
* allow Ruby 1.9.3 failures to not cause the overall build to fail on Travis
* switch to latest 2.0.x, 2.1.x, and 2.2.x releases of Ruby
* enhance 'knife vault show VAULTNAME' (without an item name) to list the names of the items in the vault for parity with 'knife data bag show'
* add #raw_keys to ChefVault::Item that calls #keys on the underlying data bag item.  We can't make ChefVault::Item work like a true hash without breaking the public API, but this at least makes it easier to get a list of keys

## v2.7.0

This release will focus on reducing tech debt:

* improve the coverage of the RSpec suite
* ensure there are Aruba tests for all the subcommands and scenarios that match DEMO.md
* clean up any leftover Rubocop issues

## v2.99.0

This will be the last release in the 2.x branch, and is for anyone who
is constraining to '~> 2.4' (for example).  Anything that we decide to
deprecate for v3.0.0 will produce warnings in this release.

## v3.0.0

This will be a major refactor.  The primary goal is to solve the bootstrap
problem where a vault can't be encrypted for a node until the node has been
created.  Exactly how we will do that is open to discussion (watch the
chef-vault issues on github for news).

This release will also remove the chef-vault 1.x commands (encrypt/decrypt)

## Released
## v2.5.0 / 2015-02-09
* when decrypting, if the vault is encrypted for the node but decryption fails, emit a more friendly error message than 'OpenSSL::PKey::RSAError: padding check failed'
* when attempting to add a client key to a vault item, warn and skip if the node doesn't have a public key (reported by Nik Ormseth)
* add a new 'knife vault list' command that lists the data bags that are vaults
* Add more detailed explanation of how chef-vault works in THEORY.md (Issue #109)
* fix a problem with the --clean-unknown-clients switch to `rotate keys` that made it impossible to delete a client that could not be searched for (i.e. the node object is deleted)
* add rubocop tasks to Rakefile and take a first pass at the low-hanging fruit

## v2.4.0 / 2014-12-03
* add simplecov test coverage configuration (Doug Ireton)
* add --clean-unknown-clients switch to knife remove/rotate (Thomas Gschwind and Reto Hermann)

## v2.3.0 / 2014-10-22
* add --clean switch to knife update (thanks to Matt Brimstone)
* added aruba CLI testing framework (just for --clean option for now)
* add Ruby 2.0.x and 2.1.x to Travis platforms

## v2.2.2 / 2014-06-03
* Add knife vault refresh command
* Use node_name as a default admin
* Add DEMO for users

## v2.2.1 / 2014-02-26
* Add vault_admins to knife.rb for a default set of vault admins

## v2.2.0 / 2014-01-21
* Validate data bag ID before saving
* Add search_query to vault metadata
* Refactor knife commands to be knife vault verb
* Deprecate old knife commands
* Add knife vault show to deprecate knife decrypt
* Print admins, clients and search_query in show with -p
* Add knife vault edit to edit vault items
* Add mode option for knife.rb
* Fix more README typos

## v2.1.0 / 2013-12-23
* Update README to correct typos
* Modify admin loading to fall back to clients endpoint if not found in users endpoint
* Add --file to "knife encrypt update" & "knife encrypt create" to do file encryption in chef-vault.  It will create a key called "file-content" & "file-name"
* When VALUES is not supplied print the whole vault item

## v2.0.2 / 2013-09-10
* Modify written data bag json files in solo mode to be valid for the knife data bag from file command
* Modify knife encrypt remove to automatically rotate keys

## v2.0.1 / 2013-09-03
* Removal of knife encrypt certs
* Removal of knife encrypt passwords
* Add knife encrypt create
* Add knife encrypt update
* Add knife encrypt remove
* Add knife encrypt delete
* Add knife encrypt rotate keys
* Add knife decrypt
* Update chef-vault binary to take -v, -i, -a
* Add ChefVault::Item class
* Add ChefVault::ItemKeys class
* Modify ChefVault::User to use ChefVault::Item to maintain backwards compatability
* Modify ChefVault::Certificate to use ChefVault::Item to maintain backwards compatability

## v1.2.5 / 2013-07-22
* Update compat to be class ChefVault not module ChefVault to remove knife errors
* Allow nodes/clients to be used as Admins

## v1.2.4 / 2013-07-01
* Move compat include into the lazy-load deps
* Modify open file commands in knife commands to avoid file locking on windows

## v1.2.3 / 2013-04-30
* Update to use attr_accessor in chef_vault
* Add rspec tests

## v1.2.2 / 2013-04-23
* Update to create data bag folder if it does not already exist

## v1.2.1 / 2013-04-23
* Clarify Readme

## v1.0.1 / 2013-04-12
* Compatibility with Chef 10/11 (Shef vs Chef-Shell)

## v1.0.0 / 2013-04-08
* Rename from Chef-Keepass to Chef-Vault

## v0.2.1 / 2013-04/05
* Add Certificate class

## v0.2.0 / 2013-04-05
* Add encrypt cert

## v0.1.1 / 2013-03-14
