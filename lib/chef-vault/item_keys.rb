# Author:: Kevin Moser <kevin.moser@nordstrom.com>
# Copyright:: Copyright 2013-15, Nordstrom, Inc.
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

require "chef-vault/mixins"

class ChefVault
  class ItemKeys < Chef::DataBagItem

    include ChefVault::Mixins

    def initialize(vault, name)
      super() # parentheses required to strip off parameters
      @data_bag = vault
      @raw_data["id"] = name
      @raw_data["admins"] = []
      @raw_data["clients"] = []
      @raw_data["search_query"] = []
    end

    def include?(key)
      @raw_data.keys.include?(key)
    end

    def add(chef_key, data_bag_shared_secret)
      type = chef_key.type
      unless @raw_data.key?(type)
        raise ChefVault::Exceptions::V1Format,
              "cannot manage a v1 vault.  See UPGRADE.md for help"
      end
      self[chef_key.name] = ChefVault::ItemKeys.encode_key(chef_key.key, data_bag_shared_secret)
      @raw_data[type] << chef_key.name unless @raw_data[type].include?(chef_key.name)
      @raw_data[type]
    end

    def delete(chef_key)
      raw_data.delete(chef_key.name)
      raw_data[chef_key.type].delete(chef_key.name)
    end

    def search_query(search_query = nil)
      if search_query
        @raw_data["search_query"] = search_query
      else
        @raw_data["search_query"]
      end
    end

    def clients
      @raw_data["clients"]
    end

    def admins
      @raw_data["admins"]
    end

    def save(item_id = @raw_data["id"])
      if Chef::Config[:solo]
        save_solo(item_id)
      else
        begin
          Chef::DataBag.load(data_bag)
        rescue Net::HTTPServerException => http_error
          if http_error.response.code == "404"
            chef_data_bag = Chef::DataBag.new
            chef_data_bag.name data_bag
            chef_data_bag.create
          end
        end

        super
      end
    end

    def destroy
      if Chef::Config[:solo]
        data_bag_path = File.join(Chef::Config[:data_bag_path],
                                  data_bag)
        data_bag_item_path = File.join(data_bag_path, @raw_data["id"])

        FileUtils.rm("#{data_bag_item_path}.json")

        nil
      else
        super(data_bag, id)
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
      begin
        data_bag_item = Chef::DataBagItem.load(vault, name)
      rescue Net::HTTPServerException => http_error
        if http_error.response.code == "404"
          raise ChefVault::Exceptions::KeysNotFound,
            "#{vault}/#{name} could not be found"
        else
          raise http_error
        end
      rescue Chef::Exceptions::ValidationFailed
        raise ChefVault::Exceptions::KeysNotFound,
          "#{vault}/#{name} could not be found"
      end

      from_data_bag_item(data_bag_item)
    end

    # @private

    def self.encode_key(key_string, data_bag_shared_secret)
      public_key = OpenSSL::PKey::RSA.new(key_string)
      Base64.encode64(public_key.public_encrypt(data_bag_shared_secret))
    end
  end
end
