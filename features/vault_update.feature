Feature: knife vault update
  'knife vault update' is used to add clients, or administrators
  and to re-run the search query and update the vault's item values.

  Scenario: add admin to a vault
    Given a local mode chef repo with nodes 'one,two,three' with admins 'alice,bob'
    When I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three' with 'alice' as admin
    Then the vault item 'test/item' should be encrypted for 'one,two,three'
      And 'one,two,three' should be a client for the vault item 'test/item'
      And 'alice' should be an admin for the vault item 'test/item'
      And I can decrypt the vault item 'test/item' as 'alice'
      But I can't decrypt the vault item 'test/item' as 'bob'
      And I can save the JSON object of the encrypted data bag for the vault item 'test/item'
    When I add 'bob' as an admin for the vault item 'test/item'
    Then 'alice,bob' should be an admin for the vault item 'test/item'
      And I can decrypt the vault item 'test/item' as 'alice'
      And I can decrypt the vault item 'test/item' as 'bob'
      And the data bag of the vault item 'test/item' has not been re-encrypted
