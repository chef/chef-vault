require 'spec_helper'

describe ChefVault do
  describe '#new' do
    context 'with only a vault parameter specified' do
      before(:each) do
        @vault = ChefVault.new('foo')
      end

      it 'is an instance of ChefVault' do
        expect(@vault).to be_an_instance_of ChefVault
      end

      it 'sets vault to foo' do
        expect(@vault.vault).to eq "foo"
      end
    end

    context 'with a vault and config file parameter specified' do
      before(:each) do
        IO.stub(:read).with('knife.rb').and_return("node_name 'bar'")
        @vault = ChefVault.new('foo', 'knife.rb')
      end

      it 'is an instance of ChefVault' do
        expect(@vault).to be_an_instance_of ChefVault
      end

      it 'sets vault to foo' do
        expect(@vault.vault).to eq "foo"
      end

      it 'sets Chef::Config[:node_name] to bar' do
        expect(Chef::Config[:node_name]).to eq "bar"
      end
    end
  end

  describe '#version' do
    it 'returns the version number' do
      vault = ChefVault.new('foo')
      expect(vault.version).to eq ChefVault::VERSION
    end
  end

  describe '#self.load_config' do
    before(:each) do
      IO.stub(:read).with('knife.rb').and_return("node_name 'bar'")
      ChefVault.load_config("knife.rb")
    end

    it "sets Chef::Config[:node_name] to bar" do
      expect(Chef::Config[:node_name]).to eq "bar"
    end
  end
end
