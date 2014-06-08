# Description: Chef-Vault VaultVersion class

require 'chef/knife/vault_base'

class Chef
  class Knife
    class VaultVersion < Knife

      include Chef::Knife::VaultBase
      include Chef::Knife::VaultAdmins

      banner "knife vault version"

      def run
        puts "Chef-Vault Version #{ChefVault::VERSION}"
      end
    end
  end
end
