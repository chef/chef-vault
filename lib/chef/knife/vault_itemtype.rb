# Description: Chef-Vault VaultItemtype class
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

require "chef/knife/vault_base"

class Chef
  class Knife
    class VaultItemtype < Knife
      include Chef::Knife::VaultBase

      banner "knife vault itemtype VAULT ITEM (options)"

      option :mode,
        short: "-M MODE",
        long: "--mode MODE",
        description: "Chef mode to run in default - solo"

      def run
        vault = @name_args[0]
        item = @name_args[1]

        if vault && item
          set_mode(config[:vault_mode])
          output ChefVault::Item.data_bag_item_type(vault, item)
        else
          show_usage
        end
      end
    end
  end
end
