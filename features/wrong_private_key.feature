Feature: Wrong private key during decrypt
  https://github.com/Nordstrom/chef-vault/issues/43
  If a vault is encrypted for a node and then the node's private
  key is regenerated, the error that comes back from chef-vault
  should be informative, not a lower-level error from OpenSSL
  like 'OpenSSL::PKey::RSAError: padding check failed'

  Scenario: Regenerate node key and attempt decrypt
    Given a local mode chef repo with nodes 'one,two'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two'
    And I regenerate the client key for the node 'one'
    And I try to decrypt the vault item 'test/item' as 'one'
    Then the output should match /is encrypted for you, but your private key failed to decrypt the contents/
