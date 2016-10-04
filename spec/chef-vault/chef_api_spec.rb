RSpec.describe ChefVault::ChefApi do
  let(:root_url) { "https://localhost" }
  let(:scoped_url) { "https://localhost/organizations/fakeorg" }
  let(:api_v0_hash) { { :api_version => "0" } }
  let(:api_v1_hash) { { :api_version => "1" } }

  before do
    Chef::Config[:chef_server_root] = root_url
    Chef::Config[:chef_server_url]  = scoped_url
  end

  describe "#rest_v0" do
    it "returns an instance of Chef::ServerAPI set to use API version 0 scoped to root" do
      expect(Chef::ServerAPI).to receive(:new).with(root_url, api_v0_hash)
      subject.rest_v0
    end
  end

  describe "#rest_v1" do
    it "returns an instance of Chef::ServerAPI set to use API version 0 scoped to root" do
      expect(Chef::ServerAPI).to receive(:new).with(root_url, api_v1_hash)
      subject.rest_v1
    end
  end

  describe "#org_scoped_rest_v0" do
    it "returns an instance of Chef::ServerAPI set to use API version 0 scoped to root" do
      expect(Chef::ServerAPI).to receive(:new).with(scoped_url, api_v0_hash)
      subject.org_scoped_rest_v0
    end
  end

  describe "#org_scoped_rest_v1" do
    it "returns an instance of Chef::ServerAPI set to use API version 0 scoped to root" do
      expect(Chef::ServerAPI).to receive(:new).with(scoped_url, api_v1_hash)
      subject.org_scoped_rest_v1
    end
  end
end
