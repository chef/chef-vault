require 'spec_helper'
require 'chefspec'
require 'chefspec/server'

describe ChefVault::VaultItem do
  subject(:item) { ChefVault::VaultItem.new("foo", "bar") }

  describe '#new' do

    it { should be_an_instance_of ChefVault::VaultItem }

    its(:keys) { should be_an_instance_of ChefVault::VaultItemKeys }

    its(:data_bag) { should eq "foo" }

    specify { item["id"].should eq "bar" }

    specify { item.keys["id"].should eq "bar_keys" }

    specify { item.keys.data_bag.should eq "foo" }
  end

  describe '#save' do
    context 'when item["id"] is bar.bar' do
      let(:item) { ChefVault::VaultItem.new("foo", "bar.bar") }

      specify { expect { item.save }.to raise_error }
    end
  end

  describe '#update' do
    subject(:item) { ChefVault::VaultItem.new("foo", "bar") }

    before do
      ChefSpec::Server.create_client('test', { admin: true })
      Chef::Config[:node_name] = 'test'
      Chef::Config[:client_key] = nil
     
      test_nodes = [] 
      %w( name1 name2 name3 ).each do |name|
        node = stub_node(name, { roles: %w( nodes ), name: name })
        key = OpenSSL::PKey::RSA.generate(2048).public_key.to_pem
        test_nodes << node
        ChefSpec::Server.create_client(name,
                                       { public_key: key, node_name: name })
      end

      Chef::Search::Query.any_instance.stub(:search).and_return(
                                                     [ test_nodes, 1, 3 ] )
    end

    it 'should have same number of clients on refresh' do
      item.clients('role:nodes')
      item.clients.length.should == 3

      item.clients('role:nodes', :refresh)
      item.clients.length.should == 3
    end
  end

  describe '#add_server' do
    subject(:item) { ChefVault::VaultItem.new("foo", "bar") }
    let(:chef_run) { ChefSpec::Runner.new }

    before do
      ChefSpec::Server.create_client('test', { admin: true })
      Chef::Config[:node_name] = 'test'
      Chef::Config[:client_key] = nil
     
      test_nodes = [] 
      %w( name1 name2 name3 ).each do |name|
        node = stub_node(name, { roles: %w( nodes ), name: name })
        key = OpenSSL::PKey::RSA.generate(2048).public_key.to_pem
        test_nodes << node
        ChefSpec::Server.create_client(name,
                                       { public_key: key, node_name: name })
      end

      Chef::Search::Query.any_instance.stub(:search).and_return(
                                                     [ test_nodes, 1, 3 ] )
    end

    it 'should add chef-server to clients' do
      item.clients('role:clients')
      item.clients.length.should == 3

      Chef::Search::Query.any_instance.unstub(:search)
      faux_server = Chef::Node.build('faux-server')
      faux_server.normal_attrs = ({ :roles => %w( faux-server ) })
      faux_server.set['bogus']['path']['roles'] = %w( chef-server )
      ChefSpec::Server.create_client('faux-server',
          { public_key: OpenSSL::PKey::RSA.generate(2048).public_key.to_pem,
            node_name: 'faux-server' })
      chef_server = Chef::Node.build('chef-server')
      chef_server.normal_attrs = ({ :roles => %w( chef-server ) })
      ChefSpec::Server.create_client('chef-server',
          { public_key: OpenSSL::PKey::RSA.generate(2048).public_key.to_pem,
            node_name: 'chef-server' })
      Chef::Search::Query.any_instance.stub(:search).with(:node,
          'role:chef-server').and_return([ [faux_server, chef_server], 1, 2 ])
 
      item.add_server('role:chef-server')
      item.clients.length.should == 4
      item.clients.include?('chef-server').should be_true
      item.clients.include?('faux-server').should be_false
    end
  end
end
