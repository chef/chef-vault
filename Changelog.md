# Change Log

## [v3.0.0](https://github.com/chef/chef-vault/tree/v3.0.0) (2017-04-10)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.9.1...v3.0.0)

**Implemented enhancements:**

- Vault creation, list, and destruction in sparse mode [\#252](https://github.com/chef/chef-vault/pull/252) ([rveznaver](https://github.com/rveznaver))

## [v3.0.0.rc2](https://github.com/chef/chef-vault/tree/v3.0.0.rc2) (2016-12-05)
[Full Changelog](https://github.com/chef/chef-vault/compare/v3.0.0.rc1...v3.0.0.rc2)

**Implemented enhancements:**

- Add feature to save each key in different data bag item [\#246](https://github.com/chef/chef-vault/pull/246) ([rveznaver](https://github.com/rveznaver))
- Enable testing with Chef Zero [\#244](https://github.com/chef/chef-vault/pull/244) ([rveznaver](https://github.com/rveznaver))
- Minimize the number of searches [\#243](https://github.com/chef/chef-vault/pull/243) ([thommay](https://github.com/thommay))
- Optimise queries when finding nodes [\#240](https://github.com/chef/chef-vault/pull/240) ([thommay](https://github.com/thommay))

**Fixed bugs:**

- Use solo\_legacy\_mode fully [\#242](https://github.com/chef/chef-vault/pull/242) ([thommay](https://github.com/thommay))
- Use legacy solo mode [\#241](https://github.com/chef/chef-vault/pull/241) ([thommay](https://github.com/thommay))

## [v3.0.0.rc1](https://github.com/chef/chef-vault/tree/v3.0.0.rc1) (2016-10-21)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.9.0...v3.0.0.rc1)

**Implemented enhancements:**

- Removed deprecated knife commands [\#236](https://github.com/chef/chef-vault/pull/236) ([thommay](https://github.com/thommay))
- rename ChefKey to Actor [\#234](https://github.com/chef/chef-vault/pull/234) ([thommay](https://github.com/thommay))
- Move to using a logger for all user output [\#232](https://github.com/chef/chef-vault/pull/232) ([thommay](https://github.com/thommay))
- Add support for clients [\#227](https://github.com/chef/chef-vault/pull/227) ([svanharmelen](https://github.com/svanharmelen))

## [v2.9.0](https://github.com/chef/chef-vault/tree/v2.9.0) (2016-04-08)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.8.0...v2.9.0)

**Implemented enhancements:**

- Feature - knife vault update - update item\_keys only when no value is provided [\#202](https://github.com/chef/chef-vault/pull/202) ([xakraz](https://github.com/xakraz))

**Fixed bugs:**

- knife vault refresh always updates the data bag item [\#193](https://github.com/chef/chef-vault/issues/193)
- Correct vault creation in solo mode [\#206](https://github.com/chef/chef-vault/pull/206) ([kamaradclimber](https://github.com/kamaradclimber))
- Only save keys on refresh operation [\#194](https://github.com/chef/chef-vault/pull/194) ([kamaradclimber](https://github.com/kamaradclimber))

## [v2.8.0](https://github.com/chef/chef-vault/tree/v2.8.0) (2016-02-09)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.8.0.rc1...v2.8.0)

**Merged pull requests:**

- UPGRADE: fixed a typo [\#198](https://github.com/chef/chef-vault/pull/198) ([joonas](https://github.com/joonas))
- adds link to Chef Vault blog post to README [\#197](https://github.com/chef/chef-vault/pull/197) ([nellshamrell](https://github.com/nellshamrell))

## [v2.8.0.rc1](https://github.com/chef/chef-vault/tree/v2.8.0.rc1) (2016-01-29)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.7.1...v2.8.0.rc1)

**Merged pull requests:**

- Deal with more than 1000 nodes [\#196](https://github.com/chef/chef-vault/pull/196) ([thommay](https://github.com/thommay))

## [v2.7.1](https://github.com/chef/chef-vault/tree/v2.7.1) (2016-01-25)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.7.0...v2.7.1)

## [v2.7.0](https://github.com/chef/chef-vault/tree/v2.7.0) (2016-01-25)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.6.1...v2.7.0)

**Fixed bugs:**

- Should warn/error when modifying 1.x items [\#52](https://github.com/chef/chef-vault/issues/52)

**Closed issues:**

- Support data\_bag\_path arrays [\#191](https://github.com/chef/chef-vault/issues/191)
- Refresh fails if no search expression is set [\#188](https://github.com/chef/chef-vault/issues/188)
- knife vault create is failing  [\#187](https://github.com/chef/chef-vault/issues/187)
- Issues with knife bootstrap --bootstrap-vault-item [\#185](https://github.com/chef/chef-vault/issues/185)
- Can't create anything.  [\#183](https://github.com/chef/chef-vault/issues/183)
- knife vault refresh broken - chefdk0.7.0/chef11.1.1 [\#182](https://github.com/chef/chef-vault/issues/182)
- Environment Permissions [\#181](https://github.com/chef/chef-vault/issues/181)
- Knife vault stopped working after chefdk & chef-client upgrade [\#180](https://github.com/chef/chef-vault/issues/180)
- Chef 12.4.0 breaks user patch [\#176](https://github.com/chef/chef-vault/issues/176)
- vault refresh broken with chef 12.4.0 [\#175](https://github.com/chef/chef-vault/issues/175)

**Merged pull requests:**

- Correctly handle an array of data\_bag paths [\#192](https://github.com/chef/chef-vault/pull/192) ([thommay](https://github.com/thommay))
- add recognition of 'name' in response [\#184](https://github.com/chef/chef-vault/pull/184) ([lhandl](https://github.com/lhandl))
- typo in THEORY.md [\#179](https://github.com/chef/chef-vault/pull/179) ([mindyor](https://github.com/mindyor))
- Detect when trying to manage a v1 vault [\#173](https://github.com/chef/chef-vault/pull/173) ([jf647](https://github.com/jf647))

## [v2.6.1](https://github.com/chef/chef-vault/tree/v2.6.1) (2015-05-28)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.6.0...v2.6.1)

**Closed issues:**

- Permission Issue - Missing Read Permission [\#171](https://github.com/chef/chef-vault/issues/171)
-   undefined method `vault' for Chef::Resource::User [\#170](https://github.com/chef/chef-vault/issues/170)
- ChefVault::Item.refresh [\#168](https://github.com/chef/chef-vault/issues/168)

**Merged pull requests:**

- Only load the parts of chef we actually use [\#172](https://github.com/chef/chef-vault/pull/172) ([danielsdeleo](https://github.com/danielsdeleo))
- Remove dependency on rspec-its gem [\#169](https://github.com/chef/chef-vault/pull/169) ([dougireton](https://github.com/dougireton))
- Add gitter.im [\#167](https://github.com/chef/chef-vault/pull/167) ([jf647](https://github.com/jf647))

## [v2.6.0](https://github.com/chef/chef-vault/tree/v2.6.0) (2015-05-13)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.5.0...v2.6.0)

**Implemented enhancements:**

- `ChefVault::Item` should not define `\#keys` method. [\#158](https://github.com/chef/chef-vault/issues/158)
- Add --clean to refresh option [\#151](https://github.com/chef/chef-vault/issues/151)
- Allow clients \(without a node\) to be returned via searches. [\#150](https://github.com/chef/chef-vault/issues/150)
- Need validation for item id: property [\#149](https://github.com/chef/chef-vault/issues/149)
- Add helper to get the keys of a vault item [\#142](https://github.com/chef/chef-vault/issues/142)
- Add knife vault show vaultname [\#141](https://github.com/chef/chef-vault/issues/141)
- Knife Vault Refresh Not Running on Server 2012R2 [\#129](https://github.com/chef/chef-vault/issues/129)

**Closed issues:**

- knife vault create examples using node/client names? [\#157](https://github.com/chef/chef-vault/issues/157)
- Unable to create a chef vault secret from a recipe [\#154](https://github.com/chef/chef-vault/issues/154)
- knife boostrap not picking up nodes from search query of vaults [\#148](https://github.com/chef/chef-vault/issues/148)
- Cannot update vault item [\#116](https://github.com/chef/chef-vault/issues/116)
- Refresh did not re-encrypt for an admin's new key [\#145](https://github.com/chef/chef-vault/issues/145)
- Chef 12.1.0 warning [\#143](https://github.com/chef/chef-vault/issues/143)

**Merged pull requests:**

- Add vault probing predicates [\#165](https://github.com/chef/chef-vault/pull/165) ([jf647](https://github.com/jf647))
- Allow the node name and path to the client key to be specified [\#163](https://github.com/chef/chef-vault/pull/163) ([jf647](https://github.com/jf647))
- Add a \#raw\_keys method to ChefVault::Item [\#162](https://github.com/chef/chef-vault/pull/162) ([jf647](https://github.com/jf647))
- Enhance 'knife vault show' to list vault items [\#161](https://github.com/chef/chef-vault/pull/161) ([jf647](https://github.com/jf647))
- Validate that the vault id hasn't changed since the \_keys item was created [\#160](https://github.com/chef/chef-vault/pull/160) ([jf647](https://github.com/jf647))
- Add --clean-unknown-clients to 'knife vault refresh' [\#159](https://github.com/chef/chef-vault/pull/159) ([jf647](https://github.com/jf647))
- Let ChefVault::Item\#clients accept a Chef::ApiClient instead of a search... [\#156](https://github.com/chef/chef-vault/pull/156) ([jf647](https://github.com/jf647))
- Allow ruby 1.9.3 to fail on Travis [\#155](https://github.com/chef/chef-vault/pull/155) ([jf647](https://github.com/jf647))
- Update docs to reflect the new compile\_time attribute of chef\_gem [\#144](https://github.com/chef/chef-vault/pull/144) ([jf647](https://github.com/jf647))
- very minor correction to typo [\#139](https://github.com/chef/chef-vault/pull/139) ([Dispader](https://github.com/Dispader))
- Release 2.6.0 [\#164](https://github.com/chef/chef-vault/pull/164) ([jf647](https://github.com/jf647))

## [v2.5.0](https://github.com/chef/chef-vault/tree/v2.5.0) (2015-02-09)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.4.0...v2.5.0)

**Implemented enhancements:**

- knife vault list [\#97](https://github.com/chef/chef-vault/issues/97)
- Add chef-vault.bat to bin for windows users [\#60](https://github.com/chef/chef-vault/issues/60)
- OpenSSL error if private key does not match used public key [\#43](https://github.com/chef/chef-vault/issues/43)
- Skip missing/invalid client rather than raising exception [\#127](https://github.com/chef/chef-vault/issues/127)

**Fixed bugs:**

- 2.4.0 was not tagged in github [\#128](https://github.com/chef/chef-vault/issues/128)
- clean\_unknown\_clients not working [\#133](https://github.com/chef/chef-vault/issues/133)
- Skip missing/invalid client rather than raising exception [\#127](https://github.com/chef/chef-vault/issues/127)

**Closed issues:**

- Support pruning of deleted clients from vault access list when rotating keys [\#123](https://github.com/chef/chef-vault/issues/123)
- knife subcommands fail in cryptic fashion if you don't set --mode [\#117](https://github.com/chef/chef-vault/issues/117)
- vault commands force -A or knife.rb :vault\_admins [\#89](https://github.com/chef/chef-vault/issues/89)
- Add RSpec tests for chef-vault/chef/offline.rb [\#13](https://github.com/chef/chef-vault/issues/13)
- Need theory of operations/architecture documentation [\#109](https://github.com/chef/chef-vault/issues/109)

## [v2.4.0](https://github.com/chef/chef-vault/tree/v2.4.0) (2014-12-03)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.3.0...v2.4.0)

**Closed issues:**

- Create, Refresh and Update behaviours [\#118](https://github.com/chef/chef-vault/issues/118)
- vault refresh remove clients from keys data bag? [\#111](https://github.com/chef/chef-vault/issues/111)
- There doesnt seem to be a way to remove authorized client from vault\_keys [\#103](https://github.com/chef/chef-vault/issues/103)

**Merged pull requests:**

- Upgrade to RSpec 3.1 and disable monkey-patching [\#122](https://github.com/chef/chef-vault/pull/122) ([dougireton](https://github.com/dougireton))

## [v2.3.0](https://github.com/chef/chef-vault/tree/v2.3.0) (2014-10-22)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.2.4...v2.3.0)

**Closed issues:**

- Please push missing tags \(especially \> 2.2.1\) [\#119](https://github.com/chef/chef-vault/issues/119)
- Vault subcommands not showing for knife [\#114](https://github.com/chef/chef-vault/issues/114)
- cannot get client public\_key [\#113](https://github.com/chef/chef-vault/issues/113)
- Key update methods [\#105](https://github.com/chef/chef-vault/issues/105)

**Merged pull requests:**

- Add a knife vault download command for downloading encrypted files [\#104](https://github.com/chef/chef-vault/pull/104) ([justinlocsei](https://github.com/justinlocsei))

## [v2.2.4](https://github.com/chef/chef-vault/tree/v2.2.4) (2014-07-17)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.2.3...v2.2.4)

**Closed issues:**

- Improvement: easier way to update stored search for an item [\#110](https://github.com/chef/chef-vault/issues/110)
- Missing refresh command  [\#106](https://github.com/chef/chef-vault/issues/106)
- Add RSpec tests for chef-vault/certificate.rb [\#12](https://github.com/chef/chef-vault/issues/12)
- Add RSpec tests for chef-vault/user.rb [\#11](https://github.com/chef/chef-vault/issues/11)

**Merged pull requests:**

- Improved tests [\#112](https://github.com/chef/chef-vault/pull/112) ([rastasheep](https://github.com/rastasheep))

## [v2.2.3](https://github.com/chef/chef-vault/tree/v2.2.3) (2014-06-24)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.2.2...v2.2.3)

## [v2.2.2](https://github.com/chef/chef-vault/tree/v2.2.2) (2014-06-03)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.2.1...v2.2.2)

**Closed issues:**

- cannot load such file -- chef/user [\#102](https://github.com/chef/chef-vault/issues/102)
- Reapply Search [\#95](https://github.com/chef/chef-vault/issues/95)
- knife vault create thows "can't convert Array into String \(TypeError\)" [\#94](https://github.com/chef/chef-vault/issues/94)
- ChefVault::Exceptions::KeysNotFound in test kitchen [\#92](https://github.com/chef/chef-vault/issues/92)
- Undefined method join for nil class [\#91](https://github.com/chef/chef-vault/issues/91)
- Purpose of `rotate keys` [\#90](https://github.com/chef/chef-vault/issues/90)

**Merged pull requests:**

- Add gem\_tasks to Rakefile so you can do `rake release` [\#98](https://github.com/chef/chef-vault/pull/98) ([dougireton](https://github.com/dougireton))
- Fixes \#95 - Adding reapply command [\#96](https://github.com/chef/chef-vault/pull/96) ([pdalinis](https://github.com/pdalinis))
- knife.rb node name is default admin [\#93](https://github.com/chef/chef-vault/pull/93) ([jgeiger](https://github.com/jgeiger))
- Fixed minor formatting in README to allow the vault\_admins info to display properly. [\#88](https://github.com/chef/chef-vault/pull/88) ([eklein](https://github.com/eklein))
- Add a short demo as an easy way in [\#87](https://github.com/chef/chef-vault/pull/87) ([aug24](https://github.com/aug24))

## [v2.2.1](https://github.com/chef/chef-vault/tree/v2.2.1) (2014-02-26)
**Implemented enhancements:**

- Add a file-content option to the knife commands [\#42](https://github.com/chef/chef-vault/issues/42)
- Rotate shared secret when you remove nodes or admins [\#38](https://github.com/chef/chef-vault/issues/38)

**Fixed bugs:**

- Fix broken travis ci badge [\#32](https://github.com/chef/chef-vault/issues/32)

**Closed issues:**

- A question about keys. [\#85](https://github.com/chef/chef-vault/issues/85)
- --ADMINS option must be declared as mandatory when creating vault item [\#83](https://github.com/chef/chef-vault/issues/83)
- Vault UPDATE fails when vault item is created without any ADMINS specified [\#81](https://github.com/chef/chef-vault/issues/81)
- Changelog.md has a typo in "Released" date of version "v2.2.0" [\#79](https://github.com/chef/chef-vault/issues/79)
- Release updated gem to rubygems [\#78](https://github.com/chef/chef-vault/issues/78)
- knife encrypt allows illegal characters in dabag item ID [\#75](https://github.com/chef/chef-vault/issues/75)
- knife encrypt should store the search query [\#66](https://github.com/chef/chef-vault/issues/66)
- Allow for printing standard knife formatted output of the entire chef-vault'ed databag [\#62](https://github.com/chef/chef-vault/issues/62)
- Is there a way to test recipes using ChefVault with test-kitchen? [\#61](https://github.com/chef/chef-vault/issues/61)
- When is 2.1.0 scheduled for release? [\#59](https://github.com/chef/chef-vault/issues/59)
- Getting gem load error on windows 2012 chef solo client. [\#57](https://github.com/chef/chef-vault/issues/57)
- Typo in readme [\#55](https://github.com/chef/chef-vault/issues/55)
- JSON::ParserError: Unsupported `json\_class` type 'Chef::WebUIUser' [\#54](https://github.com/chef/chef-vault/issues/54)
- Improve knife commands and order [\#51](https://github.com/chef/chef-vault/issues/51)
- decrypt should emit json for the entire item [\#50](https://github.com/chef/chef-vault/issues/50)
- Use a larger key size for the generated secret by default, and allow keysize setting [\#46](https://github.com/chef/chef-vault/issues/46)
- Usage text is incorrect for `knife encrypt rotate keys` [\#44](https://github.com/chef/chef-vault/issues/44)
- Solo mode does not create knife data bag from file valid data bag file [\#40](https://github.com/chef/chef-vault/issues/40)
- ERROR: ChefVault::Exceptions::AdminNotFound for client admins [\#39](https://github.com/chef/chef-vault/issues/39)
- Warn when knife encrypt --search returns zero results [\#31](https://github.com/chef/chef-vault/issues/31)
- Clarify that knife encrypt creates databag and data bag items [\#30](https://github.com/chef/chef-vault/issues/30)
- Titlecase "chef" in README [\#29](https://github.com/chef/chef-vault/issues/29)
- knife dumps stack trace with Chef 10.24.0 after installing chef-vault gem [\#27](https://github.com/chef/chef-vault/issues/27)
- Remove Gemfile.lock from repo per Yehuda Katz and add dev dependencies to Gemspec [\#23](https://github.com/chef/chef-vault/issues/23)
- Setup project to run with Travis CI [\#18](https://github.com/chef/chef-vault/issues/18)
- Create Rake file to run tests [\#17](https://github.com/chef/chef-vault/issues/17)
- Add LICENSE file [\#16](https://github.com/chef/chef-vault/issues/16)
- Add Contributing guidelines [\#15](https://github.com/chef/chef-vault/issues/15)
- Add changelog [\#14](https://github.com/chef/chef-vault/issues/14)
- In `chef-vault.rb`, use data\_bag and chef\_config\_file getters instead of instance vars per POODR guidelines [\#9](https://github.com/chef/chef-vault/issues/9)
- Add RSpec tests for lib/chef-vault.rb [\#7](https://github.com/chef/chef-vault/issues/7)
- Splitting `admins` var on comma leaves in extraneous whitespace when --admins has spaces [\#5](https://github.com/chef/chef-vault/issues/5)
- Show better error message when 'certs' or 'passwords' directory is missing from chef-repo/databags/ directory [\#4](https://github.com/chef/chef-vault/issues/4)
- Readme should be clarified [\#1](https://github.com/chef/chef-vault/issues/1)

**Merged pull requests:**

- Add ability to use default administrators [\#84](https://github.com/chef/chef-vault/pull/84) ([dafyddcrosby](https://github.com/dafyddcrosby))
- Wrong year for recent update [\#82](https://github.com/chef/chef-vault/pull/82) ([lamont](https://github.com/lamont))
- Fixes \#79: "Released" date of version "v2.2.0" [\#80](https://github.com/chef/chef-vault/pull/80) ([techish1](https://github.com/techish1))
- Validate ID before saving item [\#77](https://github.com/chef/chef-vault/pull/77) ([eklein](https://github.com/eklein))
- Store search query & print vault admin data [\#74](https://github.com/chef/chef-vault/pull/74) ([eklein](https://github.com/eklein))
- Missed replacing "decrypt" w/ "show" in README.md [\#73](https://github.com/chef/chef-vault/pull/73) ([eklein](https://github.com/eklein))
- Rebased PR on top of jgeiger's merged PR [\#72](https://github.com/chef/chef-vault/pull/72) ([eklein](https://github.com/eklein))
- Add vault commands, deprecate encrypt, add rotate all keys [\#71](https://github.com/chef/chef-vault/pull/71) ([jgeiger](https://github.com/jgeiger))
- Fix github user name for repository [\#70](https://github.com/chef/chef-vault/pull/70) ([jgeiger](https://github.com/jgeiger))
- Fix \#51: update knife commands [\#68](https://github.com/chef/chef-vault/pull/68) ([jgeiger](https://github.com/jgeiger))
- Fix typos in KNIFE\_EXAMPLES.md [\#67](https://github.com/chef/chef-vault/pull/67) ([jgeiger](https://github.com/jgeiger))
- Issue 50: Use standard chef/knife formatting for all knife decrypt output [\#64](https://github.com/chef/chef-vault/pull/64) ([eklein](https://github.com/eklein))
- Issue \#62: Allow for printing entire chef-vault'ed databag [\#63](https://github.com/chef/chef-vault/pull/63) ([eklein](https://github.com/eklein))
- Fixes \#56: Typo in readme [\#56](https://github.com/chef/chef-vault/pull/56) ([bhicks](https://github.com/bhicks))
- Addresses \#46, use securerandom to generate secret [\#48](https://github.com/chef/chef-vault/pull/48) ([jtimberman](https://github.com/jtimberman))
- Fixes \#44: Usage text is incorrect for `knife encrypt rotate keys` [\#45](https://github.com/chef/chef-vault/pull/45) ([jer](https://github.com/jer))
- Fixing typo in command line option and README: vaules -\> values [\#41](https://github.com/chef/chef-vault/pull/41) ([trinitronx](https://github.com/trinitronx))
- Fix: open locked file on windows during data\_bag update [\#37](https://github.com/chef/chef-vault/pull/37) ([aseresun](https://github.com/aseresun))
- Allow any client key to act as admin [\#36](https://github.com/chef/chef-vault/pull/36) ([kisoku](https://github.com/kisoku))
- move the compat include into the lazy-load [\#35](https://github.com/chef/chef-vault/pull/35) ([spheromak](https://github.com/spheromak))
- Fix \#32: Correct Travis CI link [\#34](https://github.com/chef/chef-vault/pull/34) ([dougireton](https://github.com/dougireton))
- Fix \#32: Fix broken travis ci badge [\#33](https://github.com/chef/chef-vault/pull/33) ([dougireton](https://github.com/dougireton))
- Add Version Badge to Readme [\#26](https://github.com/chef/chef-vault/pull/26) ([dougireton](https://github.com/dougireton))
- Fixes \#18: Add .travis.yml file [\#25](https://github.com/chef/chef-vault/pull/25) ([dougireton](https://github.com/dougireton))
- Fixes \#23: Remove Gemfile.lock from repo per Yehuda Katz [\#24](https://github.com/chef/chef-vault/pull/24) ([dougireton](https://github.com/dougireton))
- Fixes \#15: Add Contributing guide [\#22](https://github.com/chef/chef-vault/pull/22) ([dougireton](https://github.com/dougireton))
- Fixes \#14: Add initial Changelog [\#21](https://github.com/chef/chef-vault/pull/21) ([dougireton](https://github.com/dougireton))
- Fixes \#16: Add Apache 2.0 license file and source headers [\#20](https://github.com/chef/chef-vault/pull/20) ([dougireton](https://github.com/dougireton))
- Fixes \#17: Add initial Rakefile to run specs [\#19](https://github.com/chef/chef-vault/pull/19) ([dougireton](https://github.com/dougireton))
- Fixes \#9: Use getters instead of instance vars [\#10](https://github.com/chef/chef-vault/pull/10) ([dougireton](https://github.com/dougireton))
- Fixes \#7: Add rspec tests for chef-vault.rb [\#8](https://github.com/chef/chef-vault/pull/8) ([dougireton](https://github.com/dougireton))
- Fixes \#2: Split --admins string on ',' and whitespace [\#6](https://github.com/chef/chef-vault/pull/6) ([dougireton](https://github.com/dougireton))
- Update for compatability with chef10/11 [\#3](https://github.com/chef/chef-vault/pull/3) ([spheromak](https://github.com/spheromak))
- Fixes \#1: Clarify readme [\#2](https://github.com/chef/chef-vault/pull/2) ([dougireton](https://github.com/dougireton))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*