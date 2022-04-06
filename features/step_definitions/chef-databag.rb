When(/^I create a data bag '(.+)' containing the JSON '(.+)'$/) do |bag, json|
  write_file "item.json", json
  run_command_and_stop "knife data bag create #{bag} -z -c config.rb -d"
  run_command_and_stop "knife data bag from_file #{bag} -z -c config.rb item.json"
end

Given(/^I create an empty data bag '(.+)'$/) do |databag|
  run_command_and_stop "knife data bag create #{databag} -z -c config.rb", { fail_on_error: false }
end
