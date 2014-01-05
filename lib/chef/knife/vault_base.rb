# Description: Chef-Vault VaultBase module
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

class Chef
  class Knife
    module VaultBase
      def self.included(includer)
        includer.class_eval do
          deps do
            require 'chef/search/query'
            require File.expand_path('../mixin/compat', __FILE__)
            require File.expand_path('../mixin/helper', __FILE__)
            include ChefVault::Mixin::KnifeCompat
            include ChefVault::Mixin::Helper
          end

          option :vault_mode,
            :short => '-M MODE',
            :long => '--mode MODE',
            :description => 'Chef mode to run in default - solo',
            :proc => Proc.new { |i| Chef::Config[:knife][:vault_mode] = i }
        end
      end

      def show_usage
        super
        exit 1
      end
    end
  end
end
