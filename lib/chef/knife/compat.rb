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

    def get_client_public_key(client)
      client = api.get("clients/#{client}")

      # Check the response back from the api call to see if
      # we get 'certificate' which is Chef 10 or just 
      # 'public_key' which is Chef 11
      if client['certificate']
        cert = client['certificate']
        cert = OpenSSL::X509::Certificate.new cert
        public_key_der = cert.public_key
      else
        public_key_der = client['public_key']
      end
      
      public_key = OpenSSL::PKey::RSA.new public_key_der
      
      public_key
    end
  end
end
