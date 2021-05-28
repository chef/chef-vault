require "spec_helper"
require "chef/knife/mixin/helper"

RSpec.describe ChefVault::Mixin::Helper do
  include ChefVault::Mixin::Helper

  let(:json_data) { '{"username": "root", "password": "abcabc"}' }
  let(:json_data_whitespace) { '{"username": "root", "password": "abc\nabc\tabc"}' }
  let(:json_data_control_char) { '{"username": "root", "password": "abc\abc"}' }
  let(:buggy_json_data) { '{"username": "root", "password": "abc\abc"' }

  describe "#validate_json" do
    it "Raises InvalidValue Exception when invalid data provided" do
      expect { validate_json(buggy_json_data) }.to raise_error(ChefVault::Exceptions::InvalidValue)
    end

    it "Raises InvalidValue Exception when value consist of control characters" do
      expect { validate_json(json_data_control_char) }.to raise_error(ChefVault::Exceptions::InvalidValue)
    end

    it "Not to raise error if valid data provided" do
      expect { validate_json(json_data) }.to_not raise_error
    end

    it "Not to raise error if valid data with whitespace provided" do
      expect { validate_json(json_data_whitespace) }.to_not raise_error
    end
  end
end
