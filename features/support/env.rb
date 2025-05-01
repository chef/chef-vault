require "aruba/cucumber"

Aruba.configure do |config|
  if RUBY_PLATFORM =~ /mswin|mingw|cygwin/
    config.exit_timeout = 30
  else
    config.exit_timeout = 15
  end

  config.activate_announcer_on_command_failure = %i{stderr stdout command}
end