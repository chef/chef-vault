# Description: Chef-Vault VaultDeauthorizeClient class
# Copyright 2014, Nordstrom, Inc.

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
    class VaultDeauthorizeClient < Knife

      include Chef::Knife::VaultBase

      banner "knife vault deauthorize client VAULT ITEM (options)"

      option :search,
        :short => '-S SEARCH',
        :long => '--search SEARCH',
        :description => 'Chef SOLR search for clients'

      def run
        vault = @name_args[0]
        item = @name_args[1]
        search = config[:search]
        set_mode(config[:vault_mode])

        if vault && item && search
          begin
            vault_item = ChefVault::Item.load(vault, item)
            vault_item.clients(search, :delete) if search
            vault_item.rotate_keys!
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
