Feature: clean client keys
  When updating a vault item, chef-vault normally performs the
  saved or specified query and encrypts the item for all nodes
  returned.  It does not remove old client keys from the vault
  item keys data bag, which will grow over time.  Using the
  --clean switch will cause all client keys to be removed from
  the data bag before encrypting the item for all clients
  returned by the query

  Scenario: Do not clean client keys on update
    Given a local mode chef repo with nodes 'one,two,three'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two'
    Then the vault item 'test/item' should be encrypted for 'one,two'
    And I update the vault item 'test/item' to be encrypted for 'two,three'
    Then the vault item 'test/item' should be encrypted for 'one,two,three'

  Scenario: Clean client keys on update
    Given a local mode chef repo with nodes 'one,two,three'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two'
    Then the vault item 'test/item' should be encrypted for 'one,two'
    And I update the vault item 'test/item' to be encrypted for 'two,three' with the clean option
    Then the vault item 'test/item' should be encrypted for 'two,three'
    And the vault item 'test/item' should not be encrypted for 'one'
