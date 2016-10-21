#
# Author:: Kevin Moser (<kevin.moser@nordstrom.com>)
#
# Copyright:: 2013, Nordstrom, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require "chef/search/query"
require "chef/version"
require "chef/config"
require "chef/api_client"
require "chef/data_bag_item"
require "chef/encrypted_data_bag_item"
require "chef/user"
require "chef-vault/version"
require "chef-vault/exceptions"
require "chef-vault/item"
require "chef-vault/item_keys"
require "chef-vault/user"
require "chef-vault/certificate"
require "chef-vault/chef_api"
require "chef-vault/actor"

require "mixlib/log"

class ChefVault
  attr_accessor :vault

  def initialize(vault, chef_config_file = nil)
    @vault = vault
    ChefVault.load_config(chef_config_file) if chef_config_file
  end

  def version
    VERSION
  end

  def user(username)
    ChefVault::User.new(vault, username)
  end

  def certificate(name)
    ChefVault::Certificate.new(vault, name)
  end

  def self.load_config(chef_config_file)
    Chef::Config.from_file(chef_config_file)
  end

  class Log
    extend Mixlib::Log
  end

  Log.level = :error
end
