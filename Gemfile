source "https://rubygems.org/"

group :development do
  gem "chefstyle", git: "https://github.com/chef/chefstyle.git"
end
if RUBY_VERSION.to_f >= 2.0
  group :changelog do
    gem "github_changelog_generator", git: "https://github.com/tduffield/github-changelog-generator", branch: "adjust-tag-section-mapping"
  end
end

gemspec
