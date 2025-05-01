require "bundler/gem_tasks"
require "fileutils" # Add this line

WINDOWS_PLATFORM = /mswin|win32|mingw/.freeze unless defined? WINDOWS_PLATFORM

# def elevated_permissions?
#   return true if RUBY_PLATFORM !~ WINDOWS_PLATFORM
#   require "win32ole"
#   shell = WIN32OLE.new("Shell.Application")
#   shell.IsUserAnAdmin
# end

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

# Ensure no file access conflicts
desc "Ensure no file access conflicts"
task :ensure_file_access do
  files_to_check = ["admin.pem", "config.rb"] # Add any other files that need to be checked

  files_to_check.each do |file|
    while File.exist?(file) && File.open(file) { |f| f.flock(File::LOCK_EX | File::LOCK_NB) } == false
      puts "Waiting for #{file} to be available..."
      sleep 1
    end
  end
end

# Feature Tests
begin
  require "cucumber"
  require "cucumber/rake/task"
  Cucumber::Rake::Task.new(features: :ensure_file_access) do |t| # Add dependency on :ensure_file_access
    if RUBY_PLATFORM =~ WINDOWS_PLATFORM || RUBY_PLATFORM =~ /darwin/
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
