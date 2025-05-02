require "aruba/cucumber"

# Travis runs tests in a limited environment which takes a long time to invoke
# the knife command.  Up the timeout when we're in a travis build based on the
# environment variable set in .travis.yml
# if ENV['TRAVIS_BUILD']
Aruba.configure do |config|
  if RUBY_PLATFORM =~ /mswin|mingw|cygwin/
    config.exit_timeout = 40
  else
    config.exit_timeout = 15
  end

  config.activate_announcer_on_command_failure = %i{stderr stdout command}
end
# end
