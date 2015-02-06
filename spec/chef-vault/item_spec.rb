require 'openssl'
require 'rspec/core/shared_context'

# it turns out that simulating a node that doesn't have a public
# key is not a simple thing
module BorkedNodeWithoutPublicKey
  extend RSpec::Core::SharedContext

  before do
    # a node 'foo' with a public key
    node_foo = double('chef node foo')
    allow(node_foo).to receive(:name).and_return('foo')
    client_foo = double('chef apiclient foo')
    allow(client_foo).to receive(:name).and_return('foo')
    privkey = OpenSSL::PKey::RSA.new(1024)
    pubkey = privkey.public_key
    allow(client_foo).to receive(:public_key).and_return(pubkey.to_pem)
    # a node 'bar' without a public key
    node_bar = double('chef node bar')
    allow(node_bar).to receive(:name).and_return('bar')
    # fake out searches to return both of our nodes
    query_result = double('chef search results')
    allow(query_result)
      .to receive(:search)
      .with(Symbol, String)
      .and_return([[node_foo, node_bar]])
    allow(Chef::Search::Query)
      .to receive(:new)
      .and_return(query_result)
    # create a new vault item
    @vaultitem = ChefVault::Item.new('foo', 'bar')
    @vaultitem['foo'] = 'bar'
    # make the vault item return the apiclient for foo but raise for bar
    allow(@vaultitem).to receive(:load_client).with('foo')
      .and_return(client_foo)
    allow(@vaultitem).to receive(:load_client).with('bar')
      .and_raise(ChefVault::Exceptions::ClientNotFound)
    # make the vault item fall back to 'load-admin-as-client' behaviour
    http_response = double('http not found')
    allow(http_response).to receive(:code).and_return('404')
    http_not_found = Net::HTTPServerException.new('not found', http_response)
    allow(ChefVault::ChefPatch::User)
      .to receive(:load)
      .with('foo')
      .and_return(client_foo)
    allow(ChefVault::ChefPatch::User)
      .to receive(:load)
      .with('bar')
      .and_raise(http_not_found)
  end
end

RSpec.describe ChefVault::Item do
  subject(:item) { ChefVault::Item.new("foo", "bar") }

  describe '#new' do

    it { should be_an_instance_of ChefVault::Item }

    its(:keys) { should be_an_instance_of ChefVault::ItemKeys }

    its(:data_bag) { should eq "foo" }

    specify { expect(item['id']).to eq 'bar' }

    specify { expect(item.keys['id']).to eq 'bar_keys' }

    specify { expect(item.keys.data_bag).to eq 'foo' }
  end

  describe '#save' do
    context 'when item["id"] is bar.bar' do
      let(:item) { ChefVault::Item.new("foo", "bar.bar") }

      specify { expect { item.save }.to raise_error }
    end
  end

  describe '#clients' do
    include BorkedNodeWithoutPublicKey

    it 'should not blow up when search returns a node without a public key' do
      # try to set clients when we know a node is missing a public key
      # this should not die as of v2.4.1
      expect {
        @vaultitem.clients('*:*')
      }.not_to raise_error
    end

    it 'should emit a warning if search returns a node without a public key' do
      # it should however emit a warning that you have a borked node
      expect {
        @vaultitem.clients('*:*')
      }.to output(/node 'bar' has no private key; skipping/).to_stderr
    end
  end

  describe '#admins' do
    include BorkedNodeWithoutPublicKey

    it 'should blow up if you try to use a node without a public key as an admin' do
      expect {
        @vaultitem.admins('foo,bar')
      }.to raise_error(ChefVault::Exceptions::AdminNotFound)
    end
  end
end
