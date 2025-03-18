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
  task :spec
end

# ✅ New task to check for required files and list directories/files separately
desc "Check required files and list directory contents"
task :check_files do
  missing_files = []
  required_files = ["config.rb", "admin.pem", "client.pem"]

  puts "📂 Listing all directories in the current workspace:"
  Dir.entries(".").select { |entry| File.directory?(entry) && ![".", ".."].include?(entry) }.each do |dir|
    puts "📁 #{dir}"
  end
  puts "--------------------------------"

  puts "📜 Listing all files in the current workspace:"
  Dir.entries(".").select { |entry| File.file?(entry) }.each do |file|
    puts "📄 #{file}"
  end
  puts "--------------------------------"

  required_files.each do |file|
    unless File.exist?(file)
      missing_files << file
      puts "❌ Missing file: #{file}"
    else
      puts "✅ Found file: #{file}"
    end
  end

  if missing_files.empty?
    puts "✅ All required files are present."
  else
    puts "❌ ERROR: Missing required files: #{missing_files.join(', ')}"
    exit(1) # Fail the pipeline if files are missing
  end
end

desc "Ensure no file access conflicts"
task :ensure_file_access => :check_files do
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
  Cucumber::Rake::Task.new(features: :ensure_file_access) do |t|
    if RUBY_PLATFORM =~ WINDOWS_PLATFORM || RUBY_PLATFORM =~ /darwin/
      t.cucumber_opts = "--tags 'not @not-windows'"
    end
  end
rescue LoadError
  puts "Cucumber/Aruba not available; disabling feature tasks"
  task :features
end

# Run all tests
desc "Run all tests"
task default: %i{coverage features style}
task test: :default
