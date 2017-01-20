Feature: determine if a data bag item is a vault
  If a data bag item is a vault, 'knife vault isvault VAULTNAME ITEMNAME'
  should exit 0.  Otherwise it should exit 1.

  Scenario: detect vault item
    Given a local mode chef repo with nodes 'one,two,three'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three'
    And I check if the data bag item 'test/item' is a vault
    Then the exit status should be 0

  Scenario: detect vault item with keys in sparse mode
    Given a local mode chef repo with nodes 'one,two,three'
    And I create a vault item 'test/item' with keys in sparse mode containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three'
    And I check if the data bag item 'test/item' is a vault
    Then the exit status should be 0

  Scenario: detect non-vault item (encrypted data bag)
    Given a local mode chef repo with nodes 'one,two,three'
    And I create an empty data bag 'test'
    And I create an encrypted data bag item 'test/item' containing the JSON '{"id": "item", "foo": "bar"}' with the secret 'sekrit'
    And I check if the data bag item 'test/item' is a vault
    Then the exit status should not be 0

  Scenario: detect non-vault item (normal data bag)
    Given a local mode chef repo with nodes 'one,two,three'
    And I create an empty data bag 'test'
    And I create a data bag item 'test/item' containing the JSON '{"id": "item", "foo": "bar"}'
    And I check if the data bag item 'test/item' is a vault
    Then the exit status should not be 0
