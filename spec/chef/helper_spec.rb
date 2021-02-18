require "spec_helper"
require "chef/knife/mixin/helper"

RSpec.describe ChefVault::Mixin::Helper do
  include ChefVault::Mixin::Helper

  let(:json_data) { '{"username": "root", "password": "abcabc"}' }
  let(:buggy_json_data) { '{"username": "root", "password": "abc\abc"' }

  describe "#validate_json" do
    it "Raises InvalidValue Exception when invalid data provided" do
      expect { validate_json(buggy_json_data) }.to raise_error(ChefVault::Exceptions::InvalidValue)
    end

    it "Not to raise error if valid data provided" do
      expect { validate_json(json_data) }.to_not raise_error
    end
  end
end