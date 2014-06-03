## Planned (Unreleased)

## Released
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

