RSpec.describe ChefVault do
  let(:vault) { ChefVault.new("foo") }

  describe "#new" do
    context "with only a vault parameter specified" do

      it "assigns 'foo' to the vault accessor" do
        expect(vault.vault).to eq "foo"
      end
    end
  end

  context "with a vault and config file parameter specified" do
    before do
      allow(IO).to receive(:read).with("knife.rb").and_return("node_name 'myserver'")
    end

    let(:vault) { ChefVault.new("foo", "knife.rb") }

    it "assigns 'foo' to the vault accessor" do
      expect(vault.vault).to eq "foo"
    end

    it "loads the Chef config values" do
      expect(ChefVault).to receive(:load_config).with("knife.rb")
      vault
    end
  end

  describe "#version" do
    it "the version method equals VERSION" do
      expect(vault.version).to eq(ChefVault::VERSION)
    end
  end
end
