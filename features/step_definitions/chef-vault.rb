require 'json'

When /^I create a vault item '(.+)\/(.+)' containing the JSON '(.+)' encrypted for '(.+)'$/ do |vault, item, json, nodelist|
  write_file 'item.json', json
  query = nodelist.split(/,/).map{|e| "name:#{e}"}.join(' OR ')
  run_simple "knife vault create #{vault} #{item} -z -c knife.rb -A admin -S '#{query}' -J item.json"
end

When /^I update the vault item '(.+)\/(.+)' to be encrypted for '(.+)'( with the clean option)?$/ do |vault, item, nodelist, cleanopt|
  query = nodelist.split(/,/).map{|e| "name:#{e}"}.join(' OR ')
  run_simple "knife vault update #{vault} #{item} -S '#{query}' #{cleanopt ? '--clean' : ''}"
end

When /^I remove clients? '(.+)' from vault item '(.+)\/(.+)' with the '(.+)' options?$/ do |nodelist, vault, item, optionlist|
  query = nodelist.split(/,/).map{|e| "name:#{e}"}.join(' OR ')
  options = optionlist.split(/,/).map{|o| "--#{o}"}.join(' ')
  run_simple "knife vault remove #{vault} #{item} -S '#{query}' #{options}"
end

When /^I rotate the keys for vault item '(.+)\/(.+)' with the '(.+)' options?$/ do |vault, item, optionlist|
  options = optionlist.split(/,/).map{|o| "--#{o}"}.join(' ')
  run_simple "knife vault rotate keys #{vault} #{item} #{options}"
end

When /^I rotate all keys with the '(.+)' options?$/ do |optionlist|
  options = optionlist.split(/,/).map{|o| "--#{o}"}.join(' ')
  run_simple "knife vault rotate all keys #{options}"
end

Then /^the vault item '(.+)\/(.+)' should( not)? be encrypted for '(.+)'$/ do |vault, item, neg, nodelist|
  nodes = nodelist.split(/,/)
  command = "knife data bag show #{vault} #{item}_keys -z -c knife.rb -F json"
  run_simple(command)
  output = stdout_from(command)
  data = JSON.parse(output)
  nodes.each do |node|
    if neg
      expect(data).not_to include(node)
    else
      expect(data).to include(node)
    end
  end
end

Given(/^'(.+)' should( not)? be a client for the vault item '(.+)\/(.+)'$/) do |nodelist, neg, vault, item|
  nodes = nodelist.split(/,/)
  command = "knife data bag show #{vault} #{item}_keys -z -c knife.rb -F json"
  run_simple(command)
  output = stdout_from(command)
  data = JSON.parse(output)
  nodes.each do |node|
    if neg
      expect(data['clients']).not_to include(node)
    else
      expect(data['clients']).to include(node)
    end
  end
end

Given(/^'(.+)' should( not)? be an admin for the vault item '(.+)\/(.+)'$/) do |nodelist, neg, vault, item|
  nodes = nodelist.split(/,/)
  command = "knife data bag show #{vault} #{item}_keys -z -c knife.rb -F json"
  run_simple(command)
  output = stdout_from(command)
  data = JSON.parse(output)
  nodes.each do |node|
    if neg
      expect(data['admins']).not_to include(node)
    else
      expect(data['admins']).to include(node)
    end
  end
end
