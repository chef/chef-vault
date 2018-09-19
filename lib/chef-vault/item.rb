# Author:: Kevin Moser <kevin.moser@nordstrom.com>
# Copyright:: Copyright 2013-15, Nordstrom, Inc.
# Copyright:: Copyright 2015-16, Chef Software, Inc.
# License:: Apache License, Version 2.0

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "securerandom"
require "chef-vault/mixins"

class ChefVault
  class Item < Chef::DataBagItem
    include ChefVault::Mixins

    # @!attribute [rw] keys
    #   @return [ChefVault::ItemKeys] the keys associated with this vault
    attr_accessor :keys

    # @!attribute [rw] encrypted_data_bag_item
    #   @return [nil] this attribute is not currently used
    attr_accessor :encrypted_data_bag_item

    # @!attribute [rw] node_name
    #   @return [String] the node name that is used to decrypt secrets.
    #     Defaults to the value of Chef::Config[:node_name]
    attr_accessor :node_name

    # @!attribute [rw] client_key_path
    #   @return [String] the path to the private key that is used to
    #     decrypt secrets.  Defaults to the value of Chef::Config[:client_key]
    attr_accessor :client_key_path

    # returns the raw keys of the underlying Chef::DataBagItem.  chef-vault v2
    # defined #keys as a public accessor that returns the ChefVault::ItemKeys
    # object for the vault.  Ideally, #keys would provide Hash-like behaviour
    # as it does for Chef::DataBagItem, but this would break the API.  We will
    # revisit this as part of the 3.x rewrite
    def_delegator :@raw_data, :keys, :raw_keys

    # allow to control whether keys are reencrypted or cached
    def_delegator :keys, :skip_reencryption=

    # constructs a new ChefVault::Item
    # @param vault [String] the name of the data bag that contains the vault
    # @param name [String] the name of the item in the vault
    # @param opts [Hash]
    # @option opts [String] :node_name  the name of the node to decrypt secrets
    #   as. Defaults to the :node_name value of Chef::Config
    # @option opts [String] :client_key_path the name of the node to decrypt
    #   secrets as.  Defaults to the :client_key value of Chef::Config
    def initialize(vault, name, opts = {})
      super() # Don't pass parameters
      @data_bag = vault
      @raw_data["id"] = name
      @keys = ChefVault::ItemKeys.new(vault, "#{name}_keys")
      @secret = generate_secret
      @encrypted = false
      opts = {
        node_name: Chef::Config[:node_name],
        client_key_path: Chef::Config[:client_key],
      }.merge(opts)
      @node_name = opts[:node_name]
      @client_key_path = opts[:client_key_path]
      @current_query = search
    end

    # private
    def load_keys(vault, keys)
      @keys = ChefVault::ItemKeys.load(vault, keys)
      @secret = secret
    end

    def clients(search_or_client = search_results, action = :add)
      # for backwards compatibility, if we're handed a string
      # do a search using that string and recurse
      if search_or_client.is_a?(String)
        clients(search_results(search_or_client), action)
      elsif search_or_client.is_a?(Chef::ApiClient)
        handle_client_action(search_or_client, action)
      else
        search_or_client.each do |name|
          begin
            client = load_actor(name, "clients")
            handle_client_action(client, action)
          rescue ChefVault::Exceptions::ClientNotFound
            ChefVault::Log.warn "node '#{name}' has no 'default' public key; skipping"
          end
        end
      end
    end

    def search_results(statement = search)
      @search_results = nil if statement != @current_query
      @current_query = statement
      @search_results ||= begin
        results_returned = false
        results = []
        query = Chef::Search::Query.new
        query.search(:node, statement, filter_result: { name: ["name"] }, rows: 10000) do |node|
          results_returned = true
          results << node["name"]
        end

        unless results_returned
          ChefVault::Log.warn "No clients were returned from search, you may not have "\
            "got what you expected!!"
        end
        results
      end
    end

    def get_clients
      keys.clients
    end

    def search(search_query = nil)
      if search_query
        keys.search_query(search_query)
      else
        keys.search_query
      end
    end

    def admins(admin_string, action = :add)
      admin_string.split(",").each do |admin|
        admin.strip!
        admin_key = load_actor(admin, "admins")
        case action
        when :add
          keys.add(admin_key, @secret)
        when :delete
          keys.delete(admin_key)
        else
          raise ChefVault::Exceptions::KeysActionNotValid,
                "#{action} is not a valid action"
        end
      end
    end

    def get_admins
      keys.admins
    end

    def remove(key)
      @raw_data.delete(key)
    end

    def secret
      if @keys.include?(@node_name) && !@keys[@node_name].nil?
        private_key = OpenSSL::PKey::RSA.new(File.open(@client_key_path).read())
        begin
          private_key.private_decrypt(Base64.decode64(@keys[@node_name]))
        rescue OpenSSL::PKey::RSAError
          raise ChefVault::Exceptions::SecretDecryption,
            "#{data_bag}/#{id} is encrypted for you, but your private key failed to decrypt the contents.  "\
            "(if you regenerated your client key, have an administrator of the vault run 'knife vault refresh')"
        end
      else
        raise ChefVault::Exceptions::SecretDecryption,
          "#{data_bag}/#{id} is not encrypted with your public key.  "\
          "Contact an administrator of the vault item to encrypt for you!"
      end
    end

    def rotate_keys!(clean_unknown_clients = false)
      @secret = generate_secret

      # clean existing encrypted data for clients/admins
      keys.clear_encrypted

      unless get_clients.empty?
        # a bit of a misnomer; this doesn't remove unknown
        # admins, just clients which are nodes
        remove_unknown_nodes if clean_unknown_clients
        # re-encrypt the new shared secret for all remaining clients
        clients(get_clients)
      end

      unless get_admins.empty?
        # re-encrypt the new shared secret for all admins
        get_admins.each do |admin|
          admins(admin)
        end
      end

      save
      reload_raw_data
    end

    # private
    def generate_secret(key_size = 32)
      # Defaults to 32 bytes, as this is the size that a Chef
      # Encrypted Data Bag Item will digest all secrets down to anyway
      SecureRandom.random_bytes(key_size)
    end

    def []=(key, value)
      reload_raw_data if @encrypted
      super
    end

    def [](key)
      reload_raw_data if @encrypted
      super
    end

    def save(item_id = @raw_data["id"])
      save_keys(item_id)
      # Make sure the item is encrypted before saving
      encrypt! unless @encrypted

      # Now save the encrypted data
      if Chef::Config[:solo_legacy_mode]
        save_solo(item_id)
      else
        begin
          Chef::DataBag.load(data_bag)
        rescue Net::HTTPServerException => http_error
          if http_error.response.code == "404"
            chef_data_bag = Chef::DataBag.new
            chef_data_bag.name data_bag
            chef_data_bag.create
          end
        end

        super
      end
    end

    def save_keys(item_id = @raw_data["id"])
      # validate the format of the id before attempting to save
      validate_id!(item_id)

      # ensure that the ID of the vault hasn't changed since the keys
      # data bag item was created
      keys_id = keys["id"].match(/^(.+)_keys/)[1]
      if keys_id != item_id
        raise ChefVault::Exceptions::IdMismatch,
          "id mismatch - input JSON has id '#{item_id}' but vault item has id '#{keys_id}'"
      end

      # save the keys first, raising an error if no keys were defined
      if keys.admins.empty? && keys.clients.empty?
        raise ChefVault::Exceptions::NoKeysDefined,
          "No keys defined for #{item_id}"
      end

      keys.save
    end

    def to_json(*a)
      json = super
      json.gsub(self.class.name, self.class.superclass.name)
    end

    def destroy
      keys.destroy

      if Chef::Config[:solo_legacy_mode]
        data_bag_path = File.join(Chef::Config[:data_bag_path],
                                  data_bag)
        data_bag_item_path = File.join(data_bag_path, @raw_data["id"])

        FileUtils.rm("#{data_bag_item_path}.json")

        nil
      else
        super(data_bag, id)
      end
    end

    # loads an existing vault item
    # @param (see #initialize)
    # @option (see #initialize)
    def self.load(vault, name, opts = {})
      item = new(vault, name, opts)
      item.load_keys(vault, "#{name}_keys")

      begin
        item.raw_data =
          Chef::EncryptedDataBagItem.load(vault, name, item.secret).to_hash
      rescue Net::HTTPServerException => http_error
        if http_error.response.code == "404"
          raise ChefVault::Exceptions::ItemNotFound,
            "#{vault}/#{name} could not be found"
        else
          raise http_error
        end
      rescue Chef::Exceptions::ValidationFailed
        raise ChefVault::Exceptions::ItemNotFound,
          "#{vault}/#{name} could not be found"
      end

      item
    end

    def delete_client(client_name)
      client_key = load_actor(client_name, "clients")
      keys.delete(client_key)
    end

    # determines if a data bag item looks like a vault
    # @param vault [String] the name of the data bag
    # @param name [String] the name of the item in the data bag
    # @return [Boolean] true if the data bag item looks like a vault
    def self.vault?(vault, name)
      :vault == data_bag_item_type(vault, name)
    end

    # determines whether a data bag item is a vault, an encrypted
    # data bag item, or a normal data bag item. An item is a vault
    # if:
    #
    # a) the data bag item contains at least one key whose value is
    #   an hash with the key 'encrypted data'
    # b) the data bag that contains the item contains a second item
    #   suffixed with _keys
    #
    # if a) is false, the item is a normal data bag
    # if a) and b) are true, the item is a vault
    # if a) is true but b) is false, the item is an encrypted data
    #   bag item
    # @param vault [String] the name of the data bag
    # @param name [String] the name of the item in the data bag
    # @return [Symbol] one of :vault, :encrypted or :normal
    def self.data_bag_item_type(vault, name)
      # adapted from https://github.com/opscode-cookbooks/chef-vault/blob/v1.3.0/libraries/chef_vault_item.rb
      # and https://github.com/sensu/sensu-chef/blob/2.9.0/libraries/sensu_helpers.rb
      dbi = Chef::DataBagItem.load(vault, name)
      encrypted = dbi.detect do |_, v|
        v.is_a?(Hash) && v.key?("encrypted_data")
      end

      # return a symbol describing the type of item we detected
      case
      when encrypted && Chef::DataBag.load(vault).key?("#{name}_keys")
        :vault
      when encrypted
        :encrypted
      else
        :normal
      end
    end

    # refreshes a vault by re-processing the search query and
    # adding a secret for any nodes found (including new ones)
    # @param clean_unknown_clients [Boolean] remove clients that can
    #   no longer be found
    # @return [void]
    def refresh(clean_unknown_clients = false)
      unless search
        raise ChefVault::Exceptions::SearchNotFound,
              "#{vault}/#{item} does not have a stored search_query, "\
              "probably because it was created with an older version "\
              "of chef-vault. Use 'knife vault update' to update the "\
              "databag with the search query."
      end

      # a bit of a misnomer; this doesn't remove unknown
      # admins, just clients which are nodes
      remove_unknown_nodes if clean_unknown_clients

      # re-process the search query to add new clients
      clients

      # save the updated keys only
      save_keys(@raw_data["id"])
    end

    private

    def encrypt!
      @raw_data = Chef::EncryptedDataBagItem.encrypt_data_bag_item(self, @secret)
      @encrypted = true
    end

    def reload_raw_data
      @raw_data =
        Chef::EncryptedDataBagItem.load(@data_bag, @raw_data["id"], secret).to_hash
      @encrypted = false

      @raw_data
    end

    def load_actor(actor_name, type)
      ChefVault::Actor.new(type, actor_name)
    end

    # removes unknown nodes by performing a node search
    # for each of the existing clients.  If the search
    # returns nothing or the client cannot be loaded, then
    # we remove that client from the vault
    # @return [void]
    def remove_unknown_nodes
      # build a list of clients to remove so we don't
      # mutate the clients while iterating over search results
      clients_to_remove = []
      get_clients.each do |nodename|
        clients_to_remove.push(nodename) unless node_exists?(nodename)
      end
      # now delete any flagged clients from the keys data bag
      clients_to_remove.each do |client|
        ChefVault::Log.warn "Removing unknown client '#{client}'"
        keys.delete(load_actor(client, "clients"))
      end
    end

    # checks if a node exists on the Chef server by performing
    # a search against the node index.  If the search returns no
    # results, the node does not exist.
    # @param nodename [String] the name of the node
    # @return [Boolean] whether the node exists or not
    def node_exists?(nodename)
      search_results.include?(nodename)
    end

    # checks if a client exists on the Chef server.  If we get back
    # a 404, the client does not exist.  Any other HTTP errors are
    # re-raised.  Otherwise, the client exists
    # @param clientname [String] the name of the client
    # @return [Boolean] whether the client exists or not
    def client_exists?(clientname)
      Chef::ApiClient.load(clientname)
      true
    rescue Net::HTTPServerException => http_error
      return false if http_error.response.code == "404"
      raise http_error
    end

    # adds or deletes an API client from the vault item keys
    # @param client [Chef::ApiClient] the API client to operate on
    # @param action [Symbol] :add or :delete
    # @return [void]
    def handle_client_action(api_client, action)
      case action
      when :add
        # TODO: next line seems to create a client from the api_client (which seems to be identical)
        client = load_actor(api_client.name, "clients")
        add_client(client)
      when :delete
        delete_client_or_node(api_client.name)
      end
    end

    # adds a client to the vault item keys
    # @param client [Chef::ApiClient] the API client to add
    # @return [void]
    def add_client(client)
      keys.add(client, @secret)
    end

    # removes a client to the vault item keys
    # @param client_or_node [String] the name of the API client or node to remove
    # @return [void]
    def delete_client_or_node(name)
      client = load_actor(name, "clients")
      keys.delete(client)
    end
  end
end
