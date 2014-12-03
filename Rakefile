require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'cucumber'
require 'cucumber/rake/task'

RSpec::Core::RakeTask.new(:spec)

Cucumber::Rake::Task.new(:features)

task default: [:spec, :features]

task :coverage do
  ENV['COVERAGE'] = '1'
  Rake::Task[:spec].invoke
  Rake::Task[:features].invoke
end
