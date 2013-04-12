class ChefVault
  class ChefOffline
    attr_accessor :config_file

    def initialize(config_file)
      @config_file = config_file
    end

    def connect
      require 'chef'
      ::Chef::Config.from_file(@config_file)
    end
  end
end
