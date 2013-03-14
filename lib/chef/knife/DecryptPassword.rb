require 'chef/knife'

class DecryptPassword < Chef::Knife
  deps do
    require 'chef/search/query'
    require 'chef/shef/ext'
    require 'json'
  end

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
    Shef::Extensions.extend_context_object(self)

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
