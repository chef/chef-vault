Feature: Detect and Warn for v1 Vaults
  chef-vault can read a v1 vault, but the management commands
  tend to break when they try to reference v2 fields like
  clients and admins.  They should detect and warn when trying
  to access a v1 vault

  Scenario: Add search query to v1 vault
    Given a local mode chef repo with nodes 'one,two,three' with admins 'bob'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three'
    Then the vault item 'test/item' should be encrypted for 'one,two,three'
    And 'one,two,three' should be a client for the vault item 'test/item'
    And I downgrade the vault item 'test/item' to v1 syntax
    And I try to add 'bob' as an admin for the vault item 'test/item'
    Then the output should match /cannot manage a v1 vault.  See UPGRADE.md for help/
