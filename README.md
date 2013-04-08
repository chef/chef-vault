# Chef-Vault

## DESCRIPTION:

Gem that allows you to encrypt passwords & certificates using the public key of
a list of chef nodes.  This allows only those chef nodes to decrypt the 
password or certificate.

## INSTALLATION:

Be sure you are running the latest version Chef. Versions earlier than 0.10.0
don't support plugins:

    gem install chef

This plugin is distributed as a Ruby Gem. To install it, run:

    gem install chef-vault

Depending on your system's configuration, you may need to run this command with 
root privileges.

## CONFIGURATION:

## KNIFE COMMANDS:

This plugin provides the following Knife subcommands.  
Specific command options can be found by invoking the subcommand with a 
<tt>--help</tt> flag

### knife encrypt password

Use this knife command to encrypt the username and password that you want to
protect.

    knife encrypt password --search SEARCH --username USERNAME --password PASSWORD --admins ADMINS


### knife decrypt password

Use this knife command to dencrypt the password that is protected

    knife decrypt password --username USERNAME

### knife encrypt cert

Use this knife command to encrypt the contents of a certificate that you want
to protect.

    knife encrypt cert --search SEARCH --cert CERT --password PASSWORD --name NAME --admins ADMINS

### knife decrypt cert

Use this knife command to decrypt the certificate that is protected

    knife decrypt cert --name NAME

## USAGE IN RECIPES

To use this gem in a recipe to decrypt data you must first install the gem
via a chef_gem resource.  Once the gem is installed require the gem and then
you can create a new instance of ChefVault.

### Example Code (password)

```ruby
chef_gem "chef-vault"

require 'chef-vault'

vault # ChefVault.new("passwords")
user # vault.user("Administrator")
password # user.decrypt_password
```

### Example Code (certificate)

```ruby
chef_gem "chef-vault"

require 'chef-vault'

vault # ChefVault.new("certs")
cert # vault.certificate("domain.com")
contents # cert.decrypt_contents
```

## LICENSE:

Author:: Kevin Moser (<kevin.moser@nordstrom.com>)
Copyright:: Copyright (c) 2013 Nordstrom, Inc.
License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
