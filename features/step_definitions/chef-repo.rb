Given(/^a local mode chef repo with nodes '(.+)'$/) do |nodelist|
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
    create_admin
  end
  # add the admin key to the knife configuration
  append_to_file 'knife.rb', <<EOF
node_name 'admin'
client_key 'admin.pem'
EOF
  # create the requested nodes
  nodelist.split(/,/).each do |node|
    in_current_dir do
      create_client(node)
      create_node(node)
    end
  end
end

Given(/^I delete clients? '(.+)' from the Chef server$/) do |nodelist|
  nodelist.split(/,/).each do |node|
    in_current_dir do
      delete_client(node)
    end
  end
end

Given(/^I regenerate the client key for the node '(.+)'$/) do |node|
  in_current_dir do
    delete_client(node)
    create_client(node)
  end
end

def create_node(name)
  system "knife node create #{name} -z -d -c knife.rb"
end

def create_admin
  create_client('admin', '-a')
end

def create_client(name, args = nil)
  system "knife client create #{name} -z -d -c knife.rb #{args} > #{name}.pem"
end

def delete_client(name)
  system "knife client delete #{name} -y -z"
end
