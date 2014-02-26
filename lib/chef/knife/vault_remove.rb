# Description: Chef-Vault VaultRemove class
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
    class VaultRemove < Knife

      include Chef::Knife::VaultBase

      banner "knife vault remove VAULT ITEM VALUES"

      def run
        vault = @name_args[0]
        item = @name_args[1]
        values = @name_args[2]
        json_file = config[:json]

        set_mode(config[:vault_mode])

        if vault && item && ((values || json_file))
          begin
            vault_item = ChefVault::Item.load(vault, item)
            remove_items = []

            if values || json_file
              begin
                json = JSON.parse(values)
                json.each do |key, value|
                  remove_items << key
                end
              rescue JSON::ParserError
                remove_items = values.split(",")
              rescue Exception => e
                raise e
              end

              remove_items.each do |key|
                vault_item.remove(key.strip)
              end

              vault_item.rotate_keys!
            end
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
