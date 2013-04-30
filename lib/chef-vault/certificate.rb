# Description: ChefVault::Certificate class
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

class ChefVault
  class Certificate
    attr_accessor :name

    def initialize(data_bag, name, chef_config_file)
      @name = name
      @data_bag = data_bag

      if chef_config_file
        chef = ChefVault::ChefOffline.new(chef_config_file)
        chef.connect
      end
    end

    def decrypt_contents
      # use the private client_key file to create a decryptor
      private_key = open(Chef::Config[:client_key]).read
      private_key = OpenSSL::PKey::RSA.new(private_key)
      
      begin
        keys = Chef::DataBagItem.load(@data_bag, "#{name}_keys")
      rescue
        throw "Could not find data bag item #{name}_keys in data bag #{@data_bag}"
      end

      unless keys[Chef::Config[:node_name]]
        throw "#{name} is not encrypted for you!  Rebuild the certificate data bag"
      end

      node_key = Base64.decode64(keys[Chef::Config[:node_name]])
      shared_secret = private_key.private_decrypt(node_key)
      certificate = Chef::EncryptedDataBagItem.load(@data_bag, @name, shared_secret)

      certificate["contents"]
    end
  end
end
