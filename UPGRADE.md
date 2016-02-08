# UPGRADING A v1 VAULT to v2

chef-vault v2 added metadata to the vault to keep track of
which secrets belong to clients and which belong to admins,
as well as the search query to use during a `knife vault refresh`
operation.

You can use chef-vault v2 to decrypt v1 vaults, but the management
operations are unable to intuit which of the secrets belong to
clients and which belong to admins.  Fixing this error thus requires
some manual intervention.

If you attempt to use the management operations (refresh, update, etc.)
on a v1 vault, you will get this error:

    ChefVault::Exceptions::V1Format: cannot manage a v1 vault.  See UPGRADE.md for help

To fix this, you need to edit the data bag item by hand.   Assuming a
vault 'foo' with an item 'bar', run:

    knife data bag edit foo bar_keys

This will present you with a JSON representation of the extra data
bag item managed by chef-vault.  It will have an id key as well as a key
for every user for whom the vault item is encrypted:

    {
      "id" : "bar_keys",
      "james" : "iWdGgm...\n",
      "one" : "RjJ4rlh....\n",
      "two" : "NHJlqnfd9...\n",
      "three" : "GjXkrxq...\n"
    }

Add keys for 'admins', 'clients' and 'search_query':

    {
      "id" : "bar_keys",
      "james" : "iWdGgm...\n",
      "one" : "RjJ4rlh....\n",
      "two" : "NHJlqnfd9...\n",
      "three" : "GjXkrxq...\n",
      "admins": [],
      "clients": [],
      "search_query": ""
    }

Save the edited data bag and run knife vault update with the appropriate values to populate those keys:

    knife vault update foo bar -S 'name:*' -A james

(set your search query to something appropriate for your environment)

v2.7.0 of chef-vault may add some automation to this step, but for now this
provides a way to upgrade without breaking your ability to manage things.
