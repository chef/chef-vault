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
    class User < Chef::User
      # def from_hash for our implementation because name is not being
      # set correctly for Chef 10 server
      def superclass.from_hash(user_hash)
        user = Chef::User.new
        user.name user_hash['username'] ? user_hash['username'] : user_hash['name']
        user.private_key user_hash['private_key'] if user_hash.key?('private_key')
        user.password user_hash['password'] if user_hash.key?('password')
        user.public_key user_hash['public_key']
        user.admin user_hash['admin']
        user
      end
    end
  end
end