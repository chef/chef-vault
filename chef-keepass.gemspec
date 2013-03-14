# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "chef-keepass/version"

Gem::Specification.new do |s|
  s.name             = "chef-keepass"
  s.version          = ChefKeepass::VERSION
  s.has_rdoc         = true
  s.authors          = ["Kevin Moser"]
  s.email            = ["kevin.moser@nordstrom.com"]
  s.summary          = "Password encryption support for chef using data bags"
  s.description      = s.summary
  
  s.files            = `git ls-files`.split("\n")
  s.add_dependency "chef", ">= 0.10.10"
  s.require_paths = ["lib"]
end