require 'chef/knife/vault_base'
require 'chef/knife/vault_admins'

class Chef
  class Knife
    class VaultRefresh < Knife

      include Chef::Knife::VaultBase
      include Chef::Knife::VaultAdmins

      banner "knife vault refresh VAULT ITEM (options)"

      def run
        vault = @name_args[0]
        item = @name_args[1]

        set_mode(config[:vault_mode])

        if vault && item
          begin
            vault_item = ChefVault::VaultItem.load(vault, item)
            vault_item.refresh!
          rescue ChefVault::Exceptions::KeysNotFound,
            ChefVault::Exceptions::ItemNotFound

            raise ChefVault::Exceptions::ItemNotFound,
              "#{vault}/#{item} does not exist, "\
              "use 'knife vault create' to create."
          end
        else
          show_usage
        end
      end
    end
  end
end
