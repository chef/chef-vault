# Description: Chef-Vault VaultShow class
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
    class VaultShow < Knife
      include Chef::Knife::VaultBase

      banner "knife vault show VAULT [ITEM] [VALUES] (options)"

      option :mode,
        short: "-M MODE",
        long: "--mode MODE",
        description: "Chef mode to run in default - solo"

      option :print,
        short: "-p TYPE",
        long: "--print TYPE",
        description: "Print extra vault data, can be search, admins, clients or all"

      def run
        vault = @name_args[0]
        item = @name_args[1]
        values = @name_args[2]

        if vault && item
          set_mode(config[:vault_mode])
          print_values(vault, item, values)
        elsif vault
          set_mode(config[:vault_mode])
          print_keys(vault)
        else
          show_usage
        end
      end

      def print_values(vault, item, values)
        vault_item = ChefVault::Item.load(vault, item)

        extra_data = {}

        if config[:print]
          case config[:print]
          when "search"
            extra_data["search_query"] = vault_item.search
          when "admins"
            extra_data["admins"] = vault_item.get_admins
          when "clients"
            extra_data["clients"] = vault_item.get_clients
          when "all"
            extra_data["search_query"] = vault_item.search
            extra_data["admins"] = vault_item.get_admins
            extra_data["clients"] = vault_item.get_clients
          end
        end

        if values
          included_values = %w{id}

          values.split(",").each do |value|
            value.strip! # remove white space
            included_values << value
          end

          filtered_data = Hash[vault_item.raw_data.find_all { |k, _| included_values.include?(k) }]

          output_data = filtered_data.merge(extra_data)
        else
          all_data = vault_item.raw_data

          output_data = all_data.merge(extra_data)
        end
        output(output_data)
      end

      def print_keys(vault)
        if bag_is_vault?(vault)
          bag = Chef::DataBag.load(vault)
          split_vault_keys(bag)[1].each do |item|
            output item
          end
        else
          output "data bag #{vault} is not a chef-vault"
        end
      end
    end
  end
end
