#
# Helper for configuring the Chef Zero server
# (inspired by ChefSpec)
#
def chef_zero
  require "socket"
  require "tmpdir"
  require "fileutils"
  require "chef_zero/server"
  # Find a free TCP port
  server = TCPServer.new("127.0.0.1", 0)
  port = server.addr[1].to_i
  server.close
  # Define a Chef Zero Server
  server = ChefZero::Server.new(port: port)
  # Write the private key
  tmp = Dir.mktmpdir
  key = File.join(tmp, "client.pem")
  File.write(key, ChefZero::PRIVATE_KEY)
  # Configure the server
  Chef::Config[:client_key]      = key
  Chef::Config[:client_name]     = "chefvault"
  Chef::Config[:node_name]       = "chefvault"
  Chef::Config[:chef_server_url] = server.url
  # Exit handlers
  at_exit { FileUtils.rm_rf(tmp) }
  at_exit { server.stop if server.running? }
  server
end

RSpec.describe ChefVault do
  let(:vault) { ChefVault.new("foo") }

  describe "#new" do
    context "with only a vault parameter specified" do

      it "assigns 'foo' to the vault accessor" do
        expect(vault.vault).to eq "foo"
      end
    end
  end

  context "with a vault and config file parameter specified" do
    before do
      allow(IO).to receive(:read).with("knife.rb").and_return("node_name 'myserver'")
    end

    let(:vault) { ChefVault.new("foo", "knife.rb") }

    it "assigns 'foo' to the vault accessor" do
      expect(vault.vault).to eq "foo"
    end

    it "loads the Chef config values" do
      expect(ChefVault).to receive(:load_config).with("knife.rb")
      vault
    end
  end

  describe "#version" do
    it "the version method equals VERSION" do
      expect(vault.version).to eq(ChefVault::VERSION)
    end
  end
end
