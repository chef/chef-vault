require "openssl"
require "rspec/core/shared_context"

# it turns out that simulating a node that doesn't have a public
# key is not a simple thing
module BorkedNodeWithoutPublicKey
  extend RSpec::Core::SharedContext

  before do
    # a node 'foo' with a public key
    node_foo = double("chef node foo")
    allow(node_foo).to receive(:name).and_return("foo")
    client_foo = double("chef apiclient foo")
    allow(client_foo).to receive(:name).and_return("foo")
    privkey = OpenSSL::PKey::RSA.new(1024)
    pubkey = privkey.public_key
    allow(client_foo).to receive(:public_key).and_return(pubkey.to_pem)
    # a node 'bar' without a public key
    node_bar = double("chef node bar")
    allow(node_bar).to receive(:name).and_return("bar")
    # fake out searches to return both of our nodes
    query_result = double("chef search results")
    allow(query_result)
      .to receive(:search)
      .with(Symbol, String)
      .and_yield(node_foo).and_yield(node_bar)
    allow(Chef::Search::Query)
      .to receive(:new)
      .and_return(query_result)
    # create a new vault item
    @vaultitem = ChefVault::Item.new("foo", "bar")
    @vaultitem["foo"] = "bar"
    # make the vault item return the apiclient for foo but raise for bar
    allow(@vaultitem).to receive(:load_client).with("foo")
      .and_return(client_foo)
    allow(@vaultitem).to receive(:load_client).with("bar")
      .and_raise(ChefVault::Exceptions::ClientNotFound)
    # make the vault item fall back to 'load-admin-as-client' behaviour
    http_response = double("http not found")
    allow(http_response).to receive(:code).and_return("404")
    http_not_found = Net::HTTPServerException.new("not found", http_response)
    allow(ChefVault::ChefPatch::User)
      .to receive(:load)
      .with("foo")
      .and_return(client_foo)
    allow(ChefVault::ChefPatch::User)
      .to receive(:load)
      .with("bar")
      .and_raise(http_not_found)
  end
end

RSpec.describe ChefVault::Item do
  before do
    @orig_stdout = $stdout
    $stdout = File.open(File::NULL, "w")
  end

  after do
    $stdout = @orig_stdout
  end

  subject(:item) { ChefVault::Item.new("foo", "bar") }

  describe "vault probe predicates" do
    before do
      # a normal data bag item
      @db = { "foo" => "..." }
      @dbi = Chef::DataBagItem.new
      @dbi.data_bag("normal")
      @dbi.raw_data = { "id" => "foo", "foo" => "bar" }
      allow(@db).to receive(:load).with("foo").and_return(@dbi)
      allow(Chef::DataBag).to receive(:load).with("normal").and_return(@db)
      allow(Chef::DataBagItem).to receive(:load).with("normal", "foo").and_return(@dbi)

      # an encrypted data bag item (non-vault)
      @encdb = { "foo" => "..." }
      @encdbi = Chef::DataBagItem.new
      @encdbi.data_bag("encrypted")
      @encdbi.raw_data = {
        "id" => "foo",
        "foo" => { "encrypted_data" => "..." },
      }
      allow(@encdb).to receive(:load).with("foo").and_return(@encdbi)
      allow(Chef::DataBag).to receive(:load).with("encrypted").and_return(@encdb)
      allow(Chef::DataBagItem).to receive(:load).with("encrypted", "foo").and_return(@encdbi)

      # two items that make up a vault
      @vaultdb = { "foo" => "...", "foo_keys" => "..." }
      @vaultdbi = Chef::DataBagItem.new
      @vaultdbi.data_bag("vault")
      @vaultdbi.raw_data = {
        "id" => "foo",
        "foo" => { "encrypted_data" => "..." },
      }
      allow(@vaultdb).to receive(:load).with("foo").and_return(@vaultdbi)
      @vaultdbki = Chef::DataBagItem.new
      @vaultdbki.data_bag("vault")
      @vaultdbki.raw_data = { "id" => "foo_keys" }
      allow(@vaultdb).to receive(:load).with("foo_keys").and_return(@vaultdbki)
      allow(Chef::DataBag).to receive(:load).with("vault").and_return(@vaultdb)
      allow(Chef::DataBagItem).to receive(:load).with("vault", "foo").and_return(@vaultdbi)
    end

    describe "::vault?" do
      it "should detect a vault item" do
        expect(ChefVault::Item.vault?("vault", "foo")).to be_truthy
      end

      it "should detect non-vault items" do
        expect(ChefVault::Item.vault?("normal", "foo")).not_to be_truthy
        expect(ChefVault::Item.vault?("encrypted", "foo")).not_to be_truthy
      end
    end

    describe "::data_bag_item_type" do
      it "should detect a vault item" do
        expect(ChefVault::Item.data_bag_item_type("vault", "foo")).to eq(:vault)
      end

      it "should detect an encrypted data bag item" do
        expect(ChefVault::Item.data_bag_item_type("encrypted", "foo")).to eq(:encrypted)
      end

      it "should detect a normal data bag item" do
        expect(ChefVault::Item.data_bag_item_type("normal", "foo")).to eq(:normal)
      end
    end
  end

  describe "::new" do
    it "item[keys] is an instance of ChefVault::ItemKeys" do
      expect(item.keys).to be_an_instance_of(ChefVault::ItemKeys)
    end

    it "the item's 'vault' parameter is assigned to data_bag" do
      expect(item.data_bag).to eq "foo"
    end

    it "the vault item name is assiged to the data bag ['id']" do
      expect(item["id"]).to eq "bar"
    end

    it "creates a corresponding 'keys' data bag with an '_keys' id" do
      expect(item.keys["id"]).to eq "bar_keys"
    end

    it "sets the item keys data bag to 'foo'" do
      expect(item.keys.data_bag).to eq "foo"
    end

    it "defaults the node name" do
      item = ChefVault::Item.new("foo", "bar")
      expect(item.node_name).to eq(Chef::Config[:node_name])
    end

    it "defaults the client key path" do
      item = ChefVault::Item.new("foo", "bar")
      expect(item.client_key_path).to eq(Chef::Config[:client_key])
    end

    it "allows for a node name override" do
      item = ChefVault::Item.new("foo", "bar", node_name: "baz")
      expect(item.node_name).to eq("baz")
    end

    it "allows for a client key path override" do
      item = ChefVault::Item.new("foo", "bar", client_key_path: "/foo/client.pem")
      expect(item.client_key_path).to eq("/foo/client.pem")
    end

    it "allows for both node name and client key overrides" do
      item = ChefVault::Item.new(
        "foo", "bar",
        node_name: "baz",
        client_key_path: "/foo/client.pem"
      )
      expect(item.node_name).to eq("baz")
      expect(item.client_key_path).to eq("/foo/client.pem")
    end
  end

  describe "::load" do
    it "allows for both node name and client key overrides" do
      keys_db = Chef::DataBagItem.new
      keys_db.raw_data = {
        "id" => "bar_keys",
        "baz" => "...",
      }
      allow(ChefVault::ItemKeys)
        .to receive(:load)
        .and_return(keys_db)
      fh = double "private key handle"
      allow(fh).to receive(:read).and_return("...")
      allow(File).to receive(:open).and_return(fh)
      privkey = double "private key contents"
      allow(privkey).to receive(:private_decrypt).and_return("sekrit")
      allow(OpenSSL::PKey::RSA).to receive(:new).and_return(privkey)
      allow(Chef::EncryptedDataBagItem).to receive(:load).and_return(
        "id" => "bar",
        "password" => "12345"
      )
      item = ChefVault::Item.load(
        "foo", "bar",
        node_name: "baz",
        client_key_path: "/foo/client.pem"
      )
      expect(item.node_name).to eq("baz")
      expect(item.client_key_path).to eq("/foo/client.pem")
    end
  end

  describe "#save" do
    context 'when item["id"] is bar.bar' do
      let(:item) { ChefVault::Item.new("foo", "bar.bar") }
      it "raises an error on save with an invalid item['id']" do
        expect { item.save }.to raise_error

      end
    end

    it "validates that the id of the vault matches the id of the keys data bag" do
      item = ChefVault::Item.new("foo", "bar")
      item["id"] = "baz"
      item.keys["clients"] = %w{admin}
      expect { item.save }.to raise_error(ChefVault::Exceptions::IdMismatch)
    end
  end

  describe "#refresh" do

    it "saves only the keys" do
      keys = double("keys",
                    search_query: "*:*",
                    add: nil,
                    admins: [],
                    clients: ["testnode"])
      allow(keys).to receive(:[]).with("id").and_return("bar_keys")
      allow(ChefVault::ItemKeys).to receive(:new).and_return(keys)

      item = ChefVault::Item.new("foo", "bar")

      node  = double("node", name: "testnode")
      query = double("query")
      allow(Chef::Search::Query).to receive(:new).and_return(query)
      allow(query).to receive(:search).and_yield(node)

      client = double("client",
                     name: "testclient",
                     public_key: OpenSSL::PKey::RSA.new(1024).public_key)
      allow(ChefVault::ChefPatch::ApiClient).to receive(:load).and_return(client)

      expect(item).not_to receive(:save)
      expect(keys).to receive(:save)
      item.refresh
    end
  end

  describe "#clients" do
    include BorkedNodeWithoutPublicKey

    it "should not blow up when search returns a node without a public key" do
      # try to set clients when we know a node is missing a public key
      # this should not die as of v2.4.1
      expect { @vaultitem.clients("*:*") }.not_to raise_error
    end

    it "should emit a warning if search returns a node without a public key" do
      # it should however emit a warning that you have a borked node
      expect { @vaultitem.clients("*:*") }
        .to output(/node 'bar' has no private key; skipping/).to_stdout
    end

    it "should accept a client object and not perform a search" do
      client = Chef::ApiClient.new
      client.name "foo"
      privkey = OpenSSL::PKey::RSA.new(1024)
      pubkey = privkey.public_key
      client.public_key(pubkey.to_pem)
      expect(Chef::Search::Query).not_to receive(:new)
      expect(ChefVault::ChefPatch::User).not_to receive(:load)
      @vaultitem.clients(client)
      expect(@vaultitem.clients).to include("foo")
    end
  end

  describe "#admins" do
    include BorkedNodeWithoutPublicKey

    it "should blow up if you try to use a node without a public key as an admin" do
      expect { @vaultitem.admins("foo,bar") }
        .to raise_error(ChefVault::Exceptions::AdminNotFound)
    end
  end

  describe "#raw_keys" do
    it "should return the keys of the underlying data bag item" do
      item = ChefVault::Item.new("foo", "bar")
      item["foo"] = "bar"
      expect(item.raw_keys).to eq(%w{id foo})
    end
  end
end
