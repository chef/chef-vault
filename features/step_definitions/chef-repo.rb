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

def create_client(name)
  command = "knife client create #{name} -z -d -c config.rb"
  pem_file = "#{name}.pem"

  if RUBY_PLATFORM =~ /mswin|win32|mingw/
    max_retries = 3
    retry_count = 0
    @aruba_timeout_seconds = 50

    begin
      puts "Running command: #{command} with timeout #{@aruba_timeout_seconds} seconds"
      run_command_and_stop(command, fail_on_error: false)

      if last_command_started.exit_status != 0
        raise "Command failed with exit status #{last_command_started.exit_status}. Output: #{last_command_started.stdout}"
      end

      write_file(pem_file, last_command_started.stdout)
    rescue => e
      retry_count += 1
      puts "Attempt #{retry_count}/#{max_retries} failed: #{e.message}"

      if retry_count < max_retries
        sleep 3
        retry
      else
        puts "Failed to execute after #{max_retries} attempts"
        raise e
      end
    end
  else
    run_command_and_stop(command)
    write_file(pem_file, last_command_started.stdout)
  end
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
