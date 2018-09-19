# Description: Chef-Vault VaultRotateAllKeys class
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

require "chef/knife/vault_base"

class Chef
  class Knife
    class VaultRotateAllKeys < Knife
      include Chef::Knife::VaultBase

      banner "knife vault rotate all keys"

      option :clean_unknown_clients,
        long: "--clean-unknown-clients",
        description: "Remove unknown clients during key rotation"

      def run
        clean_unknown_clients = config[:clean_unknown_clients]
        set_mode(config[:vault_mode])
        rotate_all_keys(clean_unknown_clients)
      end

      private

      def rotate_all_keys(clean_unknown_clients = false)
        vaults = Chef::DataBag.list.keys
        vaults.each { |vault| rotate_vault_keys(vault, clean_unknown_clients) }
      end

      def rotate_vault_keys(vault, clean_unknown_clients)
        vault_items(vault).each do |item|
          rotate_vault_item_keys(vault, item, clean_unknown_clients)
        end
      end

      def vault_items(vault)
        Chef::DataBag.load(vault).keys.each_with_object([]) do |key, array|
          array << key.sub("_keys", "") if key =~ /.+_keys$/
        end
      end

      def rotate_vault_item_keys(vault, item, clean_unknown_clients)
        ui.info "Rotating keys for: #{vault} #{item}"
        ChefVault::Item.load(vault, item).rotate_keys!(clean_unknown_clients)
      end
    end
  end
end
