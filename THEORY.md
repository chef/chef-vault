# How chef-vault works

## The Problem

Chef provides [encrypted data bags](https://docs.chef.io/chef/essentials_data_bags.html)
as part of the core software, but leaves the problem of key
distribution up to end users.  Encrypted data bags are
symmetrically encrypted, and so you have to distribute the
decryption key out-of-band to your nodes (e.g. baking it into
your image or pushing it to the system before running
chef-client).

## The Solution

Every node managed by chef has an associated client object
on the Chef Server.  The client object has the public half of
an RSA keypair.  The private half only lives on the node,
typically in `/etc/chef/client.pem`.

Every API user on the chef server also has an RSA keypair.
This is typically kept in your `~/.chef` directory in PEM
format.  Like nodes, the public half is stored on the Chef
server.

chef-vault creates an encrypted data bag which is symmetrically
encrypted using a random secret (a 32-byte string generated
using [SecureRandom.random_bytes](http://ruby-doc.org/stdlib-2.1.2/libdoc/securerandom/rdoc/SecureRandom.html#method-c-random_bytes)).  We'll refer to this secret as the 'shared secret' through
the rest of this document.

A vault has a list of administrative users and a list of
clients.  The shared secret is asymmetrically encrypted
for each of the administrators and clients using their public
key (a separate copy for each).

The administrators of a vault are API users named explicitly
when the vault is created.  The clients can be provided
explicitly, but are more often determined by running a SOLR
query against the Chef server.  The query is stored as part
of the \_keys data bag so that the clients can be updated by
re-executing the search.

The asymmmetrically encrypted keys are stored in a second
data bag item whose name is appended with \_keys

## Data Bag Structure

These examples assume that I have two nodes in my Chef
server/organization, named 'one' and 'two'.  I also have
two administrators named 'alice' and 'bob'.

Given a file named `item.json` containing the following:

```json
{ "foo": "bar" }
```

Running

    > knife vault create foo bar -A alice,bob -S '*:*' -J item.json

will create a data bag named 'foo' and two data bag items
within named 'bar' and 'bar_keys':

    > knife data bag show foo
    bar
    bar_keys

The 'bar' item contains the symmetrically encrypted version
of the JSON data:

    > knife data bag show -F json foo bar
    {
      "id": "bar",
      "foo": {
        "encrypted_data": "k9On2aJxnLDRwOeCr60l0C41XjIJ2+5Xu0AYFbmSvFw=\n",
        "iv": "oKeiEkIlaspvhKghee30GA==\n",
        "version": 1,
        "cipher": "aes-256-cbc"
      }
    }

(this is a standard Chef encrypted data bag)

The 'bar_keys' item contains four copies of the asymetrically
encrypted shared secret:

    > knife data bag show -F json foo bar_keys
    {
      "id": "bar_keys",
      "admins": [
        "alice",
        "bob"
      ],
      "clients": [
        "one",
        "two"
      ],
      "search_query": "*:*",
      "alice": "MW7hOvoc7XvYHJbbm0gWAaLNbVcHnxv5YDMnYsjiK/F1qxnFrY4X8pTwzgUI\nRsZuREpEpCSWY9C23ESolTHnBtgEHkR6Xe74NFUr9OURiAGljZL9zEzVUFJu\npds8pWjgGnqpwULxiPZT96xKEw+BnMy0ipYChdF2iaJtQzVAlIzXZoPaOXeH\nJPd1dwmD/G0X2nK0+cNEnJGUP6gideMun3S+dTN9rpP0/7bInjNRPAAXV5yY\nKNRBFgtFyG828B9uXXJ8wXaYYOzp7VLK4ehJw25g5VNkMttqNQVWyIbxGirf\nuvys/PTlCXzLkJ3+e0X5q4ZSotQ+1zJ5UVs16VOChQ==\n",
      "bob": "h9qvmFyR3ygYUQgoW42ABIeCov16cSyYFlj9wKrscLFDzhs0jRrFRdvpcBBl\nqU3Glk79Y898L3C4+/EYomi2I7/EuxZozP+wgeTJDIcXQdeZwEWxGzY1JZq2\nxZYezdoWKATysAtPJEtNIPRzOGiloq+QanHDrxq3JVvZrJ/L5fE0eyV0Nh3T\nbX4X0KzZ4LzeGeUCXXOVa9C2rEHpf61PsMF79iAnULDpD++YdxDGHv6KgHJS\nVENHvyIWi4erRGrcwZRq709iB1BRm/14Zb9ZzZT/HcHIw5P47Ht0wgZ8x71V\nbhAjK410AWG9QtefDf6ybD/ERkKgVjeqcZ57TysdvQ==\n",
      "one": "Ugwpeq2du2RqEzAcn1GA+Uj+dW9fHq7+coCT4LWD2CLo9og9Qu7MSkwuZXaj\nZngl31skSCyvE15ZVhhXilkwmJmrOoEU0B5FlbZTzjHxlq/ga2MhemXmASAH\nyu39if2fb++sE/g5RLy1A9EQs7oeVY53BLZCtENA5XHGjMA1WoBi1PfQTpUs\nZZKW604vs4i/zw88j1Np5o7xb77Wt7zZQsRS+uLxp7qWOTPaT85usChk5ygS\nFrPNZF/F95ODe74o6qwxAtQhKroEeUV6GSWCB2M9FTIoGH+Fhj7oDSiLT1AA\n4VqF4mCMuVMeAM2GTx5IvdIYja2GV7DbomTBNYsGiA==\n",
      "two": "yO6eaCnDmNnQP5d1h1LxZyQdHhYh0BvhBhauVBv8RXWuyuY/8qC7iREPlN52\nRFCr38BStHO9/D4m+uv6SnJhKREe99eOtpddSXD92K/I4bMSCszC+/TmaZWj\nNibZonivam1SuutMbh6WPlHT6/yjIXb1w0cXxple5R+WmPttuMj13V0at0wY\nWMg4JC5/PpYoX8qfmUKvcrVxqFdbQ0YlgAzzdJwzWJOpN+ZEfiFSJopREt6L\n2wSkWezHylGmIWuGLmANSCdluk0oaEVyA1Panf8HL87tWlEc+BajY53JZxY1\n3YIZNWpelU6W/Nl8zu8R206ksKNNMk0yuhd++7F+yw==\n"
    }

It also contains the list of administrators and clients for
which the key is encrypted and the query used to choose which
clients can decrypt the vault.

In practice, the search query would not be `*:*`.  More common
practice is to select which nodes can decrypt the vault based
on characteristics like:

* which recipes are in the node's runlist
* which chef environment the node belongs to
* what OS or platform the node runs
* attributes collected by Ohai Plugins (such as AWS tags).

While there are four copies of the shared secret, any single
user or node will only be able to decrypt one of the copies,
because no user or node (should) have more than one private key.

Likewise, a node or user for whom the vault was not encrypted
is able to see the contents of the 'bar_keys' data bag,
but since they lack a private key that can decrypt any of the
copies of the shared secret, they cannot access the 'bar' encrypted
data bag item.

As alice or bob, I can show the contents of the vault:

    > knife vault show -F json foo bar
    {
      "id": "bar",
      "foo": "bar"
    }

Or in a recipe that runs on node one or two:

    vaultitem = ChefVault::Item.load('foo', 'bar')
    Chef::Log.debug "the vault value foo is #{vaultitem['foo']}"

## Use Cases

In these use cases, assume there are three API clients:

* alice (Administrator)
* bob (Administrator)
* charlie (Normal User)

And three nodes, of the given platform:

* one (Linux, Ubuntu)
* two (Linux, CentOS)
* three (Windows)

The use cases are written from the perspective of 'client'
mode using a Chef server, but work similarly in 'solo' mode
assuming that the commands are run from the directory containing
the Chef repository.

We also assume that the commands are being run from a Linux
terminal session (paths to key files are slightly different
on Windows)

### Creating a Vault

The actor in this case is alice.  When she runs

    knife vault create foo bar -S os:linux -A alice,bob

After editing the empty JSON document and saving it, chef-vault
generates a random 32 byte string for the shared secret.

A new data bag named 'foo/bar_keys' is created.  chef-vault then
executes the search 'os:linux' against the node index.

For each of the nodes returned from the search (one and two), the
public keys are fetched for the like-named client and the shared
secret is encrypted using it.  The client name is added to the
'clients' array in the bar_keys data bag item.  The node-specific
encrypted copy of the shared secret is stored in the bar_keys
data bag item, keyed by node name.

The search query is also stored in the keys data bag, for use
during future update or refresh operations.

In a similar fashion, the public keys for alice and bob are
retrieved from the Chef server and the shared secret is
asymmetrically encrypted for each.  The names of the admins are
stored in the 'admins' array in the bar_keys data bag item.

At this point, the bar_keys data bag item is only present in
memory.  It is saved to the server, and if that operation fails
the vault create throws an error.

The data bag 'foo' is then fetched (or created if it does
not already exist).  An encrypted data bag item named 'bar'
is created, encrypted with the shared secret.  The data bag
item is saved to the Chef server.

### Decrypting a Vault using knife

The actor in this case is alice.  When she runs

    knife vault show foo bar

chef-vault fetches the data bag item foo/bar_keys.  It
then looks for a key in the data bag named 'alice'.  The value
of this key is the asymmetrically encrypted copy of the shared
secret specific to alice.

chef-vault then uses alice's private key (typically `~/.chef/alice.pem`) to decrypt the shared secret.

If the \_keys data bag did not have a key 'alice', chef-vault
would have emitted an error to the effect that the vault was not
encrypted for her and that someone else who does have access to
the bag needs to add her as an administrator before she can view
it.

Using the decrypted shared secret, chef-vault loads the Chef
encrypted data bag foo/bar.  The plaintext contents of this bag
are then displayed to alice.  If the appropriate options are
provided on the command line, additional information such as
the list of administrators, the list of clients and the search
query (all of which are stored in the bar_keys data bag item)
are also displayed.

### Decrypting a Vault in a Chef Recipe

The actor in this case is chef-client (running as root) on
the server 'one'.

Assuming that the recipe contains code such as this:

    chef_gem 'chef-vault' do
      compile_time true if respond_to?(:compile_time)
    end
    require 'chef-vault'
    vaultitem = ChefVault::Item.load('foo', 'bar')

chef-vault fetches the data bag item foo/bar_keys.  It
then looks for a key in the data bag named 'one'.  The value
of this key is the asymetrically encrypted copy of the shared
secret specific to the node 'one'.

chef-vault then uses the private key of node one (typically
`/etc/chef/client.pem`) to decrypt the shared secret.

If the \_keys data bag did not have a key 'one', chef-vault
would have thrown an exception indicating that the vault was
not encrypted for the node and that an administrator needs to
refresh the vault (possibly after updating the search query)
before the recipe can use the vault.

Uncaught, this would cause chef-client to abort in the compile
phase.  Robust recipes can be written that catch the exception
and do other things, such as only converging resources that do
not need the secrets, or sending an alert so that a human can
update the vault, or even sending a request to a work queue
to automatically update the vault.

Using the decrypted shared secret, chef-vault loads the Chef
encrypted data bag foo/bar.  The plaintext contents of this bag
are now available to the recipe in the local variable named
'vaultitem'.  At this point the data looks and feels like a
normal data bag (i.e. it behaves in a hash-like way)

### Adding a new Administrator

The actor in this case is Alice, who wants to make charlie
an administrator of the vault.  We assume she is working with
the vault created in the section 'Creating a Vault'.  When she
runs

    knife vault update -A charlie foo bar

This vault is decrypted in the same fashion as described
in 'Decrypting a Vault using knife'.  This results in the
plain text of the shared secret being available in memory.

The search query is run again, returning the same two nodes.
The shared secret is then asymmetrically encrypted for each
as described in 'Creating a Vault'.

The shared secret is then asymmetrically encrypted for all
of the admins (alice, bob and the newly-added charlie) as
described in 'Creating a Vault'.

The data bag item 'foo/bar_keys' is then saved, followed by the
data bag item 'foo/bar'.

charlie can now view the contents of the vault using `knife
vault show` because there is a now a copy of the shared
secret that he can access.

### Adding a new Node

The actor in this case is Alice, who wants to encrypt the
value for all nodes instead of just those running linux.
When she runs

    knife vault update -S '*:*' foo bar

This vault is decrypted in the same fashion as described
in 'Decrypting a Vault using knife'.  This results in the
plain text of the shared secret being available in memory.

The search query is run again, returning three nodes this
time: one, two and three.  The shared secret is then
asymmetrically encrypted for each as described in 'Creating
a Vault'.

The data bag item 'foo/bar_keys' is then saved, followed by the
data bag item 'foo/bar'.

Node three can now use the vault in a recipe because
there is a now a copy of the shared secret that he it access.

### Rotating Keys

Rotating keys chooses a new shared secret for the bag and
encrypts it for all of the administrators and clients
who currently have access.  Unlike the `knife vault update`
command, the search query is not re-run to pick up new clients.

The actor in this case is Alice, who wants to rotate the keys
(perhaps to conform to an internal security policy).  When
she runs

    knife vault rotate_keys foo bar

The vault is decrypted in the same fashion as described
in 'Decrypting a Vault using knife'.

chef-vault generates a new 32-byte random string.  It then
creates an asymmetrically encrypted version of the new
shared secret for each of the clients and administrators
listed in the data bag item 'foo/bar_keys'.

The data bag item 'foo/bar_keys' is then saved, followed by the
data bag item 'foo/bar'.

## Failure Scenarios

Because the secret data is just a normal Chef encrypted
data bag item, the keys are stored separately in a data bag
suffixed with \_keys.  When the vault is saved, the data bag
item containing the keys is saved before the encrypted data
bag is.

If the key data bag item save succeeds, but the vault data bag
item fails, the vault will be in an unsable state, because
it will be encrypted with the old shared secret, but the keys
data bag item contains asymmetrically encrypted copies of the
new shared secret.

This can be mitigated by using solo mode, which writes the
encrypted data bags to JSON files on disk rather than making
changes using the Chef Server API.  Another option is to use
`knife download` to temporarily store a on-disk version of the
vault data bag item and the keys data bag item before making
changes.  If any probems are encountered, the old copy of
the data bags can be loaded back into the Chef server using
`knife data bag from file`.
