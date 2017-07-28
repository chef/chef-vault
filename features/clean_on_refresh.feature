Feature: clean unknown clients on vault refresh
  When refreshing a vault, new clients may be added if they match
  the search query or client list, but old clients that no longer
  exist will never be removed.  The --clean-unknown-clients switch
  will cause cause any unknown clients to be removed from the vault
  item's access list as well

  Scenario: Refresh without clean option
    Given a local mode chef repo with nodes 'one,two,three'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three'
    Then the vault item 'test/item' should be encrypted for 'one,two,three'
    And I delete node 'one' from the Chef server
    And I refresh the vault item 'test/item'
    And the vault item 'test/item' should be encrypted for 'one,two,three'
    And 'one,two,three' should be a client for the vault item 'test/item'

  Scenario: Refresh with clean option
    Given a local mode chef repo with nodes 'one,two,three'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three'
    Then the vault item 'test/item' should be encrypted for 'one,two,three'
    And I delete node 'one' from the Chef server
    And I refresh the vault item 'test/item' with the 'clean-unknown-clients' option
    Then the output should contain "Removing unknown client 'one'"
    And the vault item 'test/item' should be encrypted for 'two,three'
    And the vault item 'test/item' should not be encrypted for 'one'
    And 'two,three' should be a client for the vault item 'test/item'
    And 'one' should not be a client for the vault item 'test/item'
