Feature: knife vault show
  'knife vault show' displays the contents of a Chef encrypted
  data bag by fetching the asymmetrically encrypted shared
  secret and decrypting it using the private key of the user
  or node

  Scenario: successful decrypt as admin
    Given a local mode chef repo with nodes 'one,two,three' with admins 'alice,bob'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three' with 'alice' as admin
    Then the vault item 'test/item' should be encrypted for 'one,two,three,alice'
    And 'one,two,three' should be a client for the vault item 'test/item'
    And 'alice' should be an admin for the vault item 'test/item'
    And 'bob' should not be an admin for the vault item 'test/item'
    And I can decrypt the vault item 'test/item' as 'alice'
    And the output should match /^foo: bar$/

  Scenario: successful decrypt as admin using client_key_contents
    Given a local mode chef repo with nodes 'one,two,three' with admins 'alice,bob'
    Given I create client config for client named 'alice'
    Given I create mismatched client config for client named 'bob'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three' with 'alice,bob' as admins
    Then the vault item 'test/item' should be encrypted for 'alice,bob'
    And 'one,two,three' should be a client for the vault item 'test/item'
    And 'alice' should be an admin for the vault item 'test/item'
    And 'bob' should be an admin for the vault item 'test/item'
    And I can decrypt the vault item 'test/item' as 'alice' using client config
    And I can decrypt the vault item 'test/item' as 'bob' using client config
    And the output should match /^foo: bar$/

  Scenario: successful decrypt as node
    Given a local mode chef repo with nodes 'one,two,three' with admins 'alice,bob'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three' with 'alice' as admin
    Then the vault item 'test/item' should be encrypted for 'one,two,three,alice'
    And 'one,two,three' should be a client for the vault item 'test/item'
    And 'alice' should be an admin for the vault item 'test/item'
    And 'bob' should not be an admin for the vault item 'test/item'
    And I can decrypt the vault item 'test/item' as 'two'
    And the output should match /^foo: bar$/

  Scenario: failed decrypt as admin
    Given a local mode chef repo with nodes 'one,two,three' with admins 'alice,bob'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three' with 'alice' as admin
    Then the vault item 'test/item' should be encrypted for 'one,two,three,alice'
    And 'one,two,three' should be a client for the vault item 'test/item'
    And 'alice' should be an admin for the vault item 'test/item'
    And 'bob' should not be an admin for the vault item 'test/item'
    And I can't decrypt the vault item 'test/item' as 'bob'
    And the output should contain "test/item is not encrypted with your public key"

  Scenario: failed decrypt as node
    Given a local mode chef repo with nodes 'one,two,three' with admins 'alice,bob'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two' with 'alice' as admin
    Then the vault item 'test/item' should be encrypted for 'one,two,alice'
    And 'one,two' should be a client for the vault item 'test/item'
    And 'alice' should be an admin for the vault item 'test/item'
    And 'bob' should not be an admin for the vault item 'test/item'
    And I can't decrypt the vault item 'test/item' as 'three'
    And the output should contain "test/item is not encrypted with your public key"
