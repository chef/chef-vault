Feature: knife vault show [VAULTNAME]
  'knife vault show [VAULTNAME]' displays the keys of a vault
  (i.e. the items that are not suffixed with _keys)

  Scenario: show keys of a vault
    Given a local mode chef repo with nodes 'one,two,three'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three'
    And I create a vault item 'test/item2' containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three'
    Then the vault item 'test/item' should be encrypted for 'one,two,three'
    And 'one,two,three' should be a client for the vault item 'test/item'
    And I show the keys of the vault 'test'
    Then the output should match /(?m:^item$)/
    And the output should match /(?m:^item2$)/
    And the output should not match /(?m:^item_keys$)/
    And the output should not match /(?m:^item2_keys$)/

  Scenario: show keys of a data bag that is not a vault
    Given a local mode chef repo with nodes 'one,two,three'
    And I create a data bag 'notavault' containing the JSON '{"id": "item", "foo": "bar"}'
    And I show the keys of the vault 'notavault'
    Then the output should match /data bag notavault is not a chef-vault/
