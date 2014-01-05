# Description: Chef-Vault VaultRotateAllKeys class
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
    class VaultRotateAllKeys < Knife

      include Chef::Knife::VaultBase

      banner "knife vault rotate all keys"

      def run
        set_mode(config[:vault_mode])
        rotate_all_keys
      end

      private

      def rotate_all_keys
        vaults = Chef::DataBag.list.keys
        vaults.each { |vault| rotate_vault_keys(vault) }
      end

      def rotate_vault_keys(vault)
        vault_items(vault).each do |item|
          rotate_vault_item_keys(vault, item)
        end
      end

      def vault_items(vault)
        Chef::DataBag.load(vault).keys.inject([]) do |array, key|
          array << key.sub('_keys', '') if key.match(/.+_keys$/)
          array
        end
      end

      def rotate_vault_item_keys(vault, item)
        puts "Rotating keys for: #{vault} #{item}"
        ChefVault::Item.load(vault, item).rotate_keys!
      end
    end
  end
end
