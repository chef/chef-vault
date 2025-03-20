require "aruba/cucumber"

Before do
  if RUBY_PLATFORM =~ /mswin|mingw|cygwin/
    @aruba_timeout_seconds = 30
    puts "⏳ Timeout set to 30 seconds for Windows platform."
  else
    @aruba_timeout_seconds = 15
    puts "⏳ Timeout set to 15 seconds for non-Windows platform."
  end
end
