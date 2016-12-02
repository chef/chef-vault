class ChefVault
  module Mixins
    # In Chef 12, Chef Solo can have an array of data_bag paths, rather
    # than just a string. To cope with that, we'll:
    #  1. Look for an existing data bag item in any of the configured
    #     paths and use that by preference
    #  1. Otherwise, just use the first location in the array
    def find_solo_path(item_id)
      if Chef::Config[:data_bag_path].kind_of?(Array)
        path = Chef::Config[:data_bag_path].find do |dir|
          File.exist?(File.join(dir, data_bag, "#{item_id}.json"))
        end

        path ||= Chef::Config[:data_bag_path].first
        data_bag_path = File.join(path, data_bag)
      else
        data_bag_path = File.join(Chef::Config[:data_bag_path],
                                  data_bag)
      end
      data_bag_item_path = File.join(data_bag_path, item_id) + ".json"

      [data_bag_path, data_bag_item_path]
    end

    def save_solo(item_id = @raw_data["id"], raw_data = @raw_data)
      data_bag_path, data_bag_item_path = find_solo_path(item_id)

      FileUtils.mkdir(data_bag_path) unless File.exist?(data_bag_path)
      File.open(data_bag_item_path, "w") do |file|
        file.write(JSON.pretty_generate(raw_data))
      end

      raw_data
    end

    def delete_solo(item_id = @raw_data["id"])
      _data_bag_path, data_bag_item_path = find_solo_path(item_id)
      FileUtils.rm(data_bag_item_path) if File.exist?(data_bag_item_path)
    end

    def load_solo(item_id = @raw_data["id"])
      _data_bag_path, data_bag_item_path = find_solo_path(item_id)
      JSON.parse(File.read(data_bag_item_path)) if File.exist?(data_bag_item_path)
    end
  end
end
