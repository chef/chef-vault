# Author:: Tyler Cloke <tyler@chef.io>
# Copyright:: Copyright 2016, Chef Software, Inc.
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

require "json"

class ChefVault
  class Actor

    attr_accessor :key_string
    attr_reader :type
    attr_reader :name

    def initialize(actor_type, actor_name)
      if actor_type != "clients" && actor_type != "admins"
        raise "You must pass either 'clients' or 'admins' as the first argument to ChefVault::Actor.new."
      end
      @type = actor_type
      @name = actor_name
    end

    def key
      @key ||= is_admin? ? get_admin_key : get_client_key
    end

    def get_admin_key
      # chef vault currently only supports using the default key
      get_key("users")
    rescue Net::HTTPServerException => http_error
      # if we failed to find an admin key, attempt to load a client key by the same name
      case http_error.response.code
      when "403"
        print_forbidden_error
        raise http_error
      when "404"
        begin
          ChefVault::Log.warn "The default key for #{name} not found in users, trying client keys."
          get_key("clients")
        rescue Net::HTTPServerException => http_error
          case http_error.response.code
          when "404"
            raise ChefVault::Exceptions::AdminNotFound,
                  "FATAL: Could not find default key for #{name} in users or clients!"
          when "403"
            print_forbidden_error
            raise http_error
          else
            raise http_error
          end
        end
      else
        raise http_error
      end
    end

    def get_client_key
      get_key("clients")
    rescue Net::HTTPServerException => http_error
      if http_error.response.code.eql?("403")
        print_forbidden_error
        raise http_error
      elsif http_error.response.code.eql?("404")
        raise ChefVault::Exceptions::ClientNotFound,
              "#{name} is not a valid chef client and/or node"
      else
        raise http_error
      end
    end

    def is_client?
      type == "clients"
    end

    def is_admin?
      type == "admins"
    end

    # @private

    def api
      @api ||= ChefVault::ChefApi.new
    end

    # Use API V0 to load the public_key directly from the user object
    # using the chef-client code.
    def chef_api_client
      @chef_api_client ||= begin
                             require "chef/api_client"
                             Chef::ApiClient
                           end
    end

    # Similar thing as above but for client.
    def chef_user
      @chef_user ||= begin
                       require "chef/user"
                       Chef::User
                     end
    end

    def get_key(request_actor_type)
      api.org_scoped_rest_v1.get("#{request_actor_type}/#{name}/keys/default").fetch("public_key")
    # If the keys endpoint doesn't exist, try getting it directly from the V0 chef object.
    rescue Net::HTTPServerException => http_error
      raise http_error unless http_error.response.code.eql?("404")
      if request_actor_type.eql?("clients")
        chef_api_client.load(name).public_key
      else
        chef_user.load(name).public_key
      end
    end

    def print_forbidden_error
      ChefVault::Log.error <<EOF
ERROR: You received a 403 FORBIDDEN while requesting an #{type} key for #{name}.

If you are on Chef Server < 12.5:
  Clients do not have access to all public keys within their org.
  Either upgrade to Chef Server >= 12.5 or make this request using a user.

If you are on Chef Server == 12.5.0
  All clients and users have access to the public keys endpoint. Getting
  this error on 12.5.0 is unexpected regardless of what your
  public_key_read_access_group contains.

If you are on Chef Server > 12.5.1
  Has your public_key_read_access_group been modified? This group controls
  read access on public keys within your org. It defaults to the users
  and client groups, so all org actors should have permission unless
  the defaults have been changed.

EOF
    end
  end
end
