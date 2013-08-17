# knife examples

## encrypt
knife encrypt [create|add|remove] [VAULT] [ITEM] [VALUES]

These are the commands that are used to take data in json format and encrypt that data into chef-vault style encrypted data bags in chef.

* Vault - This is the name of the vault in which to store the encrypted item.  This is analogous to a chef data bag name
* Item - The name of the item going in to the vault.  This is analogous to a chef data bag item id
* Values - This is the json clear text data to be stored in the vault encrypted.  This is analogous to a chef data bag item data

Note: For backwards compatibility the chef-vault 1.x style commands of `knife encrypt cert` and `knife encrypt password` are supported.  They are depricated however and should be moved to the new chef-vault 2.x style commands.

### create
Creat a vault called passwords and put an item called root in it with the given values for username and password encrypted for no one, probably shouldn't do this one.

    knife encrypt create passwords root "{username: 'root', password: 'mypassword'}"

Creat a vault called passwords and put an item called root in it with the given values for username and password encrypted for clients name:* and admins admin1 & admin2

    knife encrypt create passwords root "{username: 'root', password: 'mypassword'}" -S "name:*" -A "admin1,admin2"

Creat a vault called passwords and put an item called root in it with the given values for username and password encrypted for clients name:*

    knife encrypt create passwords root "{username: 'root', password: 'mypassword'}" -S "name:*"

Creat a vault called passwords and put an item called root in it with the given values for username and password encrypted for admins admin1 & admin2

    knife encrypt create passwords root "{username: 'root', password: 'mypassword'}" -A "admin1,admin2"    

Creat a vault called passwords and put an empty item called root in it encrypted for clients name:* and admins admin1 & admin2

    knife encrypt create passwords root -S "name:*" -A "admin1,admin2"

Creat a vault called passwords and put an empty item called root in it encrypted for admins admin1 & admin2

    knife encrypt create passwords root -A "admin1,admin2"

Creat a vault called passwords and put an empty item called root in it encrypted for clients name:*

    knife encrypt create passwords root -S "name:*" -A "admin1,admin2"

### add
Add the values in username and password to the vault passwords and item root.  Will overwrite existing values if values already exist!

    knife encrypt add passwords root "{username: 'root', password: 'mypassword'}"

Add the values in username and password to the vault passwords and item root and add admin1 & admin2 to the encrypted admins.  Will overwrite existing values if values already exist!

    knife encrypt add passwords root "{username: 'root', password: 'mypassword'}" -A "admin1,admin2"

Add the values in username and password to the vault passwords and item root and add name:* to the encrypted clients.  Will overwrite existing values if values already exist!

    knife encrypt add passwords root "{username: 'root', password: 'mypassword'}" -S "name:*"

Add the values in username and password to the vault passwords and item root and add name:* to the encrypted clients and admin1 & admin2 to the encrypted admins.  Will overwrite existing values if values already exist!

    knife encrypt add passwords root "{username: 'root', password: 'mypassword'}" -S "name:*" -A "admin1,admin2"

Add admin1 & admin2 to encrypted admins for the vault passwords and item root.

    knife encrypt add passwords root -A "admin1,admin2"

Add name:* to encrypted clients for the vault passwords and item root.

    knife encrypt add passwords root -S "name:*"

Add admin1 & admin2 to encrypted admins and name:* to encrypted clients for the vault passwords and item root.

    knife encrypt add passwords root -S "name:*" -A "admin1,admin2"

### remove
Remove the values in username and password from the vault passwords and item root.

    knife encrypt remove passwords root "{username: 'root', password: 'mypassword'}"

Remove the values in username and password from the vault passwords and item root and remove admin1 & admin2 from the encrypted admins.

    knife encrypt remove passwords root "{username: 'root', password: 'mypassword'}" -A "admin1,admin2"

Remove the values in username and password from the vault passwords and item root and remove name:* from the encrypted clients.

    knife encrypt remove passwords root "{username: 'root', password: 'mypassword'}" -S "name:*"

Remove the values in username and password from the vault passwords and item root and remove name:* from the encrypted clients and admin1 & admin2 from the encrypted admins.

    knife encrypt remove passwords root "{username: 'root', password: 'mypassword'}" -S "name:*" -A "admin1,admin2"

Remove admin1 & admin2 from encrypted admins for the vault passwords and item root.

    knife encrypt remove passwords root -A "admin1,admin2"

Remove name:* from encrypted clients for the vault passwords and item root.

    knife encrypt remove passwords root -S "name:*"

Remove admin1 & admin2 from encrypted admins and name:* from encrypted clients for the vault passwords and item root.

    knife encrypt remove passwords root -S "name:*" -A "admin1,admin2"

### rotate secret
Rotate the shared secret for the vault passwords and item root.  The shared secret is that which is used for the chef encrypted data bag item

    knife encrypt rotate secret passwords root

### global options
<table>
  <tr>
    <th>Short</th>
    <th>Long</th>
    <th>Description</th>
    <th>Default</th>
    <th>Valid Values</th>
  </tr>
  <tr>
    <td>-S SEARCH</td>
    <td>--search SEARCH</td>
    <td>Chef Server SOLR Search Of Nodes</td>
    <td>nil</td>
    <td></td>
  </tr>
  <tr>
    <td>-A ADMINS</td>
    <td>--admins ADMINS</td>
    <td>Chef clients or users to be vault admins, can be comma list</td>
    <td>nil</td>
    <td></td>
  </tr>
  <tr>
    <td>-M MODE</td>
    <td>--mode MODE</td>
    <td>Chef mode to run in</td>
    <td>solo</td>
    <td>"solo", "client"</td>
  </tr>
  <tr>
    <td>-J FILE</td>
    <td>--json FILE</td>
    <td>json file to be used for values, VALUES will be ignored when used</td>
    <td>nil</td>
    <td></td>
  </tr>
</table>

## decrypt
knife decrypt [VAULT] [ITEM] [VALUES]

These are the commands that are used to take a chef-vault encrypted item and decrypt the requested values.

* Vault - This is the name of the vault in which to store the encrypted item.  This is analogous to a chef data bag name
* Item - The name of the item going in to the vault.  This is analogous to a chef data bag item id
* Values - This is a comma list of values to decrypt from the vault item.  This is analogous to a list of hash keys.

Note: For backwards compatibility the chef-vault 1.x style commands of `knife decrypt cert` and `knife decrypt password` are supported.  They are depricated however and should be moved to the new chef-vault 2.x style commands.

Decrypt the username and password for the item root in the vault passwords.

    knife decrypt passwords root "username, password"

Decrypt the contents for the item user_pem in the vault certs.

    knife decrypt certs user_pem "contents"

### global options
<table>
  <tr>
    <th>Short</th>
    <th>Long</th>
    <th>Description</th>
    <th>Default</th>
    <th>Valid Values</th>
  </tr>
  <tr>
    <td>-M MODE</td>
    <td>--mode MODE</td>
    <td>Chef mode to run in</td>
    <td>solo</td>
    <td>"solo", "client"</td>
  </tr>
</table>
