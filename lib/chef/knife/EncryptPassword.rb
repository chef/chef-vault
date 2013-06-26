# Description: Chef-Vault EncryptPassword class
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

class EncryptPassword < Chef::Knife
  deps do
    require 'chef/search/query'
    require File.expand_path('../compat', __FILE__)
    include ChefVault::Compat
  end

  banner "knife encrypt password --search SEARCH --username USERNAME --password PASSWORD --admins ADMINS"

  option :search,
    :short => '-S SEARCH',
    :long => '--search SEARCH',
    :description => 'node search for nodes to encrypt for'

  option :username,
    :short => '-U USERNAME',
    :long => '--username USERNAME',
    :description => 'username of account to encrypt'

  option :password,
    :short => '-P PASSWORD',
    :long => '--password PASSWORD',
    :description => 'password of account to encrypt'

  option :admins,
    :short => '-A ADMINS',
    :long => '--admins ADMINS',
    :description => 'administrators who can decrypt password'

  def run
    unless config[:search]
      puts("You must supply either -S or --search")
      exit 1
    end
    unless config[:username]
      puts("You must supply either -U or --username")
      exit 1
    end
    unless config[:password]
      puts("You must supply either -P or --password")
      exit 1
    end
    unless config[:admins]
      puts("You must supply either -A or --admins")
      exit 1
    end

    extend_context_object(self)

    data_bag = "passwords"
    data_bag_path = "./data_bags/#{data_bag}"

    unless ::File.exists?(data_bag_path)
      require 'fileutils'

      puts("INFO: #{data_bag_path} does not exist, creating...")
      FileUtils.mkdir_p(data_bag_path)
    end

    node_search = config[:search]
    admins = config[:admins]
    username = config[:username]
    password = config[:password]
    current_dbi = Hash.new
    current_dbi_keys = Hash.new
    if File.exists?("#{data_bag_path}/#{username}_keys.json") && File.exists?("#{data_bag_path}/#{username}.json")
      current_dbi_keys = JSON.parse(File.open("#{data_bag_path}/#{username}_keys.json"){ |file| file.read() })
      current_dbi = JSON.parse(File.open("#{data_bag_path}/#{username}.json"){ |file| file.read() })

      unless equal?(data_bag, username, "password", password)
        puts("FATAL: Password in #{data_bag_path}/#{username}.json does not match password supplied!")
        exit 1
      end
    else
      puts("INFO: Existing data bag #{data_bag}/#{username} does not exist in #{data_bag_path}, continuing as fresh build...")
    end

    # Get the public keys for all of the nodes to encrypt for.  Skipping the nodes that are already in
    # the data bag
    keyfob = Hash.new
    public_keys = search(:node, node_search).map(&:name).map do |client|
      begin
        if current_dbi_keys[client]
          puts("INFO: Skipping #{client} as it is already in the data bag...")
        else
          puts("INFO: Adding #{client} to public_key array...")
          keyfob[client] = get_client_public_key(client)
        end
      rescue Exception => node_error
        puts("WARNING: Caught exception: #{node_error.message} while processing #{client}, so skipping...")
      end
    end

    # Get the public keys for the admin users, skipping users already in the data bag
    public_keys << admins.split(/[\s,]+/).map do |user|
      begin
        if current_dbi_keys[user]
          puts("INFO: Skipping #{user} as it is already in the data bag")
        else
          puts("INFO: Adding #{user} to public_key array...")
          keyfob[user] = get_client_public_key(user)
        end
      rescue Exception => user_error
        puts("WARNING: Caught exception: #{user_error.message} while processing #{user}, so skipping...")
      end
    end

    if public_keys.length == 0
      puts "A node search for #{node_search} returned no results"
      exit 1
    end

    # Get the current secret, is nil if current secret does not exist yet
    current_secret = get_shared_secret(data_bag, username)
    data_bag_shared_key = current_secret ? current_secret : OpenSSL::PKey::RSA.new(245).to_pem.lines.to_a[1..-2].join
    enc_db_key_dbi = current_dbi_keys.empty? ? Mash.new({id: "#{username}_keys"}) : current_dbi_keys

    # Encrypt for every new node not already in the data bag
    keyfob.each do |node,pkey|
      puts("INFO: Encrypting for #{node}...")
      enc_db_key_dbi[node] = Base64.encode64(pkey.public_encrypt(data_bag_shared_key))
    end unless keyfob.empty?

    # Delete existing keys data bag and rewrite the whole bag from memory
    puts("INFO: Writing #{data_bag_path}/#{username}_keys.json...")
    File.delete("#{data_bag_path}/#{username}_keys.json") if File.exists?("#{data_bag_path}/#{username}_keys.json")
    File.open("#{data_bag_path}/#{username}_keys.json",'w'){ |file| file.write(JSON.pretty_generate(enc_db_key_dbi)) }

    # If the existing password bag does not exist, write it out with the correct password
    # Otherwise leave the existing bag alone
    if current_dbi.empty?
      dbi_mash = Mash.new({id: username, username: username, password: password})
      dbi = Chef::DataBagItem.from_hash(dbi_mash)
      edbi = Chef::EncryptedDataBagItem.encrypt_data_bag_item(dbi, data_bag_shared_key)

      puts("INFO: Writing #{data_bag_path}/#{username}.json...")
      File.open("#{data_bag_path}/#{username}.json",'w'){ |file| file.write(JSON.pretty_generate(edbi)) }
    end

    puts("INFO: Successfully wrote #{data_bag_path}/#{username}.json & #{data_bag_path}/#{username}_keys.json!")
  end

  def equal?(db, dbi, key, value)
    data_bag_path = "./data_bags/#{db}"

    shared_secret = get_shared_secret(db, dbi)
    dbi = JSON.parse(open("#{data_bag_path}/#{dbi}.json").read())
    dbi = Chef::EncryptedDataBagItem.new dbi, shared_secret

    dbi[key] == value
  end

  def get_shared_secret(db, dbi)
    data_bag_path = "./data_bags/#{db}"

    private_key = OpenSSL::PKey::RSA.new(open(Chef::Config[:client_key]).read())
    key = File.exists?("#{data_bag_path}/#{dbi}_keys.json") ? JSON.parse(File.open("#{data_bag_path}/#{dbi}_keys.json"){ |file| file.read() }) : nil
    
    begin      
      private_key.private_decrypt(Base64.decode64(key[Chef::Config[:node_name]]))
    rescue
      nil
    end
  end
end
