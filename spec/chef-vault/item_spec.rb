require 'spec_helper'

describe ChefVault::Item do
  subject(:item) { ChefVault::Item.new("foo", "bar") }

  describe '#new' do

    it { should be_an_instance_of ChefVault::Item }

    its(:keys) { should be_an_instance_of ChefVault::ItemKeys }

    its(:data_bag) { should eq "foo" }

    specify { item["id"].should eq "bar" }

    specify { item.keys["id"].should eq "bar_keys" }

    specify { item.keys.data_bag.should eq "foo" }
  end

  describe '#save' do
    context 'when item["id"] is bar.bar' do
      let(:item) { ChefVault::Item.new("foo", "bar.bar") }

      specify { expect { item.save }.to raise_error }
    end
  end
end
