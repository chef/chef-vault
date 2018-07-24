# Description: Chef-Vault VaultRotateKeys class
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
    class VaultRotateKeys < Knife
      include Chef::Knife::VaultBase

      banner "knife vault rotate keys VAULT ITEM (options)"

      option :clean_unknown_clients,
        long: "--clean-unknown-clients",
        description: "Remove unknown clients during key rotation"

      def run
        vault = @name_args[0]
        item = @name_args[1]
        clean_unknown_clients = config[:clean_unknown_clients]

        if vault && item
          set_mode(config[:vault_mode])

          begin
            item = ChefVault::Item.load(vault, item)
            item.rotate_keys!(clean_unknown_clients)
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
