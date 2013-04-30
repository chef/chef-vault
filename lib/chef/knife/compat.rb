# Description: ChefVault::Compat module
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
