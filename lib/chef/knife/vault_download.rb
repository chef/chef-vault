# Description: Chef-Vault VaultDownload class
# Copyright 2014-15, Nordstrom, Inc.

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
    class VaultDownload < Knife
      include Chef::Knife::VaultBase

      banner "knife vault download VAULT ITEM PATH (options)"

      def run
        vault = @name_args[0]
        item = @name_args[1]
        path = @name_args[2]

        set_mode(config[:vault_mode])

        if vault && item && path
          vault_item = ChefVault::Item.load(vault, item)
          File.open(path, "w") do |file|
            file.write(vault_item["file-content"])
          end
          ui.info("Saved #{vault_item['file-name']} as #{path}")
        else
          show_usage
        end
      end
    end
  end
end
