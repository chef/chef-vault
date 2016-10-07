# knife examples

## vault

    knife vault SUBCOMMAND VAULT ITEM VALUES

These are the commands that are used to take data in JSON format and encrypt that data into chef-vault style encrypted data bags in chef.

* vault - This is the name of the vault in which to store the encrypted item.  This is analogous to a chef data bag name
* item - The name of the item going in to the vault.  This is analogous to a chef data bag item id
* values - This is the JSON clear text data to be stored in the vault encrypted.  This is analogous to a chef data bag item data

## vault commands

### create
Create a vault called passwords and put an item called root in it with the given values for username and password encrypted for clients role:webserver, client1 & client2 and admins admin1 & admin2

    knife vault create passwords root '{"username": "root", "password": "mypassword"}' -S "role:webserver" -C "client1,client2" -A "admin1,admin2"

Create a vault called passwords and put an item called root in it with the given values for username and password encrypted for clients role:webserver and admins admin1 & admin2

    knife vault create passwords root '{"username": "root", "password": "mypassword"}' -S "role:webserver" -A "admin1,admin2"

Create a vault called passwords and put an item called root in it with the given values for username and password encrypted for clients role:webserver, client1 & client2

    knife vault create passwords root '{"username": "root", "password": "mypassword"}' -S "role:webserver" -C "client1,client2"

Create a vault called passwords and put an item called root in it with the given values for username and password encrypted for clients role:webserver

    knife vault create passwords root '{"username": "root", "password": "mypassword"}' -S "role:webserver"

Create a vault called passwords and put an item called root in it with the given values for username and password encrypted for clients client1 & client2

    knife vault create passwords root '{"username": "root", "password": "mypassword"}' -C "client1,client2"

Create a vault called passwords and put an item called root in it with the given values for username and password encrypted for admins admin1 & admin2

    knife vault create passwords root '{"username": "root", "password": "mypassword"}' -A "admin1,admin2"

Create a vault called passwords and put an item called root in it encrypted for admins admin1 & admin2.  *Leaving the data off the command-line will pop an editor to fill out the data*

    knife vault create passwords root -A "admin1,admin2"

Note: A JSON file can be used in place of specifying the values on the command line, see global options below for details

### update

Update the values in username and password in the vault passwords and item root.  Will overwrite existing values if values already exist!

    knife vault update passwords root '{"username": "root", "password": "mypassword"}'

Update the values in username and password in the vault passwords and item root and add role:webserver, client1 & client2 to the encrypted clients and admin1 & admin2 to the encrypted admins.  Will overwrite existing values if values already exist!

    knife vault update passwords root '{"username": "root", "password": "mypassword"}' -S "role:webserver" -C "client1,client2" -A "admin1,admin2"

Update the values in username and password in the vault passwords and item root and add role:webserver to the encrypted clients and admin1 & admin2 to the encrypted admins.  Will overwrite existing values if values already exist!

    knife vault update passwords root '{"username": "root", "password": "mypassword"}' -S "role:webserver" -A "admin1,admin2"

Update the values in username and password in the vault passwords and item root and add role:webserver to the encrypted clients.  Will overwrite existing values if values already exist!

    knife vault update passwords root '{"username": "root", "password": "mypassword"}' -S "role:webserver"

Update the values in username and password in the vault passwords and item root and add client1 & client2 to the encrypted clients.  Will overwrite existing values if values already exist!

    knife vault update passwords root '{"username": "root", "password": "mypassword"}' -C "client1,client2"

Update the values in username and password in the vault passwords and item root and add admin1 & admin2 to the encrypted admins.  Will overwrite existing values if values already exist!

    knife vault update passwords root '{"username": "root", "password": "mypassword"}' -A "admin1,admin2"

Add role:webserver to encrypted clients for the vault passwords and item root.

    knife vault update passwords root -S "role:webserver"

Add client1 & client2 to encrypted clients for the vault passwords and item root.

    knife vault update passwords root -C "client1,client2"

Add admin1 & admin2 to encrypted admins for the vault passwords and item root.

    knife vault update passwords root -A "admin1,admin2"

Add admin1 & admin2 to encrypted admins and role:webserver, client1 & client2 to encrypted clients for the vault passwords and item root.

    knife vault update passwords root -S "role:webserver" -C "client1,client2" -A "admin1,admin2"

Add admin1 & admin2 to encrypted admins and role:webserver to encrypted clients for the vault passwords and item root.

    knife vault update passwords root -S "role:webserver" -A "admin1,admin2"

Add admin1 & admin2 to encrypted admins and client1 & client2 to encrypted clients for the vault passwords and item root.

    knife vault update passwords root -C "client1,client2" -A "admin1,admin2"

Note: A JSON file can be used in place of specifying the values on the command line, see global options below for details

### remove

Remove the values in username and password from the vault passwords and item root.

    knife vault remove passwords root '{"username": "root", "password": "mypassword"}'

Remove the values in username and password from the vault passwords and item root and remove role:webserver, client1 & client2 from the encrypted clients and admin1 & admin2 from the encrypted admins.

    knife vault remove passwords root '{"username": "root", "password": "mypassword"}' -S "role:webserver" -C "client1,client2" -A "admin1,admin2"

Remove the values in username and password from the vault passwords and item root and remove role:webserver from the encrypted clients and admin1 & admin2 from the encrypted admins.

    knife vault remove passwords root '{"username": "root", "password": "mypassword"}' -S "role:webserver" -A "admin1,admin2"

Remove the values in username and password from the vault passwords and item root and remove client1 & client2 from the encrypted clients and admin1 & admin2 from the encrypted admins.

    knife vault remove passwords root '{"username": "root", "password": "mypassword"}' -C "client1,client2" -A "admin1,admin2"

Remove the values in username and password from the vault passwords and item root and remove role:webserver from the encrypted clients.

    knife vault remove passwords root '{"username": "root", "password": "mypassword"}' -S "role:webserver"

Remove the values in username and password from the vault passwords and item root and remove client1 & client2 from the encrypted clients.

    knife vault remove passwords root '{"username": "root", "password": "mypassword"}' -C "client1,client2"

Remove the values in username and password from the vault passwords and item root and remove admin1 & admin2 from the encrypted admins.

    knife vault remove passwords root '{"username": "root", "password": "mypassword"}' -A "admin1,admin2"

Remove admin1 & admin2 from encrypted admins and role:webserver, client1 & client2 from encrypted clients for the vault passwords and item root.

    knife vault remove passwords root -S "role:webserver" -C "client1,client2" -A "admin1,admin2"

Remove admin1 & admin2 from encrypted admins and role:webserver from encrypted clients for the vault passwords and item root.

    knife vault remove passwords root -S "role:webserver" -A "admin1,admin2"

Remove role:webserver from encrypted clients for the vault passwords and item root.

    knife vault remove passwords root -S "role:webserver"

Remove client1 & client2 from encrypted clients for the vault passwords and item root.

    knife vault remove passwords root -C "client1,client2"

Remove admin1 & admin2 from encrypted admins for the vault passwords and item root.

    knife vault remove passwords root -A "admin1,admin2"

### delete

Delete the item root from the vault passwords

    knife vault delete passwords root

### show

knife vault show VAULT [ITEM] [VALUES]

These are the commands that are used to decrypt a chef-vault encrypted item and show the requested values.

* vault - This is the name of the vault in which to store the encrypted item.  This is analogous to a chef data bag name
* item - The name of the item going in to the vault.  This is analogous to a chef data bag item id
* values - This is a comma list of values to decrypt from the vault item.  This is analogous to a list of hash keys.

Show the items in a vault

    knife vault show passwords

Show the entire root item in the passwords vault and print in JSON format.

    knife vault show passwords root -Fjson

Show the entire root item in the passwords vault and print in JSON format, including the search query, clients, and admins.

    knife vault show passwords root -Fjson -p all

Show the username and password for the item root in the vault passwords.

    knife vault show passwords root "username, password"

Show the contents for the item user_pem in the vault certs.

    knife vault show certs user_pem "contents"

### edit

knife vault edit VAULT ITEM

These are the commands that are used to edit a chef-vault encrypted item.

* Vault - This is the name of the vault in which to store the encrypted item.  This is analogous to a chef data bag name
* Item - The name of the item going in to the vault.  This is analogous to a chef data bag item id

Decrypt the entire root item in the passwords vault and open it in json format in your $EDITOR.  Writing and exiting out the editor will save and encrypt the vault item.

    knife vault edit passwords root

### download

Decrypt and download an encrypted file to the specified path.

    knife vault download certs user_pem ~/downloaded_user_pem

### rotate keys

Rotate the shared key for the vault passwords and item root. The shared key is that which is used for the chef encrypted data bag item.

    knife vault rotate keys passwords root

To remove clients which have been deleted from Chef but not from the vault, add the --clean-unknown-clients switch:

    knife vault rotate keys passwords root --clean-unknown-clients

### rotate all keys

Rotate the shared key for all vaults and items. The shared key is that which is used for the chef encrypted data bag item.

    knife vault rotate all keys

To remove clients which have been deleted from Chef but not from the vault, add the --clean-unknown-clients switch:

    knife vault rotate keys passwords root --clean-unknown-clients

### refresh

This command reads the search_query in the vault item, performs the search, and reapplies the results.

    knife vault refresh VAULT ITEM

To remove clients which have been deleted from Chef but not from the vault, add the --clean-unknown-clients switch:

    knife vault refresh passwords root --clean-unknown-clients

### isvault

This command checks if the given item is a vault or not, and exit with a status of 0 if it is and 1 if it is not.

    knife vault isvault VAULT ITEM

### itemtype

This command outputs the type of the data bag item: normal, encrypted or vault

    knife vault itemtype VAULT ITEM

### global options

Short | Long | Description | Default | Valid Values | Sub-Commands
------|------|-------------|---------|--------------|-------------
-M MODE | --mode MODE | Chef mode to run in. Can be set in knife.rb | solo | solo, client | all
-S SEARCH | --search SEARCH | Chef Server SOLR Search Of Nodes | | | create, remove , update
-A ADMINS | --admins ADMINS | Chef clients or users to be vault admins, can be comma list | | | create, remove, update
-J FILE | --json FILE | JSON file to be used for values, will be merged with VALUES if VALUES is passed | | | create, update
| --file FILE | File that chef-vault should encrypt.  It adds "file-content" & "file-name" keys to the vault item | | | create, update
-p DATA | --print DATA | Print extra vault data | | search, clients, admins, all | show
-F FORMAT | --format FORMAT | Format for decrypted output | summary | summary, json, yaml, pp | show
| --clean-unknown-clients | Remove unknown clients during key rotation | | | refresh, remove, rotate
