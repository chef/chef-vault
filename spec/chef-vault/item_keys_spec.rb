RSpec.describe ChefVault::ItemKeys do
  describe "#new" do
    let(:keys) { ChefVault::ItemKeys.new("foo", "bar") }
    let(:shared_secret) { "super_secret" }
    let(:public_key_string) do
      "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyMXT9IOV9pkQsxsnhSx8\n8RX6GW3caxkjcXFfHg6E7zUVBFAsfw4B1D+eHAks3qrDB7UrUxsmCBXwU4dQHaQy\ngAn5Sv0Jc4CejDNL2EeCBLZ4TF05odHmuzyDdPkSZP6utpR7+uF7SgVQedFGySIB\nih86aM+HynhkJqgJYhoxkrdo/JcWjpk7YEmWb6p4esnvPWOpbcjIoFs4OjavWBOF\niTfpkS0SkygpLi/iQu9RQfd4hDMWCc6yh3Th/1nVMUd+xQCdUK5wxluAWSv8U0zu\nhiIlZNazpCGHp+3QdP3f6rebmQA8pRM8qT5SlOvCYPk79j+IMUVSYrR4/DTZ+VM+\naQIDAQAB\n-----END PUBLIC KEY-----\n"
    end

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

    shared_context "key mgmt operations" do

      shared_examples_for "proper key management" do
        let(:chef_key) { ChefVault::Actor.new(type, name) }
        before do
          allow(chef_key).to receive(:key) { public_key_string }
          keys.add(chef_key, shared_secret)
        end

        describe "#add" do
          after do
            keys.delete(chef_key)
          end

          context "when key is already there" do
            context "when skip_reencryption is not specified (default to false)" do
              it "encodes key in the data bag item under the actor's name and the name in the raw data" do
                expect(described_class).to receive(:encode_key).with(public_key_string, shared_secret).and_return("encrypted_result")
                keys.add(chef_key, shared_secret)
                expect(keys[name]).to eq("encrypted_result")
                expect(keys[type].include?(name)).to eq(true)
                expect(keys.include?(name)).to eq(true)
              end
            end

            context "when skip_reencryption is true" do
              it "keeps the encoded key in the data bag item under the actor's name and the name in the raw data" do
                expect(described_class).not_to receive(:encode_key).with(public_key_string, shared_secret)
                keys.skip_reencryption = true
                keys.add(chef_key, shared_secret)
                expect(keys[name]).not_to be_empty
                expect(keys[type].include?(name)).to eq(true)
                expect(keys.include?(name)).to eq(true)
              end
            end
          end

          context "when keys not already there" do
            before do
              keys.delete(chef_key)
            end
            it "stores the encoded key in the data bag item under the actor's name and the name in the raw data" do
              expect(described_class).to receive(:encode_key).with(public_key_string, shared_secret).and_return("encrypted_result")
              keys.add(chef_key, shared_secret)
              expect(keys[name]).to eq("encrypted_result")
              expect(keys[type].include?(name)).to eq(true)
              expect(keys.include?(name)).to eq(true)
            end
          end
        end

        describe "#delete" do
          before do
            keys.add(chef_key, shared_secret)
          end

          it "removes the actor's name from the data bag and from the array for the actor's type" do
            keys.delete(chef_key)
            expect(keys.has_key?(chef_key.name)).to eq(false)
            expect(keys[type].include?(name)).to eq(false)
            expect(keys.include?(name)).to eq(false)
          end
        end
      end

      context "when a client is added" do
        let(:name) { "client_name" }
        let(:type) { "clients" }
        it_should_behave_like "proper key management"
      end

      context "when a admin is added" do
        let(:name) { "admin_name" }
        let(:type) { "admins" }
        it_should_behave_like "proper key management"
      end
    end

    context "when running with chef-zero" do
      let(:server) { chef_zero }
      before { server.start_background }
      after  { server.stop }

      include_context "key mgmt operations"

      describe "#save" do
        let(:client_name) { "client_name" }
        let(:chef_key) { ChefVault::Actor.new("clients", client_name) }
        before { allow(chef_key).to receive(:key) { public_key_string } }

        it "should save the key data" do
          keys.add(chef_key, shared_secret)
          keys.save("bar")
          expect(Chef::DataBagItem.load("foo", "bar").to_hash).to include("id" => "bar")
          expect(keys[client_name]).not_to be_empty
          keys.delete(chef_key)
          keys.save("bar")
          expect(keys[client_name]).to be_nil
        end

        it "should save the key data in sparse mode" do
          keys.add(chef_key, shared_secret)
          keys.mode("sparse")
          keys.save("bar")
          expect(Chef::DataBagItem.load("foo", "bar").to_hash).to include("id" => "bar")
          expect(Chef::DataBagItem.load("foo", "bar_key_client_name").to_hash).to include("id" => "bar_key_client_name")
          expect(keys[client_name]).not_to be_empty
          keys.delete(chef_key)
          keys.save("bar")
          expect(keys[client_name]).to be_nil
          keys.mode("default")
        end
      end

      describe "#destroy" do
        let(:client_name) { "client_name" }
        let(:chef_key) { ChefVault::Actor.new("clients", client_name) }
        before { allow(chef_key).to receive(:key) { public_key_string } }

        it "should destroy the keys" do
          keys.add(chef_key, shared_secret)
          keys.save("bar")
          keys.destroy
          expect { Chef::DataBagItem.load("foo", "bar") }.to raise_error(Net::HTTPServerException)
        end

        it "should destroy the keys in sparse mode" do
          keys.add(chef_key, shared_secret)
          keys.mode("sparse")
          keys.save("bar")
          keys.destroy
          expect { Chef::DataBagItem.load("foo", "bar") }.to raise_error(Net::HTTPServerException)
          expect { Chef::DataBagItem.load("foo", "bar_key_client_name") }.to raise_error(Net::HTTPServerException)
          keys.mode("default")
        end
      end
    end

    context "when running with chef-solo" do
      before { Chef::Config[:solo_legacy_mode] = true  }
      after  { Chef::Config[:solo_legacy_mode] = false }

      include_context "key mgmt operations"

      describe "#find_solo_path" do
        context "when data_bag_path is an array" do
          before do
            allow(File).to receive(:exist?)
            Chef::Config[:data_bag_path] = ["/tmp/data_bag", "/tmp/site_data_bag"]
          end

          it "should return an existing item" do
            expect(File).to receive(:exist?).with("/tmp/site_data_bag/foo/bar.json").and_return(true)
            dbp, dbi = keys.find_solo_path("bar")
            expect(dbp).to eql("/tmp/site_data_bag/foo")
            expect(dbi).to eql("/tmp/site_data_bag/foo/bar.json")
          end

          it "should return the first item if none exist" do
            dbp, dbi = keys.find_solo_path("bar")
            expect(dbp).to eql("/tmp/data_bag/foo")
            expect(dbi).to eql("/tmp/data_bag/foo/bar.json")
          end
        end

        context "when data_bag_path is a string" do
          it "should return the path to the bag and the item" do
            Chef::Config[:data_bag_path] = "/tmp/data_bag"
            dbp, dbi = keys.find_solo_path("bar")
            expect(dbp).to eql("/tmp/data_bag/foo")
            expect(dbi).to eql("/tmp/data_bag/foo/bar.json")
          end
        end
      end

      describe "#save" do
        let(:client_name)   { "client_name" }
        let(:chef_key)      { ChefVault::Actor.new("clients", client_name) }
        let(:data_bag_path) { Dir.mktmpdir("vault_item_keys") }

        before do
          Chef::Config[:data_bag_path] = data_bag_path
          allow(chef_key).to receive(:key) { public_key_string }
        end

        it "should save the key data" do
          keys.add(chef_key, shared_secret)
          keys.save("bar")
          expect(File.read(File.join(data_bag_path, "foo", "bar.json"))).to match(/"id":.*"bar"/)
          expect(keys[client_name]).not_to be_empty
          keys.delete(chef_key)
          keys.save("bar")
          expect(keys[client_name]).to be_nil
        end

        it "should save the key data in sparse mode" do
          keys.add(chef_key, shared_secret)
          keys.mode("sparse")
          keys.save("bar")
          expect(File.read(File.join(data_bag_path, "foo", "bar.json"))).to match(/"id":.*"bar"/)
          expect(File.read(File.join(data_bag_path, "foo", "bar_key_client_name.json"))).to match(/"id":.*"bar_key_client_name"/)
          expect(keys[client_name]).not_to be_empty
          keys.delete(chef_key)
          keys.save("bar")
          expect(keys[client_name]).to be_nil
          keys.mode("default")
        end
      end

      describe "#destroy" do
        let(:client_name) { "client_name" }
        let(:chef_key) { ChefVault::Actor.new("clients", client_name) }
        let(:data_bag_path) { Dir.mktmpdir("vault_item_keys") }

        before do
          Chef::Config[:data_bag_path] = data_bag_path
          allow(chef_key).to receive(:key) { public_key_string }
        end

        it "should destroy the keys" do
          keys.add(chef_key, shared_secret)
          keys.save("bar")
          keys.destroy
          expect(File.exist?(File.join(data_bag_path, "foo", "bar.json"))).to be(false)
        end

        it "should destroy the keys in sparse mode" do
          keys.add(chef_key, shared_secret)
          keys.mode("sparse")
          keys.save("bar")
          keys.destroy
          expect(File.exist?(File.join(data_bag_path, "foo", "bar.json"))).to be(false)
          expect(File.exist?(File.join(data_bag_path, "foo", "bar_key_client_name.json"))).to be(false)
          keys.mode("default")
        end
      end
    end
  end
end
