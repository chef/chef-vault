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

$:.push File.expand_path('../lib', __FILE__)
require 'chef-vault/version'

Gem::Specification.new do |s|
  s.name             = 'chef-vault'
  s.version          = ChefVault::VERSION
  s.has_rdoc         = true
  s.authors          = ['Kevin Moser', 'James FitzGibbon']
  s.email            = ['techcheftm@nordstrom.com']
  s.summary          = 'Data encryption support for Chef using data bags'
  s.description      = s.summary
  s.homepage         = 'https://github.com/chef/chef-vault'

  s.license          = 'Apache License, v2.0'

  s.files            = `git ls-files`.split("\n")
  s.require_paths    = ['lib']
  s.bindir           = 'bin'
  s.executables      = %w( chef-vault )

  s.required_ruby_version = ">= 2.0.0"

  s.add_development_dependency 'rake', '~> 10.4'
  s.add_development_dependency 'rspec', '~> 3.2'
  s.add_development_dependency 'aruba', '~> 0.6'
  s.add_development_dependency 'simplecov', '~> 0.9'
  s.add_development_dependency 'simplecov-console', '~> 0.2'
  s.add_development_dependency 'rubocop', '~> 0.30'
  # Chef 12 and higher pull in Ohai 8, which needs Ruby v2
  # so only in the case of a CI build on ruby v1, we constrain
  # chef to 11 or lower so that we can maintain CI test coverage
  # of older versions
  if ENV.key?('TRAVIS_BUILD') && RUBY_VERSION =~ /^1/
    s.add_development_dependency 'chef', '~> 11.18'
  else
    s.add_development_dependency 'chef', '>= 0.10.10'
  end
end
