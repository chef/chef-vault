require 'spec_helper'

describe ChefVault::ItemKeys do
  describe '#new' do
    subject(:keys) { ChefVault::ItemKeys.new("foo", "bar") }

    it { should be_an_instance_of ChefVault::ItemKeys }

    its(:data_bag) { should eq "foo" }

    specify { keys["id"].should eq "bar" }

    specify { keys["admins"].should eq [] }

    specify { keys["clients"].should eq [] }
  end
end
