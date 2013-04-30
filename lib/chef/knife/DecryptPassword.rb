# Description: Chef-Vault DecryptPassword class
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

require 'chef/knife'

class DecryptPassword < Chef::Knife
  deps do
    require 'chef/search/query'
    require 'json'
    require File.expand_path('../compat', __FILE__)
  end
  include ChefVault::Compat

  banner "knife decrypt password --username USERNAME"

  option :username,
    :short => '-U USERNAME',
    :long => '--username USERNAME',
    :description => 'username of account to encrypt' 

  def run
    unless config[:username]
      puts("You must supply a username to decrypt")
      exit 1
    end
    extend_context_object(self)

    data_bag_path = "./data_bags/passwords"

    username = config[:username]

    user_private_key = OpenSSL::PKey::RSA.new(open(Chef::Config[:client_key]).read())
    key = JSON.parse(IO.read("#{data_bag_path}/#{username}_keys.json"))
    unless key[Chef::Config[:node_name]]
      puts("Can't find a key for #{Chef::Config[:node_name]}...  You can't decrypt!")
      exit 1
    end

    data_bag_shared_key = user_private_key.private_decrypt(Base64.decode64(key[Chef::Config[:node_name]]))

    credential = JSON.parse(open("#{data_bag_path}/#{username}.json").read())
    credential = Chef::EncryptedDataBagItem.new credential, data_bag_shared_key

    puts("username: #{credential['username']}, password: #{credential['password']}")
  end
end
