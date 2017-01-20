Feature: knife vault create
  'knife vault create' creates two Chef data bag items: an
  encrypted data bag item encrypted with a randomized shared
  secret, and a side-along data bag item suffixed with _keys
  that contains an set of asymmetrically encrypted copies of
  the shared secret using the public keys of a set of admins
  and/or clients

  Scenario: create vault with all known clients
    Given a local mode chef repo with nodes 'one,two,three'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three'
    Then the vault item 'test/item' should be encrypted for 'one,two,three'
    And 'one,two,three' should be a client for the vault item 'test/item'

  Scenario: create vault with all unknown clients
    Given a local mode chef repo with nodes 'two,three'
    And I delete clients 'two,three' from the Chef server
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'two,three'
    Then the vault item 'test/item' should not be encrypted for 'one,two,three'
    And the output should contain "node 'two' has no private key; skipping"
    And the output should contain "node 'three' has no private key; skipping"
    And 'two,three' should not be a client for the vault item 'test/item'

  Scenario: create vault with mix of known and unknown clients
    Given a local mode chef repo with nodes 'one,two,three'
    And I delete client 'three' from the Chef server
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three'
    Then the vault item 'test/item' should be encrypted for 'one,two'
    And the output should contain "node 'three' has no private key; skipping"
    And 'one,two' should be a client for the vault item 'test/item'
    And 'three' should not be a client for the vault item 'test/item'

  Scenario: create vault with mix of known and unknown nodes
    Given a local mode chef repo with nodes 'one,two'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three'
    Then the vault item 'test/item' should be encrypted for 'one,two'
    And 'one,two' should be a client for the vault item 'test/item'
    And 'three' should not be a client for the vault item 'test/item'

  Scenario: create vault with several admins
    Given a local mode chef repo with nodes 'one,two' with admins 'alice,bob'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three' with 'alice' as admin
    Then the vault item 'test/item' should be encrypted for 'one,two'
    And 'one,two' should be a client for the vault item 'test/item'
    And 'three' should not be a client for the vault item 'test/item'
    And 'alice' should be an admin for the vault item 'test/item'
    And 'bob' should not be an admin for the vault item 'test/item'

  Scenario: create vault with several admins in sparse mode
    Given a local mode chef repo with nodes 'one,two' with admins 'alice,bob'
    And I create a vault item 'test/item' with keys in sparse mode containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three' with 'alice' as admin
    Then the vault item 'test/item' should be encrypted for 'one,two' with keys in sparse mode
    And the vault item 'test/item' should not be encrypted for 'three' with keys in sparse mode
    And 'one,two' should be a client for the vault item 'test/item'
    And 'three' should not be a client for the vault item 'test/item'
    And 'alice' should be an admin for the vault item 'test/item'
    And 'bob' should not be an admin for the vault item 'test/item'

  Scenario: create vault with an unknown admin
    Given a local mode chef repo with nodes 'one,two'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three' with 'alice' as admin
    Then the exit status should not be 0
    And the output should contain "FATAL: Could not find default key for alice in users or clients!"
