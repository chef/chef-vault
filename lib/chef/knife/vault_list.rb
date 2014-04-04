# Description: Chef-Vault VaultShow class
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

class Chef
  class Knife
    class VaultList < Knife

      include Chef::Knife::VaultBase

      banner "knife vault list (options)"

      option :mode,
        :short => '-M MODE',
        :long => '--mode MODE',
        :description => 'Chef mode to run in default - solo'

      def run
        set_mode(config[:vault_mode])

        output(format_list_for_display(ChefVault::Vault.list))
      end
    end
  end
end
