class ChefVault
  class Chef
    attr_accessor :config_file

    def initialize(config_file)
      @config_file = config_file
    end

    def connect
      require 'chef'
      Chef::Config.from_file(@config_file)
    end
  end
end
