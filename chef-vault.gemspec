# -*- encoding: utf-8 -*-
# Chef-Vault Gemspec file
# Copyright 2013-15, Nordstrom, Inc.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

$:.push File.expand_path("../lib", __FILE__)
require "chef-vault/version"

def self.prerelease?
  !ENV["TRAVIS_TAG"] || ENV["TRAVIS_TAG"].empty?
end

Gem::Specification.new do |s|
  s.name             = "chef-vault"
  s.version          = ChefVault::VERSION
  s.version          = "#{s.version}-pre#{ENV['TRAVIS_BUILD_NUMBER']}" if ENV["TRAVIS"]
  s.has_rdoc         = true
  s.authors          = ["Thom May"]
  s.email            = ["thom@chef.io"]
  s.summary          = "Data encryption support for Chef using data bags"
  s.description      = s.summary
  s.homepage         = "https://github.com/chef/chef-vault"
  s.license          = "Apache License, v2.0"
  s.files            = `git ls-files`.split("\n")
  s.require_paths    = ["lib"]
  s.bindir           = "bin"
  s.executables      = %w{ chef-vault }

  s.required_ruby_version = ">= 2.2.0"

  s.add_development_dependency "rake", "~> 11.0"
  s.add_development_dependency "rspec", "~> 3.4"
  s.add_development_dependency "aruba", "~> 0.6"
  s.add_development_dependency "simplecov", "~> 0.9"
  s.add_development_dependency "simplecov-console", "~> 0.2"
  if ENV.key?("TRAVIS_BUILD") && RUBY_VERSION == "2.1.9"
    # Test version of Chef with Chef Zero before
    # /orgs/org/users/user/keys endpoint was added.
    s.add_development_dependency "chef", "12.8.1"
  else # Test most current version of Chef on 2.2.2
    s.add_development_dependency :chef
  end
end
