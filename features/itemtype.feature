Feature: determine the type of a data bag item
  'knife vault itemtype VAULTNAME ITEMNAME' should output one of
  'normal', 'encrypted', or 'vault' depending on what type of item
  it detects

  Scenario: detect vault item
    Given a local mode chef repo with nodes 'one,two,three'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three'
    And I check the type of the data bag item 'test/item'
    Then the output should match /^vault$/

  Scenario: detect non-vault item (encrypted data bag)
    Given a local mode chef repo with nodes 'one,two,three'
    And I create an empty data bag 'test'
    And I create an encrypted data bag item 'test/item' containing the JSON '{"id": "item", "foo": "bar"}' with the secret 'sekrit'
    And I check the type of the data bag item 'test/item'
    Then the output should match /^encrypted$/

  Scenario: detect non-vault item (normal data bag)
    Given a local mode chef repo with nodes 'one,two,three'
    And I create an empty data bag 'test'
    And I create a data bag item 'test/item' containing the JSON '{"id": "item", "foo": "bar"}'
    And I check the type of the data bag item 'test/item'
    Then the output should match /^normal$/
