# Description: Chef-Vault EncryptRemove class
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
require 'chef/knife/vault_remove'

class Chef
  class Knife
    class EncryptRemove < VaultRemove

      include Knife::VaultBase

      banner "knife encrypt remove VAULT ITEM VALUES (options)"

      option :search,
        :short => '-S SEARCH',
        :long => '--search SEARCH',
        :description => 'Chef SOLR search for clients'

      option :admins,
        :short => '-A ADMINS',
        :long => '--admins ADMINS',
        :description => 'Chef users to be added as admins'

      def run
        puts "DEPRECATION WARNING: knife encrypt is deprecated. Please use knife vault instead."
        super
      end
    end
  end
end
