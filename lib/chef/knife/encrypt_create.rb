# Description: Chef-Vault EncryptCreate class
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

class EncryptCreate < Chef::Knife
  deps do
    require 'chef/search/query'
    require File.expand_path('../compat', __FILE__)
    include ChefVault::Compat
  end

  banner "knife encrypt create [VAULT] [ITEM] [VALUES] --search SEARCH --admins ADMINS"

  def run
  end
end
  