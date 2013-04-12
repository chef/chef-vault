# Make a wraper to chef10/11 "shef/shell" changes 

module ChefVault
  module Compat
    require 'chef/version'
    def extend_context_object(obj)
      if Chef::VERSION.to_i >= 11 
        require "chef/shell/ext"
        Shell::Extensions.extend_context_object(obj)
      else 
        require 'chef/shef/ext'
        Shef::Extensions.extend_context_object(obj)
      end
    end
  end
end
