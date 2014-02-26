# Description: Chef-Vault VaultCreate class
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
require 'chef/knife/vault_admins'

class Chef
  class Knife
    class VaultCreate < Knife

      include Chef::Knife::VaultBase
      include Chef::Knife::VaultAdmins

      banner "knife vault create VAULT ITEM VALUES (options)"

      option :search,
        :short => '-S SEARCH',
        :long => '--search SEARCH',
        :description => 'Chef SOLR search for clients'

      option :admins,
        :short => '-A ADMINS',
        :long => '--admins ADMINS',
        :description => 'Chef users to be added as admins'

      option :json,
        :short => '-J FILE',
        :long => '--json FILE',
        :description => 'File containing JSON data to encrypt'

      option :file,
        :long => '--file FILE',
        :description => 'File to be added to vault item as file-content'

      def run
        vault = @name_args[0]
        item = @name_args[1]
        values = @name_args[2]
        search = config[:search]
        json_file = config[:json]
        file = config[:file]

        set_mode(config[:vault_mode])

        if vault && item && (search || admins)
          begin
            vault_item = ChefVault::Item.load(vault, item)
            raise ChefVault::Exceptions::ItemAlreadyExists,
              "#{vault_item.data_bag}/#{vault_item.id} already exists, "\
              "use 'knife vault remove' 'knife vault update' "\
              "or 'knife vault edit' to make changes."
          rescue ChefVault::Exceptions::KeysNotFound,
            ChefVault::Exceptions::ItemNotFound
            vault_item = ChefVault::Item.new(vault, item)

            if values || json_file || file
              merge_values(values, json_file).each do |key, value|
                vault_item[key] = value
              end

              if file
                vault_item["file-name"] = File.basename(file)
                vault_item["file-content"] = File.open(file) { |f| f.read() }
              end
            else
              vault_json = edit_data(Hash.new)
              vault_json.each do |key, value|
                vault_item[key] = value
              end
            end

            vault_item.search(search) if search
            vault_item.clients(search) if search
            vault_item.admins(admins) if admins

            vault_item.save
          end
        else
          show_usage
        end
      end
    end
  end
end
