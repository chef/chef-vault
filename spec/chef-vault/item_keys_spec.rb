RSpec.describe ChefVault::ItemKeys do
  describe '#new' do
    subject(:keys) { ChefVault::ItemKeys.new("foo", "bar") }

    it { should be_an_instance_of ChefVault::ItemKeys }

    its(:data_bag) { should eq "foo" }

    specify { expect(keys["id"]).to eq 'bar' }

    specify { expect(keys["admins"]).to eq [] }

    specify { expect(keys["clients"]).to eq [] }
  end
end
