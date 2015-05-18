RSpec.describe ChefVault::User do
  let(:item) { double(ChefVault::Item) }
  let(:user) { ChefVault::User.new("foo", "bar") }

  before do
    allow(ChefVault::Item).to receive(:load).with("foo", "bar"){ item }
    allow(item).to receive(:[]).with("id"){ "bar" }
    allow(item).to receive(:[]).with("password"){ "baz" }
    @orig_stdout = $stdout
    $stdout = File.open(File::NULL, 'w')
  end

  after do
    $stdout = @orig_stdout
  end

  describe '#new' do
    it 'loads item' do
      expect(ChefVault::Item).to receive(:load).with("foo", "bar")

      ChefVault::User.new("foo", "bar")
    end
  end

  describe '#[]' do
    it "returns the value of the 'id' parameter" do
      expect(user['id']).to eq 'bar'
    end
  end

  describe 'decrypt_password' do
    it 'echoes warning' do
      expect { user.decrypt_password }
        .to output("WARNING: This method is deprecated, please switch to item['value'] calls\n")
        .to_stdout
    end

    it 'returns items password' do
      expect(item).to receive(:[]).with("password")
      expect(user.decrypt_password).to eq "baz"
    end
  end
end
