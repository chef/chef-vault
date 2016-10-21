require "spec_helper"

RSpec.describe ChefVault::Actor do
  let(:actor_name) { "actor" }
  let(:public_key_string) do
    "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyMXT9IOV9pkQsxsnhSx8\n8RX6GW3caxkjcXFfHg6E7zUVBFAsfw4B1D+eHAks3qrDB7UrUxsmCBXwU4dQHaQy\ngAn5Sv0Jc4CejDNL2EeCBLZ4TF05odHmuzyDdPkSZP6utpR7+uF7SgVQedFGySIB\nih86aM+HynhkJqgJYhoxkrdo/JcWjpk7YEmWb6p4esnvPWOpbcjIoFs4OjavWBOF\niTfpkS0SkygpLi/iQu9RQfd4hDMWCc6yh3Th/1nVMUd+xQCdUK5wxluAWSv8U0zu\nhiIlZNazpCGHp+3QdP3f6rebmQA8pRM8qT5SlOvCYPk79j+IMUVSYrR4/DTZ+VM+\naQIDAQAB\n-----END PUBLIC KEY-----\n"
  end

  let(:key_response) do
    {
      "name" => "default",
      "public_key" => "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyMXT9IOV9pkQsxsnhSx8\n8RX6GW3caxkjcXFfHg6E7zUVBFAsfw4B1D+eHAks3qrDB7UrUxsmCBXwU4dQHaQy\ngAn5Sv0Jc4CejDNL2EeCBLZ4TF05odHmuzyDdPkSZP6utpR7+uF7SgVQedFGySIB\nih86aM+HynhkJqgJYhoxkrdo/JcWjpk7YEmWb6p4esnvPWOpbcjIoFs4OjavWBOF\niTfpkS0SkygpLi/iQu9RQfd4hDMWCc6yh3Th/1nVMUd+xQCdUK5wxluAWSv8U0zu\nhiIlZNazpCGHp+3QdP3f6rebmQA8pRM8qT5SlOvCYPk79j+IMUVSYrR4/DTZ+VM+\naQIDAQAB\n-----END PUBLIC KEY-----\n",
      "expiration_date" => "infinity",
    }
  end

  let(:http_response_code) do
    "404"
  end

  let(:http_error) do
    http_response = double("http error")
    allow(http_response).to receive(:code).and_return(http_response_code)
    Net::HTTPServerException.new("http error message", http_response)
  end

  let(:api) { double("api") }

  subject(:chef_key) { described_class.new(actor_type, actor_name) }

  describe "#new" do
    context "when something besides 'clients' or 'users' is passed" do
      let(:actor_type) { "charmander" }
      it "throws an error" do
        expect { described_class.new("charmander", actor_name) }.to raise_error(RuntimeError)
      end
    end

    context "when 'clients' is passed" do
      it "requests a client key" do
        expect_any_instance_of(described_class).to receive(:get_client_key)
        described_class.new("clients", actor_name).key
      end
    end

    context "when 'admins' is passed" do
      it "requests a admin key" do
        expect_any_instance_of(described_class).to receive(:get_admin_key)
        described_class.new("admins", actor_name).key
      end
    end
  end

  shared_examples_for "get_key_handling" do
    context "when the default key exists for the requested client" do
      it "sets up a valid key" do
        expect(chef_key).to receive(:get_key).with(request_actor_type).and_return(public_key_string)
        expect(chef_key.send(method)).to eq(public_key_string)
      end
    end

    context "when get_key returns an http error" do
      before do
        allow(chef_key).to receive(:get_key).with(request_actor_type).and_raise(http_error)
      end

      context "when the error code is not 404 or 403" do
        let(:http_response_code) { "500" }

        it "raises the original error" do
          expect { chef_key.send(method) }.to raise_error(http_error)
        end
      end

      context "when the error code is 403" do
        let(:http_response_code) { "403" }

        it "prints information for the user to resolve the issue and raises the original error" do
          expect(chef_key).to receive(:print_forbidden_error)
          expect { chef_key.send(method) }.to raise_error(http_error)
        end
      end
    end
  end

  describe "#get_client_key" do
    let(:request_actor_type) { "clients" }
    let(:actor_type) { "clients" }
    let(:method) { :get_client_key }

    it_should_behave_like "get_key_handling"

    context "when get_key returns an http error" do
      before do
        allow(chef_key).to receive(:get_key).with(actor_type).and_raise(http_error)
      end

      context "when the error code is 404" do
        let(:http_response_code) { "404" }

        it "raises ChefVault::Exceptions::ClientNotFound" do
          expect { chef_key.get_client_key }.to raise_error(ChefVault::Exceptions::ClientNotFound)
        end
      end
    end
  end # get_client_key

  describe "#get_admin_key" do
    let(:request_actor_type) { "users" }
    let(:actor_type) { "admins" }
    let(:method) { :get_admin_key }

    it_should_behave_like "get_key_handling"

    context "when the first get_key for users returns an http error" do
      before do
        allow(chef_key).to receive(:get_key).with(request_actor_type).and_raise(http_error)
      end

      context "when the error code from the users get is a 404" do
        let(:http_response_code) { "404" }

        context "when the second get_key for clients returns an http error" do

          let(:http_error_2) do
            http_response = double("http error")
            allow(http_response).to receive(:code).and_return(http_response_code_2)
            Net::HTTPServerException.new("http error message", http_response)
          end

          before do
            allow(chef_key).to receive(:get_key).with("clients").and_raise(http_error_2)
          end

          context "when it is a 404" do
            let(:http_response_code_2) { "404" }

            it "rasies ChefVault::Exceptions::AdminNotFound" do
              expect { chef_key.get_admin_key }.to raise_error(ChefVault::Exceptions::AdminNotFound)
            end
          end

          context "when it is a 403" do
            let(:http_response_code_2) { "403" }

            it "raises the original error" do
              expect { chef_key.get_admin_key }.to raise_error(http_error_2)
            end
          end

          context "when it is not a 404" do
            let(:http_response_code_2) { "500" }

            it "raises the original error" do
              expect { chef_key.get_admin_key }.to raise_error(http_error_2)
            end
          end
        end # when the second get_key for clients returns an http error

        context "when the second get_key for clients exists with the same name as the admin requested" do
          it "strangely returns the client key as an admin key" do
            expect(chef_key).to receive(:get_key).with(request_actor_type).and_return(public_key_string)
            expect(chef_key.send(method)).to eq(public_key_string)
          end
        end
      end # when the first get_key for users returns an http erro
    end
  end # get_admin_key

  describe "#get_key" do

    shared_examples_for "a properly retrieved and error handled key fetch" do
      # mock out the API
      before do
        allow(chef_key).to receive(:api).and_return(api)
        [:rest_v0, :rest_v1, :org_scoped_rest_v0, :org_scoped_rest_v1].each do |method|
          allow(api).to receive(method)
        end
      end

      context "when keys/default returns 200 for org scoped endpoint" do
        before do
          allow(api.org_scoped_rest_v1).to receive(:get).with("#{request_actor_type}/#{actor_name}/keys/default").and_return(key_response)
        end

        it "returns the public_key" do
          expect(chef_key.get_key(request_actor_type)).to eql(public_key_string)
        end

        it "hits the proper endpoint" do
          expect(api.org_scoped_rest_v1).to receive(:get).with("#{request_actor_type}/#{actor_name}/keys/default")
          chef_key.get_key(request_actor_type)
        end
      end

      context "when a 500 is returned" do
        let(:http_response_code) { "500" }
        before do
          allow(api.org_scoped_rest_v1).to receive(:get).with("#{request_actor_type}/#{actor_name}/keys/default").and_raise(http_error)
        end

        it "raises the http error" do
          expect { chef_key.get_key(request_actor_type) }.to raise_error(http_error)
        end
      end

      context "when keys/default returns 404" do
        let(:http_response_code) { "404" }
        let(:chef_object) { double("chef object") }

        before do
          allow(api.org_scoped_rest_v1).to receive(:get).with("#{request_actor_type}/#{actor_name}/keys/default").and_raise(http_error)
          allow(chef_object_type).to receive(:load).with(actor_name).and_return(chef_object)
          allow(chef_object).to receive(:public_key).and_return(public_key_string)
        end

        it "tries to load the object via Chef::<object>_v1" do
          expect(chef_object_type).to receive(:load).with(actor_name)
          chef_key.get_key(request_actor_type)
        end

        context "when the Chef::<object>_v1 object loads properly" do
          it "returns the public key" do
            expect(chef_key.get_key(request_actor_type)).to eql(public_key_string)
          end
        end
      end
    end # shared_examples_for

    context "when a client is passed" do
      let(:request_actor_type) { "clients" }
      let(:actor_type) { "clients" }
      let(:chef_object_type) { Chef::ApiClient }

      it_behaves_like "a properly retrieved and error handled key fetch"
    end

    context "when an admin is passed" do
      let(:request_actor_type) { "users" }
      let(:actor_type) { "admins" }
      let(:chef_object_type) { Chef::User }

      it_behaves_like "a properly retrieved and error handled key fetch"
    end

  end
end
