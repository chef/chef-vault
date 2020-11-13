# Chef-Vault

[![Gem Version](https://badge.fury.io/rb/chef-vault.svg)](http://badge.fury.io/rb/chef-vault)

[![Build status](https://badge.buildkite.com/12995d1511cba167621634791600aa4b1156a42ef557452d07.svg)](https://buildkite.com/chef-oss/chef-chef-vault-master-verify)

[![Inline docs](http://inch-ci.org/github/chef/chef-vault.svg?branch=master)](http://inch-ci.org/github/chef/chef-vault)

## DESCRIPTION:

Gem that allows you to encrypt a Chef Data Bag Item using the public keys of
a list of chef nodes. This allows only those chef nodes to decrypt the
encrypted values.

For a more detailed explanation of how chef-vault works, please refer to this blog post [Chef Vault – what is it and what can it do for you?](https://www.chef.io/blog/2016/01/21/chef-vault-what-is-it-and-what-can-it-do-for-you/) by Nell Shamrell-Harrington.

## INSTALLATION:

Be sure you are running the latest version Chef. Versions earlier than
0.10.0 don't support plugins:

    gem install chef

This plugin is distributed as a Ruby Gem. To install it, run:

    gem install chef-vault

Depending on your system's configuration, you may need to run this command
with root privileges.

## DEVELOPMENT:

### Git Hooks

There is a git pre-commit hook to help you keep your chefstyle up to date.
If you wish to use it, simply:

```
mv hooks/pre-commit .git/hooks/
chmod +x .git/hooks/pre-commit
```

### Running Your Changes

To run your changes locally:

```
bundle install
bundle exec knife vault
```

### Testing

#### Rspec Tests

There are some unit tests that can be run with:

```
bundle exec rspec spec/
```

#### Cucumber Testing

There are cucumber tests. Run the whole suite with:

```
bundle exec rake features
```

If you get any failures, you can run the specific feature that failed with:

```
bundle exec cucumber features/<failed>.feature
```

If you want to test things out directly, after a failure you can go into the test
directory and try out the commands that failed:

```
cd tmp/aruba
bundle exec knife <your command that failed from test with -c config.rb>
```

Optionally add `-VV` to the above to get a full stacktrace.

### Rubocop Errors

If you are seeing rubocop errors in travis for your pull request, run:

`bundle exec chefstyle -a`

This will fix up your rubocop errors automatically, and warn you about any it can't.

## KNIFE COMMANDS:

See KNIFE_EXAMPLES.md for examples of commands

### config.rb (aka knife.rb)

To set 'client' as the default mode, add the following line to the config.rb file.

    knife[:vault_mode] = 'client'

To set the default list of admins for creating and updating vaults, add the
following line to the config.rb file.

    knife[:vault_admins] = [ 'example-alice', 'example-bob', 'example-carol' ]

(These values can be overridden on the command line by using -A)

NOTE: chef-vault 1.0 knife commands are not supported! Please use chef-vault
2.0 commands.

### Vault

    knife vault create VAULT ITEM VALUES
    knife vault edit VAULT ITEM
    knife vault refresh VAULT ITEM
    knife vault update VAULT ITEM VALUES [--clean]
    knife vault remove VAULT ITEM VALUES
    knife vault delete VAULT ITEM
    knife vault rotate keys VAULT ITEM
    knife vault rotate all keys
    knife vault show VAULT [ITEM] [VALUES]
    knife vault download VAULT ITEM PATH
    knife vault isvault VAULT ITEM
    knife vault itemtype VAULT ITEM

    Note: Creating a VAULT ITEM with an ITEM name ending in "_keys" causes the VAULT to treat it as an ordinary `data_bag` instead of as a vault.

#### Global Options

Short | Long | Description | Default | Valid Values | Sub-Commands
------|------|-------------|---------|--------------|-------------
-M MODE | --mode MODE | Chef mode to run in. Can be set in config.rb | solo | solo, client | all
-S SEARCH | --search SEARCH | Chef Server SOLR Search Of Nodes | | | create, remove , update
-C CLIENTS | --clients CLIENTS | Chef clients to be added as clients, can be comma list | | | create, remove , update
-A ADMINS | --admins ADMINS | Chef clients or users to be vault admins, can be comma list | | | create, remove, update
-J FILE | --json FILE | JSON file to be used for values, will be merged with VALUES if VALUES is passed | | | create, update
| --file FILE | File that chef-vault should encrypt.  It adds "file-content" & "file-name" keys to the vault item | | | create, update
-p DATA | --print DATA | Print extra vault data | | search, clients, admins, all | show
-F FORMAT | --format FORMAT | Format for decrypted output | summary | summary, json, yaml, pp | show
| --clean-unknown-clients | Remove unknown clients during key rotation | | | refresh, remove, rotate
| --clean | Clean clients list before performing search | | | refresh, update
| --keys-mode | | method to use to manage keys | default | default, sparse | create

## USAGE IN RECIPES

To use this gem in a recipe to decrypt data you must first install the gem
via a chef_gem resource. Once the gem is installed require the gem and then
you can create a new instance of ChefVault.

NOTE: chef-vault 1.0 style decryption is supported, however it has been
deprecated and chef-vault 2.0 decryption should be used instead

### Example Code

    chef_gem 'chef-vault' do
      compile_time true if respond_to?(:compile_time)
    end

    require 'chef-vault'

    item = ChefVault::Item.load("passwords", "root")
    item["password"]

Note that in this case, the gem needs to be installed at compile time
because the require statement is at the top-level of the recipe.  If
you move the require of chef-vault and the call to `::load` to
library or provider code, you can install the gem in the converge phase
instead.

### Specifying an alternate node name or client key path

Normally, the value of `Chef::Config[:node_name]` is used to find the
per-node encrypted secret in the keys data bag item, and the value of
`Chef::Config[:client_key]` is used to locate the private key to decrypt
this secret.

These can be overridden by passing a hash with the keys `:node_name` or
`:client_key_path` to `ChefVault::Item.load`:

    item = ChefVault::Item.load(
      'passwords', 'root',
      node_name: 'service_foo',
      client_key_path: '/secure/place/service_foo.pem'
    )
    item['password']

The above example assumes that you have transferred
`/secure/place/service_foo.pem` to your system via a secure channel.

This usage allows you to decrypt a vault using a key shared among several
nodes, which can be helpful when working in cloud environments or other
configurations where nodes are created dynamically.

### chef_vault_item helper

The [chef-vault cookbook](https://supermarket.chef.io/cookbooks/chef-vault)
contains a recipe to install the chef-vault gem and a helper method
`chef_vault_helper` which makes it easier to test cookbooks that use
chef-vault using Test Kitchen.

## DETERMINING IF AN ITEM IS A VAULT

ChefVault provides a helper method to determine if a data bag item is a vault,
which can be helpful if you produce a recipe for community consumption and want
to support both normal data bags and vaults:

    if ChefVault::Item.vault?('passwords', 'root')
      item = ChefVault::Item.load('passwords', 'root')
    else
      item = Chef::DataBagItem.load('passwords', 'root')
    end

This functionality is also available from the command line as `knife vault isvault VAULT ITEM`.

## DETERMINING THE TYPE OF A DATA BAG ITEM

ChefVault provides a helper method to determine the type of a data bag item.
It returns one of the symbols :normal, :encrypted or :vault

    case ChefVault::Item.data_bag_item_type('passwords', 'root')
    when :normal
      ...
    when :encrypted
      ...
    when :vault
      ...
    end

This functionality is also available from the command line as `knife vault itemtype VAULT ITEM`.

## USAGE STAND ALONE

`chef-vault` can be used as a stand alone binary to decrypt values stored in
Chef. It requires that Chef is installed on the system and that you have a
valid config.rb. This is useful if you want to mix `chef-vault` into non-Chef
recipe code, for example some other script where you want to protect a
password.

It does still require that the data bag has been encrypted for the user's or
client's pem and pushed to the Chef server. It mixes Chef into the gem and
uses it to go grab the data bag.

Use `chef-vault --help` to see all all available options

### Example usage (password)

    chef-vault -v passwords -i root -a password -k /etc/chef/config.rb

## SCALING
As more nodes use a shared key, some operations like refresh or update can execute more efficiently using sparse mode (see [issue #237](https://github.com/chef/chef-vault/issues/237)).

To create a vault item using sparse mode, pass the value `sparse` to the `--keys-mode` option to `knife vault create`.

## TESTING

To use Chef Vault in Test Kitchen, ensure that the `chef-vault` recipe
is in your `run_list`, and then add the following to your
suite in `.kitchen.yml`:

```yaml
data_bags_path: 'path/to/data_bags'
attributes:
  chef_vault:
    databags_fallback: true
```

You can then use the `chef_vault_item` helper in the aforementioned chef-vault cookbook.

To stub vault items in ChefSpec, use the
[chef-vault-testfixtures](https://rubygems.org/gems/chef-vault-testfixtures)
gem.

## Contributing

For information on contributing to this project see <https://github.com/chef/chef/blob/master/CONTRIBUTING.md>

## Authors

Author:: Kevin Moser - @moserke<br>
Author:: Eli Klein - @eliklein<br>
Author:: Joey Geiger - @jgeiger<br>
Author:: Joshua Timberman - @jtimberman<br>
Author:: James FitzGibbon - @jf647<br>
Author:: Thom May - @thommay<br>

## Contributors

Contributor:: Matt Brimstone - @brimstone<br>
Contributor:: Thomas Gschwind - @thg65<br>
Contributor:: Reto Hermann<br>

## License

Copyright:: Copyright (c) 2013-15 Nordstrom, Inc.<br>
Copyright:: Copyright (c) 2016 Chef Software, Inc.<br>
License:: Apache License, Version 2.0

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
