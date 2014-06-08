require 'spec_helper'

describe ChefVault do
  subject(:vault) { ChefVault.new }

  describe '#new' do
    it { is_expected.to be_instance_of(ChefVault) }
  end

  describe '#version' do
    subject { ChefVault.version }
    it { is_expected.to eq(ChefVault::VERSION) }
  end
end
