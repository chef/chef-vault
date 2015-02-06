# Description: Chef-Vault VaultShow class
# Copyright 2013, Nordstrom, Inc.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'chef/knife/vault_base'

class Chef
  class Knife
    class VaultList < Knife

      include Chef::Knife::VaultBase

      banner "knife vault list (options)"

      def run
        vaultbags = []
        # iterate over all the data bags
        bags = Chef::DataBag.list
        bags.each_key do |bagname|
          vaultbags.push(bagname) if bag_is_vault?(bagname)
        end
        output vaultbags.join("\n")
      end

      private

      def bag_is_vault?(bagname)
        bag = Chef::DataBag.load(bagname)
        # vaults have at even number of keys >= 2
        return false unless bag.keys.size >= 2 && 0 == bag.keys.size % 2
        # partition into those that end in _keys
        keylike, notkeylike = bag.keys.partition { |k| k =~ /_keys$/ }
        # there must be an equal number of keyline and not-keylike items
        return false unless keylike.size == notkeylike.size
        # strip the _keys suffix and check if the sets match
        keylike.map! { |k| k.gsub(/_keys$/, '') }
        return false unless keylike.sort == notkeylike.sort
        # it's (probably) a vault
        true
      end
    end
  end
end
