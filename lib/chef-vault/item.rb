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
    @keys = ChefVault::ItemKeys.new(vault, "#{name}_keys")
    @secret = secret ? secret : generate_secret
    @encrypted = false
  end

  def encrypt!
    @raw_data = Chef::EncryptedDataBagItem.encrypt_data_bag_item(self, @secret)
    @encrypted = true
  end

  def clients(search)
    q = Chef::Search::Query.new
    q.search(:node, search)[0].each do |node|
      keys.add_key(ChefVault::ChefPatch::ApiClient.load(node.name), @secret)
    end
  end

  def admins(admins)
    admins.split(",").each do |admin|
      keys.add_key(ChefVault::ChefPatch::User.load(admin), @secret)
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

  def rotate_secret!
    @secret = generate_secret
    @keys.raw_data.each do |key, value|
      unless key == "id"
        # Try as admin first, if not found search for node
        begin
          admins(key)
        rescue Net::HTTPServerException => http_exception
          if http_exception.response.code == "404"
            clients("name:#{key}")
          else
            raise http_exception
          end
        end
      end
    end

    encrypt!
  end

  def generate_secret
    OpenSSL::PKey::RSA.new(245).to_pem.lines.to_a[1..-2].join
  end

  def save(item_id=@raw_data['id'])
    # save the keys first, raising an error if no keys were defined
    unless keys.raw_data.count > 1
      raise ChefVault::Exceptions::NoKeysDefined, 
            "No keys defined for #{item_id}"
    end

    keys.save

    # Make sure the item is encrypted before saving
    encrypt! unless @encrypted

    # Now save the encrypted data
    if Chef::Config[:solo]
      data_bag_path = File.join(Chef::Config[:data_bag_path],
                                data_bag)
      data_bag_item_path = File.join(data_bag_path, item_id)

      FileUtils.mkdir(data_bag_path) unless data_bag_path
      File.open("#{data_bag_item_path}.json",'w') do |file| 
        file.write(JSON.pretty_generate(self))
      end
      self
    else
      super
    end
  end

  def self.json_create(o)
    o["json_class"] = "Chef::DataBagItem"
    super
  end

  def self.load(vault, name)
    item = new(vault, name)
    item.keys = ChefVault::ItemKeys.load(vault, "#{name}_keys")
    item.raw_data = 
      Chef::EncryptedDataBagItem.load(vault, name, item.secret).to_hash
    item
  end
end
