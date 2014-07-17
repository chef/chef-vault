# Author:: Kevin Moser <kevin.moser@nordstrom.com>
# Copyright:: Copyright 2013, Nordstrom, Inc.
# License:: Apache License, Version 2.0

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class ChefVault
  module ChefPatch
    class ApiClient < Chef::ApiClient
      # Fix an issue where core Chef::ApiClient does not load
      # the private key for Chef 10
      def self.load(name)
        response = http_api.get("clients/#{name}")
        if response.kind_of?(Chef::ApiClient)
          response
        else
          client = Chef::ApiClient.new
          client.name(response['clientname'])

          if response['certificate']
            der = OpenSSL::X509::Certificate.new response['certificate']
            client.public_key der.public_key.to_s
          end

          if response['public_key']
            der = OpenSSL::PKey::RSA.new response['public_key']
            client.public_key der.public_key.to_s
          end

          client
        end
      end
    end
  end
end
