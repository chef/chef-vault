require 'spec_helper'

describe ChefVault::VaultItemKeys do
  describe '#new' do
    subject(:keys) { ChefVault::VaultItemKeys.new("foo", "bar") }

    it { is_expected.to be_an_instance_of ChefVault::VaultItemKeys }

    describe '#data_bag' do
      subject { super().data_bag }
      it { is_expected.to eq "foo" }
    end

    specify { expect(keys["id"]).to eq "bar" }

    specify { expect(keys["admins"]).to eq [] }

    specify { expect(keys["clients"]).to eq [] }
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
      expect(keys.clients.length).to eq(0)
      expect(keys['clients'].length).to eq(0)
    end
  end
end
