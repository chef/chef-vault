## Unreleased

## v2.0.0 / 2013-08-20
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

## Released 

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

