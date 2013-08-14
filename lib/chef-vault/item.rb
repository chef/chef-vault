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

class ChefVault::Item < Chef::DataBagItem
  attr_accessor :keys
  attr_accessor :encrypted_data_bag_item

  def initialize(vault, name, secret=nil)
    super() # Don't pass parameters
    @data_bag = vault
    @raw_data["id"] = name
    @keys = ChefVault::ItemKeys.new(vault, name)
    @secret = secret ? secret : 
      OpenSSL::PKey::RSA.new(245).to_pem.lines.to_a[1..-2].join 
  end

  def encrypt!
    @encrypted_data_bag_item = Chef::EncryptedDataBagItem.encrypt_data_bag_item(self, @secret)
    id = @raw_data["id"]
    @raw_data = {}
    @raw_data["id"] = id
  end

  def clients(search)
    q = Chef::Search::Query.new
    q.search(:node, search)[0].each do |node|
      keys.add_key(ChefVault::ChefApiClient.load(node.name), @secret)
    end
  end

  def admins(admins)
    admins.split(",").each do |admin|
      keys.add_key(ChefVault::ChefUser.load(admin), @secret)
    end
  end

  def secret
    if @keys.include?(Chef::Config[:node_name])
      private_key = OpenSSL::PKey::RSA.new(open(Chef::Config[:client_key]).read())
      private_key.private_decrypt(Base64.decode64(@keys[Chef::Config[:node_name]]))
    else
      raise ChefVault::Exceptions::SecretDecryption.new("#{@raw_data["id"]} is not encrypted for you!")
    end
  end

  def [](key)
    @encrypted_data_bag_item[key]
  end

  def to_json
    @encrypted_data_bag_item.to_json
  end

  def self.load(vault, name)
    item = new(vault, name)
    item.keys = ChefVault::ItemKeys.load(vault, "#{name}_keys")
    item.encrypted_data_bag_item = 
      Chef::EncryptedDataBagItem.load(vault, name, item.secret)
    item
  end
end
