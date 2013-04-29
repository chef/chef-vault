require 'spec_helper'

describe ChefVault do

  describe '#new' do
    context 'with only a data bag parameter specified' do
      before(:each) do
        @vault = ChefVault.new('foo')
      end

      it 'is an instance of ChefVault' do
        expect(@vault).to be_an_instance_of ChefVault
      end

      it 'correctly assigns the data_bag instance var' do
        expect(@vault.data_bag).to eq 'foo'
      end

      it 'defaults to nil for the chef_config_file' do
        expect(@vault.chef_config_file).to be_nil
      end
    end

    context 'with data_bag and chef_config_file parameters specified' do
      before(:each) do
        @vault = ChefVault.new('foo', '~/chef-repo/.chef/knife.rb')
      end

      it 'correctly assigns the data_bag instance var' do
        expect(@vault.data_bag).to eq 'foo'
      end

      it 'correctly assigns the chef_config_file var' do
        expect(@vault.chef_config_file).to eq '~/chef-repo/.chef/knife.rb'
      end
    end
  end

  describe '#version' do
    it 'returns the version number' do
      vault = ChefVault.new('foo')
      expect(vault.version).to eq ChefVault::VERSION
    end
  end

  describe '#user' do
    before(:each) do
      @vault = ChefVault.new('foo')
      @user = @vault.user('mysql')
    end

    it 'is an instance of ChefVault::User' do
      expect(@user).to be_an_instance_of ChefVault::User
    end
  end

  describe '#certificate' do
    before(:each) do
      @vault = ChefVault.new('certs')
      @cert = @vault.certificate('my_ssl_cert')
    end

    it 'is an instance of ChefVault::Certificate' do
      expect(@cert).to be_an_instance_of ChefVault::Certificate
    end
  end
end
