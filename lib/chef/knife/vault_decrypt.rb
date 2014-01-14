# Description: Chef-Vault VaultDecrypt class
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
    class VaultDecrypt < Knife

      include Chef::Knife::VaultBase

      banner "knife vault decrypt VAULT ITEM [VALUES] (options)"

      def run
        puts "DEPRECATION WARNING: knife vault decrypt is deprecated. Please use knife vault show instead."
        vault = @name_args[0]
        item = @name_args[1]
        values = @name_args[2]

        if vault && item
          set_mode(config[:vault_mode])

          print_values(vault, item, values)
        else
          show_usage
        end
      end

      def print_values(vault, item, values)
        vault_item = ChefVault::Item.load(vault, item).raw_data

        if values
          included_values = %W( id )

          values.split(",").each do |value|
            value.strip! # remove white space
            included_values << value
          end

          output(Hash[vault_item.find_all{|k,v| included_values.include?(k)}])
        else
          output(vault_item)
        end
      end
    end
  end
end
