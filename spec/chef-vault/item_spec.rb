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
end
