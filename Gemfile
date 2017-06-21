source "https://rubygems.org/"

group :development do
  gem "chefstyle", "= 0.5.0"
end
if RUBY_VERSION.to_f >= 2.0
  group :changelog do
    gem "github_changelog_generator", git: "https://github.com/chef/github-changelog-generator"
  end
end

gemspec
