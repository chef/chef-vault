Given(%r{^I create a data bag item '(.+)/(.+)' containing the JSON '(.+)'$}) do |databag, _, json|
  write_file "item.json", json
  run_command_and_stop "knife data bag from file #{databag} item.json -z -c config.rb", false
end

Given(%r{^I create an encrypted data bag item '(.+)/(.+)' containing the JSON '(.+)' with the secret '(.+)'$}) do |databag, _, json, secret|
  write_file "item.json", json
  run_command_and_stop "knife data bag from file #{databag} item.json -s #{secret} -z -c config.rb", false
end
