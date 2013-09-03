require 'spec_helper'

describe ChefVault::ItemKeys do
  describe '#new' do
    before(:each) do
      @keys = ChefVault::ItemKeys.new("foo", "bar")
    end

    it 'is an instance of ChefVault::ItemKeys' do
      expect(@keys).to be_an_instance_of ChefVault::ItemKeys
    end

    it 'sets data_bag to foo' do
      expect(@keys.data_bag).to eq "foo"
    end

    it 'sets keys["id"] to bar' do
      expect(@keys["id"]).to eq "bar"
    end

    it 'sets keys["admins"] to []' do
      expect(@keys["admins"]).to eq []
    end

    it 'sets keys["clients"] to []' do
      expect(@keys["clients"]).to eq []
    end
  end
end
