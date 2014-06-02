require 'spec_helper'

describe ChefVault::VaultItemKeys do
  describe '#new' do
    subject(:keys) { ChefVault::VaultItemKeys.new("foo", "bar") }

    it { should be_an_instance_of ChefVault::VaultItemKeys }

    its(:data_bag) { should eq "foo" }

    specify { keys["id"].should eq "bar" }

    specify { keys["admins"].should eq [] }

    specify { keys["clients"].should eq [] }
  end

  describe '#clear_clients' do
    subject(:keys) { ChefVault::VaultItemKeys.new("foo", "bar") }

    it 'should empty clients list' do
      %w( name1 name2 name3 ).each do |name|
        client = Chef::ApiClient.new
        client.name(name)
        client.public_key(OpenSSL::PKey::RSA.generate(2048).public_key.to_pem)
        keys.add(client, 'secret', 'clients')
      end
      keys.clear_clients
      keys.clients.length.should == 0
      keys['clients'].length.should == 0
    end
  end
end
