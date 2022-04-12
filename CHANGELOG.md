# chef-vault Change Log

<!-- latest_release 4.1.9 -->
## [v4.1.9](https://github.com/chef/chef-vault/tree/v4.1.9) (2022-04-12)

#### Merged Pull Requests
- Update chef-utils requirement from = 16.6.14 to 17.10.0 [#394](https://github.com/chef/chef-vault/pull/394) ([dependabot[bot]](https://github.com/dependabot[bot]))
<!-- latest_release -->

<!-- release_rollup since=4.1.5 -->
### Changes not yet released to rubygems.org

#### Merged Pull Requests
- Update chef-utils requirement from = 16.6.14 to 17.10.0 [#394](https://github.com/chef/chef-vault/pull/394) ([dependabot[bot]](https://github.com/dependabot[bot])) <!-- 4.1.9 -->
- Testing ruby 3.0 and 3.1 [#391](https://github.com/chef/chef-vault/pull/391) ([nikhil2611](https://github.com/nikhil2611)) <!-- 4.1.8 -->
- Avoid loading all of chef-vault unless we&#39;re running the plugin [#385](https://github.com/chef/chef-vault/pull/385) ([tas50](https://github.com/tas50)) <!-- 4.1.7 -->
- To integrate test coverage % report in PR creation or merge [#387](https://github.com/chef/chef-vault/pull/387) ([snehaldwivedi](https://github.com/snehaldwivedi)) <!-- 4.1.6 -->
<!-- release_rollup -->

<!-- latest_stable_release -->
## [v4.1.5](https://github.com/chef/chef-vault/tree/v4.1.5) (2021-12-16)

#### Merged Pull Requests
- Fix for chef-vault command was not returning any results [#383](https://github.com/chef/chef-vault/pull/383) ([snehaldwivedi](https://github.com/snehaldwivedi))
<!-- latest_stable_release -->

## [v4.1.4](https://github.com/chef/chef-vault/tree/v4.1.4) (2021-09-09)

#### Merged Pull Requests
- added back the begin and end [#380](https://github.com/chef/chef-vault/pull/380) ([nikhil2611](https://github.com/nikhil2611))

## [v4.1.3](https://github.com/chef/chef-vault/tree/v4.1.3) (2021-09-07)

#### Merged Pull Requests
- Upgrade to GitHub-native Dependabot [#371](https://github.com/chef/chef-vault/pull/371) ([dependabot-preview[bot]](https://github.com/dependabot-preview[bot]))
- fix-verify-pipeline [#377](https://github.com/chef/chef-vault/pull/377) ([jayashrig158](https://github.com/jayashrig158))
- Replaced exception with the warnings and removed related failing specs(used earlier for raising issue) [#367](https://github.com/chef/chef-vault/pull/367) ([sanga1794](https://github.com/sanga1794))

## [v4.1.0](https://github.com/chef/chef-vault/tree/v4.1.0) (2020-11-13)

#### Merged Pull Requests
- Fixed problem escaping string in JSON [#347](https://github.com/chef/chef-vault/pull/347) ([sanga1794](https://github.com/sanga1794))
- Resolve chefstyle warnings [#363](https://github.com/chef/chef-vault/pull/363) ([tas50](https://github.com/tas50))
- Optimize split_vault_keys method for large bag [#364](https://github.com/chef/chef-vault/pull/364) ([tas50](https://github.com/tas50))

## [v4.0.12](https://github.com/chef/chef-vault/tree/v4.0.12) (2020-09-28)

#### Merged Pull Requests
- Fixed knife vault show -F json and knife vault list -F json don&#39;t always output valid JSON [#348](https://github.com/chef/chef-vault/pull/348) ([sanga1794](https://github.com/sanga1794))

## [v4.0.11](https://github.com/chef/chef-vault/tree/v4.0.11) (2020-08-21)

#### Merged Pull Requests
- Fix bad code causing errors [#359](https://github.com/chef/chef-vault/pull/359) ([ramereth](https://github.com/ramereth))

## [v4.0.10](https://github.com/chef/chef-vault/tree/v4.0.10) (2020-08-21)

#### Merged Pull Requests
- Update simplecov-console requirement from ~&gt; 0.2.0 to ~&gt; 0.7.2 [#344](https://github.com/chef/chef-vault/pull/344) ([dependabot-preview[bot]](https://github.com/dependabot-preview[bot]))
- Remove simplecov [#356](https://github.com/chef/chef-vault/pull/356) ([tas50](https://github.com/tas50))
- Added warning if input of vault admin is other than array [#352](https://github.com/chef/chef-vault/pull/352) ([sanga1794](https://github.com/sanga1794))
- Optimize our requires [#357](https://github.com/chef/chef-vault/pull/357) ([tas50](https://github.com/tas50))

## [v4.0.6](https://github.com/chef/chef-vault/tree/v4.0.6) (2020-08-13)

#### Merged Pull Requests
- Added note in documentation regarding the vault item name [#349](https://github.com/chef/chef-vault/pull/349) ([sanga1794](https://github.com/sanga1794))
- Replaced string with regex in sub method [#351](https://github.com/chef/chef-vault/pull/351) ([sanga1794](https://github.com/sanga1794))
- Handled exception from vault? method [#350](https://github.com/chef/chef-vault/pull/350) ([sanga1794](https://github.com/sanga1794))
- Update expeditor config for new gem caching [#354](https://github.com/chef/chef-vault/pull/354) ([tas50](https://github.com/tas50))
- Optimize requires for non-omnibus installs [#355](https://github.com/chef/chef-vault/pull/355) ([tas50](https://github.com/tas50))

## [v4.0.1](https://github.com/chef/chef-vault/tree/v4.0.1) (2019-12-30)

#### Merged Pull Requests
- add documentation for sparse mode [#325](https://github.com/chef/chef-vault/pull/325) ([jeunito](https://github.com/jeunito))
- Send a better error message when an invalid SSL key is encountered when creating a vault item [#330](https://github.com/chef/chef-vault/pull/330) ([MarkGibbons](https://github.com/MarkGibbons))
- Switch from require to require_relative [#335](https://github.com/chef/chef-vault/pull/335) ([tas50](https://github.com/tas50))
- Migrate to Buildkite for PR testing [#336](https://github.com/chef/chef-vault/pull/336) ([tas50](https://github.com/tas50))
- API docs: Fix YARD warnings [#331](https://github.com/chef/chef-vault/pull/331) ([olleolleolle](https://github.com/olleolleolle))
- Ensure search is not empty when refreshing [#332](https://github.com/chef/chef-vault/pull/332) ([jeremy-clerc](https://github.com/jeremy-clerc))
- Sparse mode converter [#327](https://github.com/chef/chef-vault/pull/327) ([jeunito](https://github.com/jeunito))
- Drop Ruby 2.2/2.3 support and resolve Chefstyle warnings [#337](https://github.com/chef/chef-vault/pull/337) ([tas50](https://github.com/tas50))
- Use Chef 14 to avoid license failures in test + use config.rb where we can [#338](https://github.com/chef/chef-vault/pull/338) ([tas50](https://github.com/tas50))

## [v3.4.3](https://github.com/chef/chef-vault/tree/v3.4.3) (2018-10-25)

#### Merged Pull Requests
- Don&#39;t ship the readme in the gem [#326](https://github.com/chef/chef-vault/pull/326) ([tas50](https://github.com/tas50))

## [v3.4.2](https://github.com/chef/chef-vault/tree/v3.4.2) (2018-09-22)

#### Merged Pull Requests
- Fix license string in gemspec + ship gemspec / readme [#324](https://github.com/chef/chef-vault/pull/324) ([tas50](https://github.com/tas50))

## [v3.4.1](https://github.com/chef/chef-vault/tree/v3.4.1) (2018-09-22)

#### Merged Pull Requests
- Ship the gemfile in the gem [#323](https://github.com/chef/chef-vault/pull/323) ([tas50](https://github.com/tas50))

## [v3.4.0](https://github.com/chef/chef-vault/tree/v3.4.0) (2018-09-19)

- Switch from github changelog generator to Expeditor [#322](https://github.com/chef/chef-vault/pull/322) ([tas50](https://github.com/tas50))
- Resolve Chefstyle warnings
- Move test deps into the Gemfile and unpin versions
- Fix undefined method unpack for nil class error
- Fix FrozenError when calling 'knife vault remove'
- Allow to force reencryption of keys during refresh
- Only bundle the necessary files in the Gem

## [v3.3.0](https://github.com/chef/chef-vault/tree/v3.3.0) (2017-07-28)
[Full Changelog](https://github.com/chef/chef-vault/compare/v3.2.0...v3.3.0)

**Closed issues:**

- With recreated nodes, existing keys are not updated [\#286](https://github.com/chef/chef-vault/issues/286)

## [v3.2.0](https://github.com/chef/chef-vault/tree/v3.2.0) (2017-07-11)
[Full Changelog](https://github.com/chef/chef-vault/compare/v3.1.0...v3.2.0)

**Closed issues:**

- offline network installation of the chef-vault gem [\#279](https://github.com/chef/chef-vault/issues/279)

## [v3.1.0](https://github.com/chef/chef-vault/tree/v3.1.0) (2017-07-04)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.9.2...v3.1.0)

## [v2.9.2](https://github.com/chef/chef-vault/tree/v2.9.2) (2017-06-21)
[Full Changelog](https://github.com/chef/chef-vault/compare/v3.0.3...v2.9.2)

**Implemented enhancements:**

- Assume all nodes matching the search query are valid nodes [\#272](https://github.com/chef/chef-vault/pull/272) ([kamaradclimber](https://github.com/kamaradclimber))
- Avoid re-encrypting key for all existing clients [\#269](https://github.com/chef/chef-vault/pull/269) ([kamaradclimber](https://github.com/kamaradclimber))

**Fixed bugs:**

- Fix fatal error during create [\#281](https://github.com/chef/chef-vault/pull/281) ([neclimdul](https://github.com/neclimdul))
- Avoid sparse key read for non sparse secrets [\#280](https://github.com/chef/chef-vault/pull/280) ([kamaradclimber](https://github.com/kamaradclimber))
- Make sure sparse mode is used on secrets where it is explicit [\#271](https://github.com/chef/chef-vault/pull/271) ([kamaradclimber](https://github.com/kamaradclimber))

## [v3.0.3](https://github.com/chef/chef-vault/tree/v3.0.3) (2017-05-03)
[Full Changelog](https://github.com/chef/chef-vault/compare/v3.0.2...v3.0.3)

**Fixed bugs:**

- Reduce the search response limit from 100k to 10k [\#275](https://github.com/chef/chef-vault/pull/275) ([btm](https://github.com/btm))
- Replace edit\_data\(\) with edit\_hash\(\) in vault\_edit.rb [\#274](https://github.com/chef/chef-vault/pull/274) ([tmaczukin](https://github.com/tmaczukin))

## [v3.0.2](https://github.com/chef/chef-vault/tree/v3.0.2) (2017-04-20)
[Full Changelog](https://github.com/chef/chef-vault/compare/v3.0.1...v3.0.2)

## [v3.0.1](https://github.com/chef/chef-vault/tree/v3.0.1) (2017-04-11)
[Full Changelog](https://github.com/chef/chef-vault/compare/v3.0.0...v3.0.1)

**Fixed bugs:**

- Change the chef dependency to development only [\#266](https://github.com/chef/chef-vault/pull/266) ([thommay](https://github.com/thommay))

## [v3.0.0](https://github.com/chef/chef-vault/tree/v3.0.0) (2017-04-10)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.9.1...v3.0.0)

**Implemented enhancements:**

- Vault creation, list, and destruction in sparse mode [\#252](https://github.com/chef/chef-vault/pull/252) ([rveznaver](https://github.com/rveznaver))

## [v2.9.1](https://github.com/chef/chef-vault/tree/v2.9.1) (2017-01-19)
[Full Changelog](https://github.com/chef/chef-vault/compare/v3.0.0.rc2...v2.9.1)

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

## [v2.8.0.rc1](https://github.com/chef/chef-vault/tree/v2.8.0.rc1) (2016-01-29)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.7.1...v2.8.0.rc1)

## [v2.7.1](https://github.com/chef/chef-vault/tree/v2.7.1) (2016-01-25)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.7.0...v2.7.1)

## [v2.7.0](https://github.com/chef/chef-vault/tree/v2.7.0) (2016-01-25)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.6.1...v2.7.0)

## [v2.6.1](https://github.com/chef/chef-vault/tree/v2.6.1) (2015-05-28)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.6.0...v2.6.1)

## [v2.6.0](https://github.com/chef/chef-vault/tree/v2.6.0) (2015-05-13)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.5.0...v2.6.0)

## [v2.5.0](https://github.com/chef/chef-vault/tree/v2.5.0) (2015-02-09)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.4.0...v2.5.0)

## [v2.4.0](https://github.com/chef/chef-vault/tree/v2.4.0) (2014-12-03)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.3.0...v2.4.0)

## [v2.3.0](https://github.com/chef/chef-vault/tree/v2.3.0) (2014-10-22)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.2.4...v2.3.0)

## [v2.2.4](https://github.com/chef/chef-vault/tree/v2.2.4) (2014-07-17)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.2.3...v2.2.4)

## [v2.2.3](https://github.com/chef/chef-vault/tree/v2.2.3) (2014-06-24)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.2.2...v2.2.3)

## [v2.2.2](https://github.com/chef/chef-vault/tree/v2.2.2) (2014-06-03)
[Full Changelog](https://github.com/chef/chef-vault/compare/v2.2.1...v2.2.2)

## [v2.2.1](https://github.com/chef/chef-vault/tree/v2.2.1) (2014-02-26)
[Full Changelog](https://github.com/chef/chef-vault/compare/e7d75c65441989ce915a30fc28782748c8a1ed1e...v2.2.1)



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*