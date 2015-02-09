RSpec.describe ChefVault::User do
  let(:item) { double(ChefVault::Item) }
  let(:user) { ChefVault::User.new("foo", "bar") }

  before do
    allow(ChefVault::Item).to receive(:load).with("foo", "bar"){ item }
    allow(item).to receive(:[]).with("id"){ "bar" }
    allow(item).to receive(:[]).with("password"){ "baz" }
  end

  describe '#new' do
    it 'loads item' do
      expect(ChefVault::Item).to receive(:load).with("foo", "bar")

      ChefVault::User.new("foo", "bar")
    end
  end

  describe '#[]' do
    specify { expect(user['id']).to eq 'bar' }
  end

  describe 'decrypt_password' do
    it 'echoes warning' do
      expect(STDOUT).to receive(:puts).with("WARNING: This method is deprecated, please switch to item['value'] calls")
      user.decrypt_password
    end

    it 'returns items password' do
      expect(item).to receive(:[]).with("password")
      expect(user.decrypt_password).to eq "baz"
    end
  end
end
