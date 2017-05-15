Feature: clean unknown clients on key rotation
  When removing a client from a vault item, chef-vault normally
  removes the key and then rotates the key.  If a node has been
  deleted in the meantime from the Chef server but not the vault,
  the rotation will fail due to that client's public key missing.
  Using the --clean-unknown-clients switch will cause any clients
  that have been removed to be removed from the vault item's
  access list as well

  Scenario: Prune clients when rotating keys
    Given a local mode chef repo with nodes 'one,two,three'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three'
    Then the vault item 'test/item' should be encrypted for 'one,two,three'
    And I delete node 'one' from the Chef server
    And I rotate the keys for vault item 'test/item' with the 'clean-unknown-clients' option
    Then the output should contain "Removing unknown client 'one'"
    And the vault item 'test/item' should be encrypted for 'two,three'
    And the vault item 'test/item' should not be encrypted for 'one'
    And 'two,three' should be a client for the vault item 'test/item'
    And 'one' should not be a client for the vault item 'test/item'

  Scenario: Prune clients when rotating all keys
    Given a local mode chef repo with nodes 'one,two,three'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three'
    Then the vault item 'test/item' should be encrypted for 'one,two,three'
    And I delete nodes 'one,two' from the Chef server
    And I rotate all keys with the 'clean-unknown-clients' option
    Then the output should contain "Removing unknown client 'one'"
    And the output should contain "Removing unknown client 'two'"
    And the vault item 'test/item' should be encrypted for 'three'
    And the vault item 'test/item' should not be encrypted for 'one,two'
    And 'three' should be a client for the vault item 'test/item'
    And 'one,two' should not be a client for the vault item 'test/item'

  Scenario: Prune clients when node gone but client exists
    Given a local mode chef repo with nodes 'one,two,three'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three'
    Then the vault item 'test/item' should be encrypted for 'one,two,three'
    And I delete node 'one' from the Chef server
    And I rotate the keys for vault item 'test/item' with the 'clean-unknown-clients' option
    Then the output should contain "Removing unknown client 'one'"
    And the vault item 'test/item' should be encrypted for 'two,three'
    And the vault item 'test/item' should not be encrypted for 'one'
    And 'two,three' should be a client for the vault item 'test/item'
    And 'one' should not be a client for the vault item 'test/item'
