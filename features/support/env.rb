require "aruba/cucumber"

# Travis runs tests in a limited environment which takes a long time to invoke
# the knife command.  Up the timeout when we're in a travis build based on the
# environment variable set in .travis.yml
# if ENV['TRAVIS_BUILD']
Before do
  @aruba_timeout_seconds = 25
  @aruba_io_wait_seconds = 2

  # Ensure a clean working directory to avoid leftover files
  clean_current_directory
end
# end
