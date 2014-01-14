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

require 'chef/knife/vault_base'
require 'chef/knife/vault_decrypt'

class Chef
  class Knife
    class Decrypt < VaultDecrypt

      include Knife::VaultBase

      banner "knife decrypt VAULT ITEM [VALUES] (options)"

      def run
        puts "DEPRECATION WARNING: knife decrypt is deprecated. Please use knife vault decrypt instead."
        super
      end
    end
  end
end
