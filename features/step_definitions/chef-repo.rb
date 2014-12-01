Given /^a local mode chef repo with nodes '(.+)'$/ do |nodelist|
  # create the repo directory hierarchy
  %w(cookbooks clients nodes data_bags).each do |dir|
    create_dir dir
  end
  # create a basic knife.rb
  write_file 'knife.rb', <<EOF
local_mode true
chef_repo_path '.'
chef_zero.enabled true
EOF
  # create the admin user and capture its private key
  in_current_dir do
      system 'knife client create admin -z -d -a -c knife.rb > admin.pem'
  end
  # add the admin key to the knife configuration
  append_to_file 'knife.rb', <<EOF
node_name 'admin'
client_key 'admin.pem'
EOF
  # create the requested nodes
  nodelist.split(/,/).each do |node|
    run_simple "knife client create #{node} -z -d -c knife.rb"
    run_simple "knife node create #{node} -z -d -c knife.rb"
  end
end

When /^I delete clients? '(.+)' from the Chef server$/ do |nodelist|
  nodelist.split(/,/).each do |node|
    run_simple "knife client delete #{node} -z -d -y -c knife.rb"
  end
end

