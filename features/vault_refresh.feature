Feature: Knife vault refresh

  When refreshing a vault, new clients may be added if they match
  the search query or client list. Old clients that no longer
  exist will never removed with --clean-unknown-clients switch.

  Scenario: Refresh (without 'clean-unknown-clients' option)
    Given a local mode chef repo with nodes 'one,two,three'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three'
    Then the vault item 'test/item' should be encrypted for 'one,two,three'
    And I delete client 'one' from the Chef server
    And I refresh the vault item 'test/item'
    And the vault item 'test/item' should be encrypted for 'one,two,three'
    And 'one,two,three' should be a client for the vault item 'test/item'
