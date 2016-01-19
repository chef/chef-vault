# Description: Chef-Vault VaultDelete class
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
    class VaultDelete < Knife
      include Chef::Knife::VaultBase

      banner "knife vault delete VAULT ITEM (options)"

      def run
        vault = @name_args[0]
        item = @name_args[1]

        set_mode(config[:vault_mode])

        if vault && item
          delete_object(ChefVault::Item, "#{vault}/#{item}", "chef_vault_item") do
            begin
              ChefVault::Item.load(vault, item).destroy
            rescue ChefVault::Exceptions::KeysNotFound,
                   ChefVault::Exceptions::ItemNotFound
              raise ChefVault::Exceptions::ItemNotFound,
                "#{vault}/#{item} not found."
            end
          end
        else
          show_usage
        end
      end
    end
  end
end
