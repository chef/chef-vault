require "openssl"

RSpec.describe ChefVault::Item do
  subject(:item) { ChefVault::Item.new("foo", "bar") }

  before do
    item["foo"] = "bar"
    http_response = double("http_response")
    allow(http_response).to receive(:code).and_return("404")
    non_existing = Net::HTTPServerException.new("http error message", http_response)

    allow(Chef::DataBagItem).to receive(:load).with(anything, /_key_/).and_raise(non_existing)
  end

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
        expect { item.save }.to raise_error(RuntimeError)
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
    let(:node) { { "name" => "testnode" } }

    it "saves only the keys" do
      keys = double("keys",
                    search_query: "*:*",
                    add: nil,
                    admins: [],
                    clients: ["testnode"])
      allow(keys).to receive(:[]).with("id").and_return("bar_keys")
      allow(ChefVault::ItemKeys).to receive(:new).and_return(keys)

      item = ChefVault::Item.new("foo", "bar")

      query = double("query")
      allow(Chef::Search::Query).to receive(:new).and_return(query)
      allow(query).to receive(:search).and_yield(node)

      client_key = double("client_key",
                          name: "testnode",
                          public_key: OpenSSL::PKey::RSA.new(1024).public_key)
      allow(item).to receive(:load_actor).with("testnode", "clients").and_return(client_key)

      expect(item).not_to receive(:save)
      expect(keys).to receive(:save)
      item.refresh
    end
  end

  describe "#clients" do
    context "when search returns a node with a valid client backing it and one without a valid client" do
      let(:node_with_valid_client) { { "name" => "foo" } }
      let(:node_without_valid_client) { { "name" => "bar" } }
      let(:query_result) { double("chef search results") }
      let(:client_key) { double("chef key") }

      before do
        # node with valid client proper loads client key
        allow(item).to receive(:load_actor).with("foo", "clients").and_return(client_key)
        privkey = OpenSSL::PKey::RSA.new(1024)
        pubkey = privkey.public_key
        allow(client_key).to receive(:key).and_return(pubkey.to_pem)
        allow(client_key).to receive(:name).and_return("foo")
        allow(client_key).to receive(:type).and_return("clients")

        # node without client throws relevant error on key load
        allow(item).to receive(:load_actor).with("bar", "clients").and_raise(ChefVault::Exceptions::ClientNotFound)

        allow(query_result)
          .to receive(:search)
          .with(Symbol, String, Hash)
          .and_yield(node_with_valid_client).and_yield(node_without_valid_client)
        allow(Chef::Search::Query)
          .to receive(:new)
          .and_return(query_result)
      end

      it "should not blow up when search returns a node without a public key" do
        # try to set clients when we know a node is missing a public key
        # this should not die as of v2.4.1
        expect { item.clients("*:*") }.not_to raise_error
      end

      it "should emit a warning if search returns a node without a public key" do
        # it should however emit a warning that you have a borked node
        expect(ChefVault::Log).to receive(:warn).with(/node 'bar' has no private key; skipping/)
        item.clients("*:*")
      end
    end

    context "when a Chef::ApiClient is passed" do
      let(:client) { Chef::ApiClient.new }
      let(:client_name) { "foo" }
      let(:client_key) { double("chef key") }

      before do
        client.name client_name
        privkey = OpenSSL::PKey::RSA.new(1024)
        pubkey = privkey.public_key
        allow(item).to receive(:load_actor).with(client_name, "clients").and_return(client_key)
        allow(client_key).to receive(:key).and_return(pubkey.to_pem)
        allow(client_key).to receive(:name).and_return(client_name)
        allow(client_key).to receive(:type).and_return("clients")
      end

      context "when no action is passed" do
        it "default to add and properly add the client" do
          item.clients(client)
          expect(item.get_clients).to include(client_name)
        end

        it "does not perform a query" do
          expect(Chef::Search::Query).not_to receive(:new)
          item.clients(client)
        end
      end

      context "when the delete action is passed on an existing client" do
        before do
          # add the client
          item.clients(client)
        end

        it "properly deletes the client" do
          item.clients(client, :delete)
          expect(item.get_clients).to_not include(client_name)
        end

        it "does not perform a query" do
          expect(Chef::Search::Query).not_to receive(:new)
          item.clients(client, :delete)
        end
      end
    end

    context "when an Array with named clients is passed" do
      let(:client) { Chef::ApiClient.new }
      let(:clients) { Array.new }
      let(:client_name) { "foo" }
      let(:client_key) { double("chef key") }

      before do
        clients << client_name
        client.name client_name
        privkey = OpenSSL::PKey::RSA.new(1024)
        pubkey = privkey.public_key
        allow(item).to receive(:load_actor).with(client_name, "clients").and_return(client_key)
        allow(client_key).to receive(:key).and_return(pubkey.to_pem)
        allow(client_key).to receive(:name).and_return(client_name)
        allow(client_key).to receive(:type).and_return("clients")
      end

      context "when no action is passed" do
        it "defaults to add and properly adds the client" do
          item.clients(clients)
          expect(item.get_clients).to include(client_name)
        end

        it "does not perform a query" do
          expect(Chef::Search::Query).not_to receive(:new)
          item.clients(clients)
        end
      end

      context "when the delete action is passed on an existing client" do
        before do
          # add the client
          item.clients(clients)
        end

        it "properly deletes the client" do
          item.clients(clients, :delete)
          expect(item.get_clients).to_not include(client_name)
        end

        it "does not perform a query" do
          expect(Chef::Search::Query).not_to receive(:new)
          item.clients(clients, :delete)
        end
      end
    end
  end

  describe "#admins" do
    before do
      allow(item).to receive(:load_actor).with("foo", "admins").and_raise(ChefVault::Exceptions::AdminNotFound)
    end

    it "should blow up if you try to use a node without a public key as an admin" do
      expect { item.admins("foo,bar") }
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
