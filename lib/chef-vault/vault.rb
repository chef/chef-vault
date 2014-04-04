# Author:: Kevin Moser <kevin.moser@nordstrom.com>
# Copyright:: Copyright 2013, Nordstrom, Inc.
# License:: Apache License, Version 2.0

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class ChefVault::Vault < Chef::DataBag
  def self.load(vault)
    data_bag_items = super

    vault_item_keys = data_bag_items.keys.grep(/_keys$/)
    vault_item_ids = data_bag_items.keys - vault_item_keys
    vault_items = data_bag_items.select do |key, item|
      key !~ /^.*_keys$/
    end

    vault_items.select do |key, item|
      vault_item_keys.include?("#{key}_keys")
    end
  end

  def self.list(inflate=false)
    data_bags = super

    data_bags.select do |key, id|
      ChefVault::Vault.load(key).size > 0
    end
  end
end
