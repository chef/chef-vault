# Description: Chef-Vault Decrypt class
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
    require File.expand_path('../mixin/compat', __FILE__)
    require File.expand_path('../mixin/helper', __FILE__)
    include ChefVault::Mixin::KnifeCompat
    include ChefVault::Mixin::Helper
  end

  banner "knife decrypt [VAULT] [ITEM] [VALUES] --mode MODE --secret-file FILE"

  option :mode,
    :short => '-M MODE',
    :long => '--mode MODE',
    :description => 'Chef mode to run in default - solo'

  option :file,
    :short => '-S FILE',
    :long => '--secret-file FILE',
    :description => 'Read vault secret from file FILE'

  def run
    vault = @name_args[0]
    item = @name_args[1]
    values = @name_args[2]

    if config[:file] 
      secret=open(config[:file]).read()
    end

    if vault && item && values
      set_mode(config[:mode])

      print_values(vault, item, values, secret)
    else
      show_usage
    end
  end

  def show_usage
    super
    exit 1
  end

  def print_values(vault, item, values, secret=nil)
    vault_item = ChefVault::Item.load(vault, item, secret)

    puts "#{vault}/#{item}"

    values.split(",").each do |value|
      value.strip! # remove white space
      puts("\t#{value}: #{vault_item[value]}")
    end
  end    
end
