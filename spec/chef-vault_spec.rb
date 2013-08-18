require 'spec_helper'

describe ChefVault do

  describe '#new' do
    context 'with only a data bag parameter specified' do
      before(:each) do
        @vault = ChefVault.new('foo')
      end

      it 'is an instance of ChefVault' do
        expect(@vault).to be_an_instance_of ChefVault
      end
    end
  end

  describe '#version' do
    it 'returns the version number' do
      vault = ChefVault.new('foo')
      expect(vault.version).to eq ChefVault::VERSION
    end
  end
end
