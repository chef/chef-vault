require "bundler/gem_tasks"

WINDOWS_PLATFORM = %w{ x64-mingw32 x64-mingw-ucrt ruby }.freeze

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
  Cucumber::Rake::Task.new(:features) do |t|
    if WINDOWS_PLATFORM.include?(WINDOWS_PLATFORM) || RUBY_PLATFORM.match?(/darwin/)
      t.cucumber_opts = "--tags 'not @not-windows'"
    end
  end
rescue LoadError
  puts "Cucumber/Aruba not available; disabling feature tasks"
  # create a no-op spec task for :default
  task :features
end

# test or the default task runs spec, features, style
desc "run all tests"
task default: %i{coverage features style}
task test: :default
