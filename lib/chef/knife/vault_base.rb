# Description: Chef-Vault VaultBase module
# Copyright 2013-15, Nordstrom, Inc.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "chef/knife"
require "chef-vault"

class Chef
  class Knife
    module VaultBase
      def self.included(includer)
        includer.class_eval do
          deps do
            require "chef/search/query"
            require File.expand_path("../mixin/helper", __FILE__)
            include ChefVault::Mixin::Helper
          end

          option :vault_mode,
            short: "-M MODE",
            long: "--mode MODE",
            description: "Chef mode to run in default - solo",
            proc: proc { |i| Chef::Config[:knife][:vault_mode] = i }
        end
      end

      def show_usage
        super
        exit 1
      end

      def configure_chef
        super
        ChefVault::Log.logger = Chef::Log.logger
      end

      private

      def bag_is_vault?(bagname)
        bag = Chef::DataBag.load(bagname)
        # a data bag is a vault if and only if:
        # - it has at least one item with item_keys
        # - every item has a matching item_keys
        # - item_keys has zero or more keys in sparse mode
        # vaults have a number of keys >= 2
        return false unless bag.keys.size >= 2
        # partition into those that end in _keys
        keylike, notkeylike = split_vault_keys(bag)
        # there must be an equal number of keyline and not-keylike items
        return false unless keylike.size == notkeylike.size
        # strip the _keys suffix and check if the sets match
        keylike.map! { |k| k.gsub(/_keys$/, "") }
        return false unless keylike.sort == notkeylike.sort
        # it's (probably) a vault
        true
      end

      def split_vault_keys(bag)
        # get all item keys
        keys = bag.keys.select { |k| k =~ /_keys$/ }
        # get all sparse keys
        r = Regexp.union(keys.map { |k| Regexp.new("^#{k.chomp('_keys')}_key_.*") })
        sparse = bag.keys.select { |k| k =~ r }
        # the rest
        items = bag.keys - keys - sparse
        # return item keys and items
        [keys, items]
      end
    end
  end
end
