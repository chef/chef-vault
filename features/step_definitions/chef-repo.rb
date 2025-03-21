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
  command = "knife node create #{name} -z -d -c config.rb"

  begin
    run_command_and_stop(command)
    puts "Node '#{name}' created successfully."
  rescue => e
    raise "Failed to create node '#{name}': #{e.message}\nCommand: #{command}\nOutput: #{last_command_started.output}"
  end
end

def create_admin(admin)
  create_client(admin)
end

# def create_client(name)
#   pem_file = "#{name}.pem"
#   command = "knife client create #{name} -z -d -c config.rb"

#   run_command_and_stop(command)

#   # Capture the stdout result
#   pem_content = last_command_started.stdout.strip

#   # Ensure PEM content is valid before writing
#   unless pem_content.match?(/-----BEGIN RSA PRIVATE KEY-----/)
#     raise "Generated .pem file for client '#{name}' is invalid or empty."
#   end

#   # Explicitly write the key file
#   write_file(pem_file, pem_content)

#   puts "✅ Client '#{name}' created successfully with key file: #{pem_file}"
# end

# def create_client(name)
#   command = "knife client create #{name} -z -d -c config.rb >#{name}.pem"

#   if RUBY_PLATFORM =~ /mswin|mingw|cygwin/
#     with_environment("ARUBA_TIMEOUT" => "35") do
#       run_command_and_stop(command)
#     end
#   else
#     run_command_and_stop(command)
#   end

#   write_file("#{name}.pem", last_command_started.stdout)
# end

def create_client(name)
  pem_file = "#{name}.pem"
  command = "knife client create #{name} -z -d -c config.rb"
  retries = 0

  begin
    if RUBY_PLATFORM =~ /mswin|mingw|cygwin/
      run_command_and_stop(command)

      if last_command_stopped.nil?
        raise "Command did not run or was not captured properly by Aruba."
      elsif last_command_stopped.exit_status != 0
        raise "Command failed with exit code #{last_command_stopped.exit_status}: #{last_command_stopped.stderr}"
      end

      write_file(pem_file, pem_content)
      puts "✅ Client '#{name}' created successfully with key file: #{pem_file}"
    else
      # The existing non-Windows logic remains unchanged
      command += " > #{pem_file}"
      run_command_and_stop(command)
      write_file(pem_file, last_command_started.stdout)
    end
  rescue => e
    if retries < 3
      retries += 1
      puts "⚠️ Attempt #{retries}/3 failed: #{e.message}. Retrying in 5 seconds..."
      sleep(5)
      retry
    else
      puts "❗ Failed to create client '#{name}' after #{retries} attempts: #{e.message}"
      raise
    end
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
