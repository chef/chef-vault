source "https://rubygems.org"

gemspec

group :development do
  gem "chefstyle"
  gem "chef-zero"
  gem "rake"
  gem "rspec", "~> 3.4"
  gem "aruba", "~> 0.6"
  if RUBY_VERSION < "3.0"
    gem "chef", "~> 14.0"
  else
    gem "chef", "~> 17.0"
  end
  gem "contracts", "~> 0.16.1" # pin until we drop ruby < 2.7
  if RUBY_VERSION  > "3.0"
    gem "chef-utils", "~> 17.0" # pin until we drop ruby >=3
  else
    gem "chef-utils", "= 16.6.14" # pin until we drop ruby 2.5
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
