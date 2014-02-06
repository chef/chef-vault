# A Short Demo of the Magic of Chef-Vault

##Set up the magic show from a shell on your own workstation

###Put the bunny in the hat

    echo "bunny" > tophat

###Put the hat in the magic show

    export me=aug24                          #Change this to your chef id 
    export role=myrole                       #Change this to the role you need to pass the secret to
    
    knife vault create magicshow hat \       #Create a hat object in a data bag called magicshow
       --mode client                 \       #Talk to the server rather than local 
       --file tophat                 \       #Use the hat (file) we put the bunny in
       --search "role:${role}"       \       #Encrypted for all *current* servers with my role
       --admins "${me}"                      #Encrypted for me

###Check the magic show is on the server

    knife data bag list

###Check the hat is there (and that nobody can see what's in it)
    knife data bag show magicshow hat

###Check you can see what's in it
    knife vault show magicshow hat file-content --mode client

##'Hop' on to a server with the right role ('myrole', above)

###Install required software
    sudo apt-get install ruby-dev --yes
    sudo gem install chef-vault --no-ri --no-rdoc

###Get the bunny back out of the hat!
    sudo chef-shell --client <<EOF
    require 'chef-vault'
    puts ChefVault::Item.load('magicshow', 'hat')['file-content']
    EOF

#Finally, do a disappearing act.

###Make the hat disappear...
    knife vault delete magicshow hat --mode client
    
###Make the entire magic show disappear...
    knife data bag delete magicshow

###Thank you!