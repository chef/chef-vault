require "spec_helper"
require "chef/knife/mixin/helper"

RSpec.describe ChefVault::Mixin::Helper do
  include ChefVault::Mixin::Helper

  before do
    allow(ChefVault::Log).to receive(:warn)
  end

  let(:json_base) { { "username": "root" } }
  let(:valid_json) { '{"username": "root", "password": "abcabc"}' }
  let(:malformed_json) { '{"username": ' }
  let(:valid_json_with_special_character) { { "Data": "Null->\u0000<-Byte" } }

  describe "#values_from_json" do
    it "should raise error when invalid JSON provided" do
      expect { values_from_json(malformed_json) }.to raise_error(JSON::ParserError)
    end

    it "should not raise error when valid JSON provided" do
      expect { values_from_json(valid_json) }.to_not raise_error
    end

    it "should not raise error if JSON contains tab, newline, or space characters" do
      ["abc\tabc", "abc\nabc", "abc abc"].each do |pass|
        json_data_with_slash = json_base.merge("password": pass)
        expect { values_from_json(json_data_with_slash.to_json) }.to_not raise_error
      end
    end

    it "should not warn or error when JSON contains special character sequences" do
      expect(ChefVault::Log).to_not receive(:warn)
      expect { values_from_json(valid_json_with_special_character.to_json) }.to_not raise_error
    end
  end
end