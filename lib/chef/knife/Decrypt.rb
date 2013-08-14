# Description: Chef-Vault DecryptPassword class
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

class Decrypt < Chef::Knife
  deps do
    require 'chef/search/query'
    require 'json'
    require File.expand_path('../compat', __FILE__)
    include ChefVault::Compat
  end

  banner "knife decrypt [VAULT] [ITEM] [VALUE]"

  def run
    vault = @name_args[0]
    item = @name_args[1]
    value = @name_args[2]

    if vault && item && vaule
      vault_item = ChefVault::Item.load(vault, item)

      puts("#{item}: #{vault_item[value]}")
    end
  end
end
