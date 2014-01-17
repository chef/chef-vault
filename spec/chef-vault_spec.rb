require 'spec_helper'

describe ChefVault do
  subject(:vault) { ChefVault.new('foo') }

  describe '#new' do
    context 'with only a vault parameter specified' do
      it { should be_an_instance_of ChefVault }

      its(:vault) { should eq "foo" }
    end

    context 'with a vault and config file parameter specified' do
      before do
        IO.stub(:read).with('knife.rb').and_return("node_name 'bar'")
      end

      let(:vault) { ChefVault.new('foo', 'knife.rb') }

      it { should be_an_instance_of ChefVault }

      its(:vault) { should eq "foo" }

      specify { expect { Chef::Config[:node_name ].should eq "bar" } }
    end

    describe '#version' do
      its(:version) { should eq ChefVault::VERSION }
    end
  end
end
