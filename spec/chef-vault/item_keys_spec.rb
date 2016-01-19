RSpec.describe ChefVault::ItemKeys do
  describe '#new' do
    let(:keys) { ChefVault::ItemKeys.new("foo", "bar") }

    it "'foo' is assigned to @data_bag" do
      expect(keys.data_bag).to eq "foo"
    end

    it "sets the keys id to 'bar'" do
      expect(keys["id"]).to eq "bar"
    end

    it "initializes the keys[admin] to an empty array" do
      expect(keys["admins"]).to eq []
    end

    it "initializes the keys[clients] to an empty array" do
      expect(keys["admins"]).to eq []
    end
  end
end
