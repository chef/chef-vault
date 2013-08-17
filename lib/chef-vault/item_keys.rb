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

class ChefVault::ItemKeys < Chef::DataBagItem
  def initialize(vault, name)
    super() # parenthesis required to strip off parameters
    @data_bag = vault
    @raw_data["id"] = name
  end

  def include?(key)
    @raw_data.keys.include?(key)
  end

  def add_key(chef_client, data_bag_shared_secret)
    public_key = OpenSSL::PKey::RSA.new chef_client.public_key
    self[chef_client.name] = 
      Base64.encode64(public_key.public_encrypt(data_bag_shared_secret))
  end

  def save(item_id=@raw_data['id'])
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

  def to_json(*a)
    json = super
    json.gsub(self.class.name, self.class.superclass.name)
  end

  def self.from_data_bag_item(data_bag_item)
    item = new(data_bag_item.data_bag, data_bag_item.name)
    item.raw_data = data_bag_item.raw_data
    item
  end

  def self.load(vault, name)
    data_bag_item = Chef::DataBagItem.load(vault, name)
    from_data_bag_item(data_bag_item)
  end
end