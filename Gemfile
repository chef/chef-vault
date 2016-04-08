source "https://rubygems.org/"

group :development do
  gem "chefstyle", git: "https://github.com/chef/chefstyle.git"
end
if RUBY_VERSION.to_f >= 2.0
  group :changelog do
    gem "github_changelog_generator", "1.11.3"
  end
end

gemspec
