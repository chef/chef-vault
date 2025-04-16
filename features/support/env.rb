require "aruba/cucumber"

Aruba.configure do |config|
  if RUBY_PLATFORM =~ /mswin|mingw|cygwin/
    config.exit_timeout = 30
    # config.io_wait_timeout = 2
  else
    config.exit_timeout = 25
  end

  config.activate_announcer_on_command_failure = %i{stderr stdout command}
end