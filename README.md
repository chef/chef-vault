# Chef-Vault
[![Gem Version](https://badge.fury.io/rb/chef-vault.png)](http://badge.fury.io/rb/chef-vault)

[![Build Status](https://travis-ci.org/Nordstrom/chef-vault.png?branch=master)](https://travis-ci.org/Nordstrom/chef-vault)

## DESCRIPTION:

Gem that allows you to encrypt a Chef Data Bag Item using the public keys of a list of chef nodes. This allows only those chef nodes to decrypt the encrypted values.

## INSTALLATION:

Be sure you are running the latest version Chef. Versions earlier than 0.10.0 don't support plugins:

    gem install chef

This plugin is distributed as a Ruby Gem. To install it, run:

    gem install chef-vault

Depending on your system's configuration, you may need to run this command with root privileges.

## KNIFE COMMANDS:
See KNIFE_EXAMPLES.md for examples of commands

NOTE: chef-vault 1.0 knife commands are not support!  Please use chef-vault 2.0 commands.

### Encrypt

    knife encrypt create [VAULT] [ITEM] [VALUES]
    knife encrypt update [VAULT] [ITEM] [VALUES]
    knife encrypt remove [VAULT] [ITEM] [VALUES]
    knife encrypt delete [VAULT] [ITEM]
    knife encrypt rotate keys [VAULT] [ITEM]

<i>Global Options:</i>
<table>
  <tr>
    <th>Short</th>
    <th>Long</th>
    <th>Description</th>
    <th>Default</th>
    <th>Valid Values</th>
  </tr>
  <tr>
    <td>-S SEARCH</td>
    <td>--search SEARCH</td>
    <td>Chef Server SOLR Search Of Nodes</td>
    <td>nil</td>
    <td></td>
  </tr>
  <tr>
    <td>-A ADMINS</td>
    <td>--admins ADMINS</td>
    <td>Chef clients or users to be vault admins, can be comma list</td>
    <td>nil</td>
    <td></td>
  </tr>
  <tr>
    <td>-M MODE</td>
    <td>--mode MODE</td>
    <td>Chef mode to run in</td>
    <td>solo</td>
    <td>"solo", "client"</td>
  </tr>
  <tr>
    <td>-J FILE</td>
    <td>--json FILE</td>
    <td>json file to be used for values, will be merged with VALUES if VALUES is passed</td>
    <td>nil</td>
    <td></td>
  </tr>
  <tr>
    <td>-F FILE</td>
    <td>--file FILE</td>
    <td>File that chef-vault should encrypt.  It adds ```file-content``` & ```file-name``` keys to the vault item.  This is only valid in create & update</td>
    <td>nil</td>
    <td></td>
</table>

### Decrypt

    knife decrypt [VAULT] [ITEM] [VALUES]

<i>Global Options:</i>
<table>
  <tr>
    <th>Short</th>
    <th>Long</th>
    <th>Description</th>
    <th>Default</th>
    <th>Valid Values</th>
  </tr>
  <tr>
    <td>-M MODE</td>
    <td>--mode MODE</td>
    <td>Chef mode to run in</td>
    <td>solo</td>
    <td>"solo", "client"</td>
  </tr>
</table>

## USAGE IN RECIPES

To use this gem in a recipe to decrypt data you must first install the gem via a chef_gem resource.  Once the gem is installed require the gem and then you can create a new instance of ChefVault.

NOTE: chef-vault 1.0 style decryption is supported, however it has been deprecated and chef-vault 2.0 decryption should be used instead

### Example Code

```ruby
chef_gem "chef-vault"

require 'chef-vault'

item = ChefVault::Item.load("passwords", "root")
item["password"]
```

## USAGE STAND ALONE

`chef-vault` can be used as a stand alone binary to decrypt values stored in Chef.  It requires that Chef is installed on the system and that you have a valid knife.rb.  This is useful if you want to mix `chef-vault` into non-Chef recipe code, for example some other script where you want to protect a password.

It does still require that the data bag has been encrypted for the user's or client's pem and pushed to the Chef server. It mixes Chef into the gem and uses it to go grab the data bag.

Do `chef-vault --help` for all available options

### Example usage (password)

    chef-vault -v passwords -i root -a password -k /etc/chef/knife.rb

## License and Author:

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
