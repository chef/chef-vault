source "https://rubygems.org"

gemspec

group :development do
  gem "chefstyle"
  gem "rake"
  if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("3.0.0")
    gem "contracts", "~> 0.16.1" # pin until we drop ruby < 2.7
    gem "chef-zero"
    gem "rspec", "~> 3.12.0"
    gem "aruba", "~> 2.2"
    gem "chef", "~> 15.4"
    gem "chef-utils", "17.10.68" # pin until we drop ruby 2.5
  else
    gem "contracts", "~> 0.17"
    gem "chef-zero", ">= 15.0.11"
    gem "chef", "~> 18.0"
    gem "rspec", "~> 3.12"
    gem "aruba", "~> 2.2"
    gem "knife", "~> 18.0"
    gem "chef-utils", "~> 18.0" # pin until we drop ruby >=3
  end
end

group :docs do
  gem "yard"
  gem "redcarpet"
  gem "github-markup"
end

group :debug do
  gem "pry"
  gem "pry-byebug"
  gem "pry-stack_explorer", "~> 0.6.1" # pin until we drop ruby < 2.6
  gem "rb-readline"
end

gem "simplecov", require: false
