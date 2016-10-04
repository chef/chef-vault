Feature: knife vault create with mismatched ID
  'knife vault create' creates a vault.  A JSON file can be passed
  on the command line.  If the vault ID specified on the command line
  does not match the value of the 'id' key in the JSON file, knife
  should throw an error

  Scenario: create vault from JSON file with mismatched ID
    Given a local mode chef repo with nodes 'one,two,three'
    And I create a vault item 'test/item' containing the JSON '{"id": "eyetem"}' encrypted for 'one,two,three'
    Then the output should match /id mismatch - input JSON has id 'eyetem' but vault item has id 'item'/
