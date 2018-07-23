# Description: Chef-Vault VaultRemove class
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
require "chef/knife/vault_clients"

class Chef
  class Knife
    class VaultRemove < Knife
      include Chef::Knife::VaultBase
      include Chef::Knife::VaultClients

      banner "knife vault remove VAULT ITEM VALUES (options)"

      option :search,
        short: "-S SEARCH",
        long: "--search SEARCH",
        description: "Chef SOLR search for clients"

      option :clients,
        short: "-C CLIENTS",
        long: "--clients CLIENTS",
        description: "Chef clients to be added as clients"

      option :admins,
        short: "-A ADMINS",
        long: "--admins ADMINS",
        description: "Chef users to be added as admins"

      option :clean_unknown_clients,
        long: "--clean-unknown-clients",
        description: "Remove unknown clients during key rotation"

      def run
        vault = @name_args[0]
        item = @name_args[1]
        values = @name_args[2]
        search = config[:search]
        admins = config[:admins]
        clean_unknown_clients = config[:clean_unknown_clients]
        json_file = config[:json]

        set_mode(config[:vault_mode])

        if vault && item && ((values || json_file) || (search || clients || admins))
          begin
            vault_item = ChefVault::Item.load(vault, item)
            remove_items = []

            if values || json_file
              begin
                json = JSON.parse(values)
                json.each do |key, _|
                  remove_items << key
                end
              rescue JSON::ParserError
                remove_items = values.split(",")
              end

              remove_items.each do |key|
                key = key.dup
                vault_item.remove(key.strip)
              end
            end

            vault_item.clients(search, :delete) if search
            vault_item.clients(clients, :delete) if clients
            vault_item.admins(admins, :delete) if admins

            vault_item.rotate_keys!(clean_unknown_clients)
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
