# Description: Chef-Vault VaultMock class
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
    class VaultMock < Knife

      include Chef::Knife::VaultBase

      SECRET = "secret"

      banner "knife vault mock VAULT ITEM VALUES (options)"

      option :json,
        :short => '-J FILE',
        :long => '--json FILE',
        :description => 'File containing JSON data to encrypt'

      option :file,
        :long => '--file FILE',
        :description => 'File to be added to vault item as file-content'

      option :vm,
        :long => '--vm NODE_NAME',
        :description => 'Name of the virtual machine node',
        :proc => Proc.new { |i| Chef::Config[:knife][:vm_server_name] = i }

      attr_reader :vault_name, :item_name, :values, :json_file, :file, :vm_server_name

      def run
        parse_arguments

        return show_usage unless valid_arguments?

        vault_item = create_vault_item
        save_keys(vault_item)
        encrypted_item = Chef::EncryptedDataBagItem.encrypt_data_bag_item(vault_item, SECRET)
        write_json_file(encrypted_item)
      end

      private

      def parse_arguments
        @vault_name = @name_args[0]
        @item_name = @name_args[1]
        @values = @name_args[2]
        @json_file = config[:json]
        @file = config[:file]
        @vm_server_name = config[:vm]
      end

      def valid_arguments?
        vault_name && item_name && vm_server_name
      end

      def save_keys(vault_item)
        write_json_file(vault_item.keys.raw_data, "_keys")
      end

      def write_json_file(json, suffix="")
        FileUtils.mkdir(vault_name) unless File.exists?(vault_name)

        filename = "#{vault_name}/#{item_name}#{suffix}.json"
        File.open(filename, 'w') do |file|
          file.write(JSON.pretty_generate(json))
        end
      end

      def create_vault_item
        vault_item = new_vault_item(vault_name, item_name, values, json_file, file)

        vault_item.keys["clients"] << vm_server_name
        vault_item.keys[vm_server_name] = SECRET
        vault_item.keys["secret"] = SECRET

        vault_item
      end
    end
  end
end
