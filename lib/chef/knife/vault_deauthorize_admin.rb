# Description: Chef-Vault VaultDeauthorizeAdmin class
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
    class VaultDeauthorizeAdmin < Knife

      include Chef::Knife::VaultBase

      attr_reader :vault, :item, :admins

      banner "knife vault deauthorize admin VAULT ITEM (options)"

      option :admins,
        :short => '-A ADMINS',
        :long => '--admins ADMINS',
        :description => 'Chef users to be removed as admins'

      def run
        @vault = @name_args[0]
        @item = @name_args[1]
        @admins = config[:admins]
        set_mode(config[:vault_mode])

        if vault && item && admins
          begin
            vault_item = ChefVault::Item.load(vault, item)
            vault_item.admins(unprotected_admins, :delete)
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

      private

      def unprotected_admins
        admin_array = admins.split(',')
        node_name = Chef::Config[:node_name]
        unprotected_admins = (admin_array - [node_name]).join(',')
        if unprotected_admins.empty?
          raise ChefVault::Exceptions::AdminDeauthorization,
            "knife.rb node_name(#{node_name}) "\
          "cannot be deauthorized for #{vault}/#{item}"
        end
      end
    end
  end
end
