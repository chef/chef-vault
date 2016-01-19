Given(/^I create a data bag item '(.+)\/(.+)' containing the JSON '(.+)'$/) do |databag, _, json|
  write_file "item.json", json
  run_simple "knife data bag from file #{databag} item.json -z -c knife.rb", false
end

Given(/^I create an encrypted data bag item '(.+)\/(.+)' containing the JSON '(.+)' with the secret '(.+)'$/) do |databag, _, json, secret|
  write_file "item.json", json
  run_simple "knife data bag from file #{databag} item.json -s #{secret} -z -c knife.rb", false
end
