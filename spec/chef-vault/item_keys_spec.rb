RSpec.describe ChefVault::ItemKeys do
  describe "#new" do
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

    context "when running with chef-solo" do
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
        let(:data_bag_path) { Dir.mktmpdir("vault_item_keys") }
        before do
          Chef::Config[:solo] = true
          Chef::Config[:data_bag_path] = data_bag_path
        end

        it "should save the key data" do
          expect(File).to receive(:exist?).with(File.join(data_bag_path, "foo")).and_call_original
          keys.save("bar")
          expect(File.read(File.join(data_bag_path, "foo", "bar.json"))).to match(/"id":.*"bar"/)
        end
      end
    end
  end
end
