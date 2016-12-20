Feature: list data bags that are vaults
  knife vault list should list all data bags that appear to
  be vaults.  This is not an exact science; we assume that
  any data bag containing an even number of items and for
  which all items are pairs of thing/thing_keys is a vault

  Scenario: List bags that are vaults
    Given a local mode chef repo with nodes 'one,two,three'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three'
    And I list the vaults
    Then the output should match /(?m:^test$)/

  Scenario: List bags that are vaults with keys in sparse mode
    Given a local mode chef repo with nodes 'one,two,three'
    And I create a vault item 'test/item' with keys in sparse mode containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three'
    And I list the vaults
    Then the output should match /(?m:^test$)/

  Scenario: Skip data bags that are not vaults
    Given a local mode chef repo with nodes 'one,two,three'
    And I create a vault item 'test/item' containing the JSON '{"foo": "bar"}' encrypted for 'one,two,three'
    And I create a data bag 'lessthantwokeys' containing the JSON '{"id": "item", "foo": "bar"}'
    And I create a data bag 'oddnumberofkeys' containing the JSON '{"id": "item", "one": 1, "two": 2, "three":3}'
    And I create a data bag 'unbalanced' containing the JSON '{"id": "item", "one": 1, "one_keys": 1, "two_keys": 1, "three_keys": 1}'
    And I create a data bag 'mismatched' containing the JSON '{"id": "item", "one": 1, "one_keys": 1, "two_keys": 1, "three": 1}'
    And I list the vaults
    Then the output should match /(?m:^test$)/
    And the output should not match /(?m:^lessthantwokeys$)/
    And the output should not match /(?m:^oddnumberofkeys$)/
    And the output should not match /(?m:^unbalanced$)/
    And the output should not match /(?m:^mismatched$)/
