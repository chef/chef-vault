source "https://rubygems.org"

gemspec

group :development do
  gem "chefstyle"
  gem "chef-zero"
  gem "rake"
  gem "rspec", "~> 3.4"
  gem "aruba", "~> 0.6"
  gem "chef", "~> 14.0" # avoids test failures on license acceptance
end

group :debug do
  gem "pry"
  gem "pry-byebug"
  gem "rb-readline"
end

if Gem.ruby_version < Gem::Version.new("2.6")
  # 16.7.23 required ruby 2.6+
  gem "chef-utils", "< 16.7.23" # TODO: remove when we drop ruby 2.4/2.5
end
