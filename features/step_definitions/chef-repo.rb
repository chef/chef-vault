Given(/^a local mode chef repo with nodes '(.+?)'(?: with admins '(.+?)')?$/) do |nodelist, adminlist|
  # create the repo directory hierarchy
  %w{cookbooks clients nodes data_bags}.each do |dir|
    create_directory dir
  end
  # create a basic config.rb
  write_file "config.rb", <<EOF
local_mode true
chef_repo_path '.'
chef_zero.enabled true
knife[:vault_mode] = 'client'
EOF
  # create the admin users and capture their private key we
  # always create an admin called 'admin' because otherwise subsequent
  # steps become annoying to determine who the admin is
  admins = %w{admin}
  admins.push(adminlist.split(/,/)) if adminlist
  admins.flatten.each do |admin|
    create_admin(admin)
  end
  # add the admin key to the knife configuration
  append_to_file "config.rb", <<EOF
node_name 'admin'
client_key 'admin.pem'
EOF
  # create the requested nodes
  nodelist.split(/,/).each do |node|
    create_client(node)
    create_node(node)
  end
end

Given(/^I create an admin named '(.+)'$/) do |admin|
  create_admin(admin)
end

Given(/^I create( mismatched)? client config for client named '(.+)'$/) do |mismatched, client|
  create_client_config(client, mismatched)
end

Given(/^I delete clients? '(.+)' from the Chef server$/) do |nodelist|
  nodelist.split(/,/).each do |node|
    delete_client(node)
  end
end

Given(/^I regenerate the client key for the node '(.+)'$/) do |node|
  delete_client(node)
  create_client(node)
end

Given(/^I delete nodes? '(.+)' from the Chef server$/) do |nodelist|
  nodelist.split(/,/).each { |node| delete_node(node) }
end

def create_node(name)
  run_command_and_stop "knife node create #{name} -z -d -c config.rb"
end

def create_admin(admin)
  create_client(admin)
end

# def create_client(name)
#   command = "knife client create #{name} -z -d -c config.rb >#{name}.pem"
#   run_command_and_stop command
#   write_file("#{name}.pem", last_command_started.stdout)
# end

# def create_client(name)
#   command = "knife client create #{name} -z -d -c config.rb"
#   run_command_and_stop(command)

#   pem_file = "#{name}.pem"
#   # Write the captured stdout (the PEM contents) to the .pem file manually
#   write_file(pem_file, last_command_started.stdout)
# end

def create_client(name)
  command = "knife client create #{name} -z -d -c config.rb"
  run_command_and_stop(command)

  pem_file = "#{name}.pem"

  # On Windows, give a small delay to avoid file lock issues
  sleep 0.5 if RUBY_PLATFORM =~ /mswin|win32|mingw/

  write_file(pem_file, last_command_started.stdout)
end

def delete_client(name)
  run_command_and_stop "knife client delete #{name} -y -z -c config.rb"
end

def delete_node(name)
  run_command_and_stop "knife node delete #{name} -y -z -c config.rb"
end

def create_client_config(name, mismatched = false)
  content = <<EOF
local_mode true
chef_repo_path '.'
chef_zero.enabled true
knife[:vault_mode] = 'client'
node_name '#{name}'
client_key_contents IO.read('#{name}.pem')
EOF
  write_file("config_#{name}.rb", content)
  if mismatched
    append_to_file "config_#{name}.rb", "client_key 'admin.pem'"
  end
end
