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
        json = File.open(file, &:read)

        values_from_json(json)
      end

      def values_from_json(json)
        validate_json(json)
        JSON.parse(json)
      rescue JSON::ParserError
        raise JSON::ParserError, "#{json} is not valid JSON!"
      end

      # I/P: json string
      # Raises `InvalidValue` if any of the json's values contain non-printable characters.
      def validate_json(json)
        begin
          evaled_json = eval(json) # rubocop: disable Security/Eval
        rescue SyntaxError
          raise ChefVault::Exceptions::InvalidValue, "#{json} is not valid JSON!"
        end

        if evaled_json.is_a?(Hash)
          evaled_json.each do |key, value|
            next unless printable?(value.to_s)

            msg = "Value '#{value}' of key '#{key}' contains non-printable characters. Check that backslashes are escaped with another backslash (e.g. C:\\\\Windows) in double-quoted strings."
            raise ChefVault::Exceptions::InvalidValue, msg
          end
        end
      end

      # I/P: String
      # O/P: true/false
      # returns true if string is free of non-printable characters (escape sequences)
      # this returns false for whitespace escape sequences as well, e.g. \n\t
      def printable?(string)
        /[^[:print:]]/.match(string)
      end
    end
  end
end
