# Description: Chef-Vault DecryptCert class
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

class DecryptCert < Chef::Knife
  deps do
    require 'chef/search/query'
    require 'json'
    require File.expand_path('../compat', __FILE__)
    include ChefVault::Compat
  end

  banner "knife decrypt cert --name NAME"

  option :name,
    :short => '-N NAME',
    :long => '--name NAME',
    :description => 'Certificate data bag name'

  def run
    unless config[:name]
      puts("You must supply a certificate to decrypt")
      exit 1
    end
    extend_context_object(self)

    data_bag = "certs"
    data_bag_path = "./data_bags/#{data_bag}"

    name = config[:name].gsub(".", "_")

    user_private_key = OpenSSL::PKey::RSA.new(open(Chef::Config[:client_key]).read())
    key = JSON.parse(IO.read("#{data_bag_path}/#{name}_keys.json"))
    unless key[Chef::Config[:node_name]]
      puts("Can't find a key for #{Chef::Config[:node_name]}...  You can't decrypt!")
      exit 1
    end

    data_bag_shared_key = user_private_key.private_decrypt(Base64.decode64(key[Chef::Config[:node_name]]))

    certificate = JSON.parse(open("#{data_bag_path}/#{name}.json").read())
    certificate = Chef::EncryptedDataBagItem.new certificate, data_bag_shared_key

    puts("certificate:\n#{certificate['contents']}")
  end
end
