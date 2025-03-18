require "bundler/gem_tasks"
require "fileutils"

# WINDOWS_PLATFORM = /mswin|win32|mingw/.freeze unless defined? WINDOWS_PLATFORM

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

desc "Ensure no file access conflicts"
task :ensure_file_access do
  files_to_check = ["admin.pem", "client.pem", "config.rb"]
  max_retries = 20
  retry_delay = 2

  files_to_check.each do |file|
    retries = 0
    puts "Checking access for file: #{file}"
    $stdout.flush

    while File.exist?(file)
      puts "File #{file} exists."
      begin
        File.open(file, "r+") do |f|
          unless f.flock(File::LOCK_EX | File::LOCK_NB)
            puts "File #{file} is locked by another process."
          else
            puts "Successfully acquired lock on #{file}"
            f.flock(File::LOCK_UN)
            break
          end
        end
      rescue Errno::ENOENT
        puts "File #{file} disappeared. Skipping..."
        break
      rescue IOError => e
        puts "Cannot acquire lock on #{file}: #{e.message}"
      end

      if retries >= max_retries
        raise "File access timeout: #{file} could not be accessed after #{max_retries} retries"
      end

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
  
  # Define Cucumber Rake task without OS-specific filtering
  Cucumber::Rake::Task.new(features: :ensure_file_access)

rescue LoadError
  puts "Cucumber/Aruba not available; disabling feature tasks"
  task :features # Define an empty task to prevent errors
end


# Test or the default task runs spec, features, style
desc "run all tests"
task default: %i{coverage features style}
task test: :default
