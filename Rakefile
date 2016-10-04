require "bundler/gem_tasks"
require_relative "tasks/github_changelog_generator"

# Style Tests
begin
  require "chefstyle"
  require "rubocop/rake_task"
  RuboCop::RakeTask.new do |t|
    t.formatters = ["progress"]
    t.options = ["-D"]
  end

  # style is an alias for rubocop
  task style: :rubocop
rescue LoadError
  puts "ChefStyle not available; disabling style checking tasks"
end

# Unit Tests
begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new

  # Coverage
  desc "Generate unit test coverage report"
  task :coverage do
    ENV["COVERAGE"] = "true"
    Rake::Task[:spec].invoke
  end
rescue LoadError
  puts "RSpec not available; disabling rspec tasks"
  # create a no-op spec task for :default
  task :spec
end

# Feature Tests
begin
  require "cucumber"
  require "cucumber/rake/task"
  Cucumber::Rake::Task.new(:features)
rescue LoadError
  puts "Cucumber/Aruba not available; disabling feature tasks"
  # create a no-op spec task for :default
  task :features
end

# test or the default task runs spec, features, style
desc "run all tests"
task default: [:coverage, :features, :style]
task test: :default
