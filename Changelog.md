# Change Log

## [v3.2.0](https://github.com/chef/chef-vault/tree/v3.2.0) (2017-07-13)
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