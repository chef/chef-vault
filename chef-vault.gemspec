# Chef-Vault Gemspec file
# Copyright 2013-2015, Nordstrom, Inc.
# Copyright 2017-2019, Chef Software, Inc.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

$:.push File.expand_path("lib", __dir__)
require "chef-vault/version"

Gem::Specification.new do |s|
  s.name             = "chef-vault"
  s.version          = ChefVault::VERSION
  s.authors          = ["Thom May"]
  s.email            = ["thom@chef.io"]
  s.summary          = "Data encryption support for Chef Infra using data bags"
  s.description      = s.summary
  s.homepage         = "https://github.com/chef/chef-vault"
  s.license          = "Apache-2.0"
  s.files            = %w{LICENSE Gemfile} + Dir.glob("*.gemspec") + `git ls-files`.split("\n").select { |f| f =~ %r{^(?:bin/|lib/)}i }
  s.require_paths    = ["lib"]
  s.bindir           = "bin"
  s.executables      = %w{ chef-vault }

  s.required_ruby_version = ">= 3.1"

  # syslog was removed from Ruby's standard library in 3.4; see https://stdgems.org/new-in/3.4
  s.add_dependency "syslog", "~> 0.3"
end
