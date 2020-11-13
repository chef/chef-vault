# Description: Chef-Vault VaultAdmins module
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

require "chef/knife"
require_relative "../../chef-vault"

class Chef
  class Knife
    module VaultAdmins
      private

      def admins
        config_admins = config[:admins]
        vault_admins = Chef::Config[:knife][:vault_admins]
        admin_array = [Chef::Config[:node_name]]

        unless vault_admins.is_a?(Array)
          ui.warn("Vault admin must be an array")
        end

        if config_admins
          admin_array += [config_admins]
        elsif vault_admins
          admin_array += vault_admins
        end

        admin_array.join(",")
      end
    end
  end
end
