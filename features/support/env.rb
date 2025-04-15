require "aruba/cucumber"

# Travis runs tests in a limited environment which takes a long time to invoke
# the knife command.  Up the timeout when we're in a travis build based on the
# environment variable set in .travis.yml
# if ENV['TRAVIS_BUILD']
Before do
  if RUBY_PLATFORM =~ /mswin|win32|mingw/
    @aruba_timeout_seconds = 40
    @aruba_io_wait_seconds = 10
  else
    @aruba_timeout_seconds = 25
  end
end

After do
  if RUBY_PLATFORM =~ /mswin|win32|mingw/
    all_commands.each do |process|
      process.stop if process.respond_to?(:stop)
    end
  end
end

# end
