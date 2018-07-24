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

require "chef/server_api"

class ChefVault
  class ChefApi

    def rest_v0
      @rest_v0 ||= Chef::ServerAPI.new(Chef::Config[:chef_server_root], { api_version: "0" })
    end

    def rest_v1
      @rest_v1 ||= Chef::ServerAPI.new(Chef::Config[:chef_server_root], { api_version: "1" })
    end

    def org_scoped_rest_v0
      @org_scoped_rest_v0 ||= Chef::ServerAPI.new(Chef::Config[:chef_server_url], { api_version: "0" })
    end

    def org_scoped_rest_v1
      @org_scoped_rest_v1 ||= Chef::ServerAPI.new(Chef::Config[:chef_server_url], { api_version: "1" })
    end

  end
end
