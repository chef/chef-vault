source "https://rubygems.org"

gemspec

group :development do
  gem "chefstyle"
  gem "chef-zero"
  gem "rake"
  gem "rspec", "~> 3.4"
  gem "aruba", "~> 0.6"
  gem "contracts", "~> 0.16.1" # pin until we drop ruby < 2.7
  if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("3.0.0")
    gem "chef", "~> 14.0"
    gem "chef-utils", "= 16.6.14" # pin until we drop ruby 2.5
  else
    gem "chef", "~> 17.0"
    gem "chef-utils", "~> 17.0" # pin until we drop ruby >=3
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
  gem "pry-stack_explorer", "~> 0.4.0" # pin until we drop ruby < 2.6
  gem "rb-readline"
end

gem "simplecov", require: false
