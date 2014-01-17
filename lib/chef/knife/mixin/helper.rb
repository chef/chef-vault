# Description: ChefVault::Mixin::Mode module
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
  module Mixin
    module Helper
      def set_mode(mode)
        if mode == "client"
          Chef::Config[:solo] = false
        else
          Chef::Config[:solo] = true
        end
      end

      def merge_values(json, file)
        values = {}
        values.merge!(values_from_file(file)) if file
        values.merge!(values_from_json(json)) if json
        values
      end

      def values_from_file(file)
        json = File.open(file){ |f| f.read() }

        values_from_json(json)
      end

      def values_from_json(json)
        begin
          JSON.parse(json)
        rescue JSON::ParserError
          raise JSON::ParserError, "#{json} is not valid JSON!"
        end
      end

      def new_vault_item(vault, item, values, json_file, file)
        vault_item = ChefVault::Item.new(vault, item)

        if values || json_file || file
          merge_values(values, json_file).each do |key, value|
            vault_item[key] = value
          end

          if file
            vault_item["file-name"] = File.basename(file)
            vault_item["file-content"] = File.open(file){ |file| file.read() }
          end
        else
          vault_json = edit_data(Hash.new)
          vault_json.each do |key, value|
            vault_item[key] = value
          end
        end

        vault_item
      end
    end
  end
end
