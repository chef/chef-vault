require "json"

Given(%r{^I create a vault item '(.+)/(.+)'( with keys in sparse mode)? containing the JSON '(.+)' encrypted for '(.+)'(?: with '(.+)' as admins?)?$}) do |vault, item, sparse, json, nodelist, admins|
  write_file "item.json", json
  query = nodelist.split(/,/).map { |e| "name:#{e}" }.join(" OR ")
  adminarg = admins.nil? ? "-A admin" : "-A #{admins}"
  sparseopt = sparse.nil? ? "" : "-K sparse"
  run_command_and_stop   "knife vault create #{vault} #{item} -z -c config.rb #{adminarg} #{sparseopt} -S '#{query}' -J item.json", :fail_on_error => false
end

Given(%r{^I update the vault item '(.+)/(.+)' to be encrypted for '(.+)'( with the clean option)?$}) do |vault, item, nodelist, cleanopt|
  query = nodelist.split(/,/).map { |e| "name:#{e}" }.join(" OR ")
  run_command_and_stop "knife vault update #{vault} #{item} -z -c config.rb -S '#{query}' #{cleanopt ? "--clean" : ""}"
end

Given(%r{^I remove clients? '(.+)' from vault item '(.+)/(.+)' with the '(.+)' options?$}) do |nodelist, vault, item, optionlist|
  query = nodelist.split(/,/).map { |e| "name:#{e}" }.join(" OR ")
  options = optionlist.split(/,/).map { |o| "--#{o}" }.join(" ")
  run_command_and_stop "knife vault remove #{vault} #{item} -z -c config.rb -S '#{query}' #{options}"
end

Given(%r{^I rotate the keys for vault item '(.+)/(.+)' with the '(.+)' options?$}) do |vault, item, optionlist|
  options = optionlist.split(/,/).map { |o| "--#{o}" }.join(" ")
  run_command_and_stop "knife vault rotate keys #{vault} #{item} -c config.rb -z #{options}"
end

Given(/^I rotate all keys with the '(.+)' options?$/) do |optionlist|
  options = optionlist.split(/,/).map { |o| "--#{o}" }.join(" ")
  run_command_and_stop "knife vault rotate all keys -z -c config.rb #{options}"
end

Given(%r{^I refresh the vault item '(.+)/(.+)'$}) do |vault, item|
  run_command_and_stop "knife vault refresh #{vault} #{item} -c config.rb -z"
end

Given(%r{^I refresh the vault item '(.+)/(.+)' with the '(.+)' options?$}) do |vault, item, optionlist|
  options = optionlist.split(/,/).map { |o| "--#{o}" }.join(" ")
  run_command_and_stop "knife vault refresh #{vault} #{item} -c config.rb -z #{options}"
end

Given(%r{^I try to decrypt the vault item '(.+)/(.+)' as '(.+)'$}) do |vault, item, node|
  run_command_and_stop "knife vault show #{vault} #{item} -z -c config.rb -u #{node} -k #{node}.pem", :fail_on_error => false
end

Then(%r{^the vault item '(.+)/(.+)' should( not)? be encrypted for '(.+)'( with keys in sparse mode)?$}) do |vault, item, neg, nodelist, sparse|
  nodes = nodelist.split(/,/)
  command = "knife data bag show #{vault} #{item}_keys -z -c config.rb -F json"
  run_command_and_stop(command)
  output = last_command_started.stdout
  data = JSON.parse(output)
  if sparse
    expect(data).to include("mode" => "sparse")
    nodes.each do |node|
      command = "knife data bag show #{vault} #{item}_key_#{node} -z -c config.rb -F json"
      run_command_and_stop(command, fail_on_error: false)
      if neg
        error = last_command_started.stderr
        expect(error).to include("ERROR: The object you are looking for could not be found")
      else
        data = JSON.parse(last_command_started.stdout)
        expect(data).to include("id" => "#{item}_key_#{node}")
      end
    end
  else
    expect(data).to include("mode" => "default")
    nodes.each { |node| neg ? (expect(data).not_to include(node)) : (expect(data).to include(node)) }
  end
end

Given(%r{^'(.+)' should( not)? be a client for the vault item '(.+)/(.+)'$}) do |nodelist, neg, vault, item|
  nodes = nodelist.split(/,/)
  command = "knife data bag show #{vault} #{item}_keys -z -c config.rb -F json"
  run_command_and_stop(command)
  output = last_command_started.stdout
  data = JSON.parse(output)
  nodes.each do |node|
    if neg
      expect(data["clients"]).not_to include(node)
    else
      expect(data["clients"]).to include(node)
    end
  end
end

Given(%r{^'(.+)' should( not)? be an admin for the vault item '(.+)/(.+)'$}) do |nodelist, neg, vault, item|
  nodes = nodelist.split(/,/)
  command = "knife data bag show #{vault} #{item}_keys -z -c config.rb -F json"
  run_command_and_stop(command)
  output = last_command_started.stdout
  data = JSON.parse(output)
  nodes.each do |node|
    if neg
      expect(data["admins"]).not_to include(node)
    else
      expect(data["admins"]).to include(node)
    end
  end
end

Given(/^I list the vaults$/) do
  run_command_and_stop("knife vault list")
end

Given(%r{^I can('t)? decrypt the vault item '(.+)/(.+)' as '(.+)'$}) do |neg, vault, item, client|
  run_command_and_stop "knife vault show #{vault} #{item} -c config.rb -z -u #{client} -k #{client}.pem", :fail_on_error => false
  if neg
    expect(last_command_started).not_to have_exit_status(0)
  else
    expect(last_command_started).to have_exit_status(0)
  end
end

Given(%r{^I (try to )?add '(.+)' as an admin for the vault item '(.+)/(.+)'$}) do |try, newadmin, vault, item|
  run_command_and_stop "knife vault update #{vault} #{item} -c config.rb -z -A #{newadmin}", :fail_on_error => !try
end

Given(/^I show the keys of the vault '(.+)'$/) do |vault|
  run_command_and_stop "knife vault show #{vault} -c config.rb -z"
end

Given(%r{^I check if the data bag item '(.+)/(.+)' is a vault$}) do |vault, item|
  run_command_and_stop "knife vault isvault #{vault} #{item} -c config.rb -z", :fail_on_error => false
end

Given(%r{^I check the type of the data bag item '(.+)/(.+)'$}) do |vault, item|
  run_command_and_stop "knife vault itemtype #{vault} #{item} -c config.rb -z"
end

Given(%r{^I downgrade the vault item '(.+)/(.+)' to v1 syntax}) do |vault, item|
  # v1 syntax doesn't have the admins, clients and search_query keys
  keysfile = "tmp/aruba/data_bags/#{vault}/#{item}_keys.json"
  data = JSON.parse(IO.read(keysfile))
  %w{admins clients search_query}.each { |k| data.key?("raw_data") ? data["raw_data"].delete(k) : data.delete(k) }
  IO.write(keysfile, JSON.generate(data))
end

Given(%r{^I can save the JSON object of the encrypted data bag for the vault item '(.+)/(.+)'$}) do |vault, item|
  command = "knife data bag show #{vault} #{item} -z -c config.rb -F json"
  run_command_and_stop(command)
  output = last_command_started.stdout
  @saved_encrypted_vault_item = JSON.parse(output)
end

Given(%r{^the data bag of the vault item '(.+)/(.+)' has not been re-encrypted$}) do |vault, item|
  command = "knife data bag show #{vault} #{item} -z -c config.rb -F json"
  run_command_and_stop(command)
  output = last_command_started.stdout
  encrypted_vault_item = JSON.parse(output)

  expect(encrypted_vault_item).to eq(@saved_encrypted_vault_item)
end
