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

require 'chef'
require 'chef-vault/user'
require 'chef-vault/certificate'
require 'chef-vault/version'
require 'chef-vault/chef/offline'

class ChefVault

  attr_accessor :data_bag
  attr_accessor :chef_config_file

  def initialize(data_bag, chef_config_file=nil)
    @data_bag = data_bag
    @chef_config_file = chef_config_file
  end

  def version
    VERSION
  end

  def user(username)
    ChefVault::User.new(@data_bag, username, @chef_config_file)
  end

  def certificate(name)
    ChefVault::Certificate.new(@data_bag, name, @chef_config_file)
  end
end