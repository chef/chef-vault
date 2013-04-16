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
      unless client.is_a?(Chef::ApiClient)
        name = client['name']
        certificate = client['certificate']
        client = Chef::ApiClient.new
        client.name name
        client.admin false

        cert_der = OpenSSL::X509::Certificate.new certificate
        
        client.public_key cert_der.public_key.to_s
      end
      
      public_key = OpenSSL::PKey::RSA.new client.public_key
      
      public_key
    end
  end
end
