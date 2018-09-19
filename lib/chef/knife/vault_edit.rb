# Description: Chef-Vault VaultEdit class
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
    class VaultEdit < Knife
      include Chef::Knife::VaultBase

      banner "knife vault edit VAULT ITEM (options)"

      option :mode,
        short: "-M MODE",
        long: "--mode MODE",
        description: "Chef mode to run in default - solo"

      def run
        vault = @name_args[0]
        item = @name_args[1]

        set_mode(config[:vault_mode])

        if vault && item
          begin
            vault_item = ChefVault::Item.load(vault, item)

            filtered_vault_data = vault_item.raw_data.select { |x| x != "id" }

            updated_vault_json = edit_hash(filtered_vault_data)

            # Clean out contents of existing local vault_item
            vault_item.raw_data.each do |key, _|
              vault_item.remove(key) unless key == "id"
            end

            # write new vault_item key/value pairs
            updated_vault_json.each do |key, value|
              vault_item[key] = value
            end

            vault_item.save
          rescue ChefVault::Exceptions::KeysNotFound,
                 ChefVault::Exceptions::ItemNotFound
            raise ChefVault::Exceptions::ItemNotFound,
              "#{vault}/#{item} does not exist, "\
              "use 'knife vault create' to create."
          end
        else
          show_usage
        end
      end
    end
  end
end
