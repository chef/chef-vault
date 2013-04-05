class ChefKeepass
  class Certificate
    attr_accessor :name

    def initialize(data_bag, name)
      @name = name
      @data_bag = data_bag
    end

    def decrypt_contents
      # use the private client_key file to create a decryptor
      private_key = open(Chef::Config[:client_key]).read
      private_key = OpenSSL::PKey::RSA.new(private_key)
      keys = Chef::DataBagItem.load(@data_bag, "#{name}_keys")

      unless keys[Chef::Config[:node_name]]
        throw "#{name} is not encrypted for you!  Rebuild the certificate data bag"
      end

      node_key = Base64.decode64(keys[Chef::Config[:node_name]])
      shared_secret = private_key.private_decrypt(node_key)
      certificate = Chef::EncryptedDataBagItem.load(@data_bag, @name, shared_secret)

      certificate["contents"]
    end
  end
end