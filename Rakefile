require "bundler/gem_tasks"
require "fileutils"

WINDOWS_PLATFORM = /mswin|win32|mingw/.freeze unless defined? WINDOWS_PLATFORM

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
  files_to_check = ["admin.pem", "client.pem", "config.rb"] # Add any other files that need to be checked
  max_retries = 20 # Increased retry count
  retry_delay = 2 # Increased delay between retries (2 seconds)
  puts "Checking for file access conflicts..."
  files_to_check.each do |file|
    retries = 0
    while File.exist?(file) && !File.open(file) { |f| f.flock(File::LOCK_EX | File::LOCK_NB) }
      puts "File access conflict detected: #{file} is currently locked by another process."
      if retries >= max_retries
        puts "File access timeout: #{file} could not be accessed after #{max_retries} retries"
        raise "File access timeout: #{file} could not be accessed after #{max_retries} retries"
      end

      puts "Waiting for #{file} to be available... Retry ##{retries}..."
      retries += 1
      puts "Waiting for #{file} to be available... Retry ##{retries}..."
      $stdout.flush
      sleep retry_delay
    end
    puts "#{file} is now available for access."
    $stdout.flush
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

# Test or the default task runs spec, features, style
desc "run all tests"
task default: %i{coverage features style}
task test: :default
