require 'spec_helper'

describe ChefVault::Item do
  describe '#new' do
    before(:each) do
      @item = ChefVault::Item.new("foo", "bar")
    end

    it 'is an instance of ChefVault::Item' do
      expect(@item).to be_an_instance_of ChefVault::Item
    end

    it 'sets data_bag to foo' do
      expect(@item.data_bag).to eq "foo"
    end

    it 'sets item["id"] to bar' do
      expect(@item["id"]).to eq "bar"
    end

    it 'sets item.keys to ChefVault::ItemKeys' do
      expect(@item.keys).to be_an_instance_of ChefVault::ItemKeys
    end

    it 'sets item.keys.data_bag to foo' do
      expect(@item.keys.data_bag).to eq "foo"
    end

    it 'sets item.keys["id"] to bar_keys' do
      expect(@item.keys["id"]).to eq "bar_keys"
    end
  end
end