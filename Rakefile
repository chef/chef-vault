require "bundler/gem_tasks"
require "fileutils" # Add this line

WINDOWS_PLATFORM = /mswin|win32|mingw/.freeze unless defined? WINDOWS_PLATFORM

# def elevated_permissions?
#   return true if RUBY_PLATFORM !~ WINDOWS_PLATFORM
#   require "win32ole"
#   shell = WIN32OLE.new("Shell.Application")
#   shell.IsUserAnAdmin
# end

# Ensure no file access conflicts
desc "Ensure no file access conflicts"
task :ensure_file_access do
  files_to_check = ["admin.pem", "client.pem", "config.rb"] # Add any other files that need to be checked
  max_retries = 10 # Set a retry limit
  retry_delay = 1 # Delay between retries in seconds

  files_to_check.each do |file|
    retries = 0
    while File.exist?(file) && !File.open(file) { |f| f.flock(File::LOCK_EX | File::LOCK_NB) }
      if retries >= max_retries
        raise "File access timeout: #{file} could not be accessed after #{max_retries} retries"
      end
      retries += 1
      puts "Waiting for #{file} to be available... Retry ##{retries}"
      sleep retry_delay
    end
  end
end

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
  Cucumber::Rake::Task.new(features: :ensure_file_access) do |t| 
    # Add dependency on :ensure_file_access to ensure file availability before running features
    if RUBY_PLATFORM =~ WINDOWS_PLATFORM || RUBY_PLATFORM =~ /darwin/
      t.cucumber_opts = "--tags 'not @not-windows'"
    end
  end
rescue LoadError
  puts "Cucumber/Aruba not available; disabling feature tasks"
  # create a no-op feature task for :default
  task :features
end

# Test or the default task runs spec, features, style
desc "run all tests"
task default: %i{coverage features style}

# Test task as an alias for default task
task test: :default
