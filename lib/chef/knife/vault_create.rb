# Description: Chef-Vault VaultCreate class
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

require 'chef/knife'
require 'chef-vault'

class VaultCreate < Chef::Knife
  deps do
    require 'chef/search/query'
    require File.expand_path('../mixin/compat', __FILE__)
    require File.expand_path('../mixin/helper', __FILE__)
    include ChefVault::Mixin::KnifeCompat
    include ChefVault::Mixin::Helper
  end

  banner "knife vault create VAULT ITEM VALUES (options)"

  option :mode,
    :short => '-M MODE',
    :long => '--mode MODE',
    :description => 'Chef mode to run in default - solo'

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
    admins = config[:admins]
    json_file = config[:json]
    file = config[:file]

    set_mode(config[:mode])

    if vault && item  && (search || admins)
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
            vault_item["file-content"] = File.open(file){ |file| file.read() }
          end
        else
          vault_json = edit_data(Hash.new)
          vault_json.each do |key, value|
            vault_item[key] = value
          end
        end

        vault_item.clients(search) if search
        vault_item.admins(admins) if admins

        vault_item.save
      end
    else
      show_usage
    end
  end

  def show_usage
    super
    exit 1
  end
end

