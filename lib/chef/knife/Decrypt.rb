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
    require 'json'
    require File.expand_path('../compat', __FILE__)
    include ChefVault::Compat
  end

  banner "knife decrypt [VAULT] [ITEM] [VALUES]"
  
  option :mode,
    :short => '-M MODE',
    :long => '--mode MODE',
    :description => 'Chef mode to run in default - solo'

  option :name,
    :short => '-N NAME',
    :long => '--name NAME',
    :description => 'Certificate name to decrypt contents for'

  option :username,
    :short => '-U USERNAME',
    :long => '--username USERNAME',
    :description => 'Username name to decrypt password for'

  def run
    vault = @name_args[0]
    item = @name_args[1]
    values = @name_args[2]

    if vault
      if config[:mode] && config[:mode] == "client"
        Chef::Config[:solo] = false
      else
        Chef::Config[:solo] = true
      end

      case vault.downcase 
      # maintain backwards compat for knife decrypt cert -N NAME
      when "cert"
        puts "WARNING: knife decrypt cert has been deprecated.  "\
              "Please use 2.x style knife commands."

        if config[:name]
          vault = "certs"
          item = config[:name]
          values = "contents"
        else
          show_usage
        end
      # maintain backwards compat for knife decrypt password -U USERNAME
      when "password"
        puts "WARNING: knife decrypt password has been deprecated.  "\
              "Please use 2.x style knife commands."

        if config[:username]
          vault = "passwords"
          item = config[:username]
          values = "password"
        else
          show_usage
        end
      else # New usage used, check for all values
        unless vault && item && values
          show_usage
        end
      end
    else
      show_usage
    end

    print_values(vault, item, values)
  end

  def show_usage
    super
    exit 1
  end

  def print_values(vault, item, values)
    vault_item = ChefVault::Item.load(vault, item)

    puts "#{vault}/#{item}"

    values.split(",").each do |value|
      value.strip! # remove white space
      puts("\t#{value}: #{vault_item[value]}")
    end
  end    
end
