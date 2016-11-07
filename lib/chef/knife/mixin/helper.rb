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
          Chef::Config[:solo_legacy_mode] = false
        else
          Chef::Config[:solo_legacy_mode] = true
        end
      end

      def merge_values(json, file)
        values = {}
        values.merge!(values_from_file(file)) if file
        values.merge!(values_from_json(json)) if json

        values
      end

      def values_from_file(file)
        json = File.open(file) { |fh| fh.read() }

        values_from_json(json)
      end

      def values_from_json(json)
        JSON.parse(json)
      rescue JSON::ParserError
        raise JSON::ParserError, "#{json} is not valid JSON!"
      end
    end
  end
end
