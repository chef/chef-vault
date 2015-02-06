When /^I create a data bag '(.+)' containing the JSON '(.+)'$/ do |bag, json|
  write_file 'item.json', json
  run_simple "knife data bag create #{bag} -z -c knife.rb -d"
  run_simple "knife data bag from_file #{bag} -z -c knife.rb item.json"
end
