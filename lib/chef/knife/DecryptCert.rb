require 'chef/knife'

class DecryptCert < Chef::Knife
  deps do
    require 'chef/search/query'
    require 'chef/shef/ext'
    require 'json'
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
    Shef::Extensions.extend_context_object(self)

    data_bag = "certs"
    data_bag_path = "./data_bags/#{data_bag}"

    name = config[:name]

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
