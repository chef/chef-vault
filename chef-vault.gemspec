# -*- encoding: utf-8 -*-
# Chef-Vault Gemspec file
# Copyright 2013, Nordstrom, Inc.

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
  s.authors          = ['Kevin Moser']
  s.email            = ['kevin.moser@nordstrom.com']
  s.summary          = 'Data encryption support for Chef using data bags'
  s.description      = s.summary
  s.homepage      = 'https://github.com/Nordstrom/chef-vault'

  s.license          = 'Apache License, v2.0'

  s.files            = `git ls-files`.split("\n")
  s.require_paths    = ['lib']
  s.bindir           = 'bin'
  s.executables      = %w( chef-vault )

  s.add_development_dependency 'bundler', '~> 1.3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 2.14'
  # needed for rspec
  s.add_development_dependency 'chef', '~> 11.12'
end
