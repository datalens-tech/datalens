# Changelog

## 2024-03-07

### Updated images

- datalens-us: 0.159.0 -> 0.168.0
- datalens-ui: 0.1384.0 -> 0.1410.0

### Changes

- Reduce alias list in add popup for controls ([ui:#700](https://github.com/datalens-tech/datalens-ui/pull/700))
- Fix pivot table(no data + totals + bar) ([ui:#699](https://github.com/datalens-tech/datalens-ui/pull/699))
- Add current dash tab highlight in dash tabs popup ([ui:#706](https://github.com/datalens-tech/datalens-ui/pull/706))
- Fix column width setting in QL charts ([ui:#713](https://github.com/datalens-tech/datalens-ui/pull/713))
- Fix parameter with a default value of 0 ([ui:#719](https://github.com/datalens-tech/datalens-ui/pull/719))
- Fix charts tabs displaying on dashboards in corner cases ([ui:#723](https://github.com/datalens-tech/datalens-ui/pull/723))

## 2024-03-01

### Updated images

- datalens-ui: 0.1316.0 -> 0.1384.0

### Changes

- Workbook page redesign ([ui:#562](https://github.com/datalens-tech/datalens-ui/pull/562))
- Fix displaying alias modal on select ignore link ([ui:#623](https://github.com/datalens-tech/datalens-ui/pull/623))
- Fix background color for null values in flat table ([ui:#634](https://github.com/datalens-tech/datalens-ui/pull/634))
- Fix title selection for segments ([ui:#637](https://github.com/datalens-tech/datalens-ui/pull/637))
- Add dnd for sorting manual values on settings ([ui:#677](https://github.com/datalens-tech/datalens-ui/pull/677))
- Add opening anchor links in self instead of blank ([ui:#689](https://github.com/datalens-tech/datalens-ui/pull/689))


#### Some improvements for relations:

- New relations improvements ([ui:#647](https://github.com/datalens-tech/datalens-ui/pull/647))
- Fix aliases validation for the same dataset ([ui:#652](https://github.com/datalens-tech/datalens-ui/pull/652))
- Add problematic alias to error output ([ui:#654](https://github.com/datalens-tech/datalens-ui/pull/654))
- Fix invalid popup height ([ui:#664](https://github.com/datalens-tech/datalens-ui/pull/664))
- Dialog relations fix & improve disconnect action ([ui:#669](https://github.com/datalens-tech/datalens-ui/pull/669))
- Alias modal fix ([ui:#684](https://github.com/datalens-tech/datalens-ui/pull/684))
- Fix some relations cases with external controls ([ui:#685](https://github.com/datalens-tech/datalens-ui/pull/685))
- Fix relations for QL chart ([ui:#691](https://github.com/datalens-tech/datalens-ui/pull/691))
- Returning a lost icon ([ui:#693](https://github.com/datalens-tech/datalens-ui/pull/693))

## 2024-02-22

### Updated images
- datalens-control-api: 0.2046.0 -> 0.2048.2
- datalens-data-api: 0.2046.0 -> 0.2048.2

### Changes

- Minor improvements

## 2024-02-16

### Updated images
- datalens-us: 0.157.0 -> 0.159.0
- datalens-ui: 0.1296.0 -> 0.1316.0

### Changed

- Refactored logic of displaying new relations ([ui:#602](https://github.com/datalens-tech/datalens-ui/pull/602))
- Fix preload dark theme ([ui:#610](https://github.com/datalens-tech/datalens-ui/pull/610))
- Fix chart coloring with null value ([ui:#593](https://github.com/datalens-tech/datalens-ui/pull/593))
- Fix axis labels formatting for bar charts  ([ui:#592](https://github.com/datalens-tech/datalens-ui/pull/592))

## 2024-02-09

### Updated images
- datalens-us: 0.149.0 -> 0.157.0
- datalens-ui: 0.1268.0 -> 0.1296.0

### Changed
- Support inner label in datepicker control ([ui:#566](https://github.com/datalens-tech/datalens-ui/pull/566))
- Add required selector option ([ui:#563](https://github.com/datalens-tech/datalens-ui/pull/563))
- Add dash ActionPanel animation ([ui:#560](https://github.com/datalens-tech/datalens-ui/pull/560))
- Fix remove alias area, fix alias controls icons displaying ([ui:#585](https://github.com/datalens-tech/datalens-ui/pull/585))
- Fix flat table gradient coloring ([ui:#559](https://github.com/datalens-tech/datalens-ui/pull/559))

## 2024-02-02

### Updated images
- datalens-us: 0.143.0 -> 0.149.0
- datalens-ui: 0.1245.0 -> 0.1268.0

### Changed
- Changed hide retry on some errors ([ui:#532](https://github.com/datalens-tech/datalens-ui/pull/532))
- Fix charts with params and datasets relations ([ui:#521](https://github.com/datalens-tech/datalens-ui/pull/521))
- Fix save button behaviour for QL charts ([ui:#548](https://github.com/datalens-tech/datalens-ui/pull/548))
- Fix bundlesize ([ui:#551](https://github.com/datalens-tech/datalens-ui/pull/551))

## 2024-01-26

### Updated images
- datalens-us: 0.133.0 -> 0.143.0
- datalens-ui: 0.1137.0 -> 0.1245.0

### Changed
- Add line support for d3 visualizations ([ui:#334](https://github.com/datalens-tech/datalens-ui/pull/334))
- Add shapes support for d3 visualizations ([ui:#516](https://github.com/datalens-tech/datalens-ui/pull/516))
- Add postgres env vars for US ([us:#54](https://github.com/datalens-tech/datalens-us/pull/54))
- Disable old relations ([ui:#518](https://github.com/datalens-tech/datalens-ui/pull/518))
- Fix removing comments in QL charts ([ui:#523](https://github.com/datalens-tech/datalens-ui/pull/523))
- Fix chart autoHeight calculation ([ui:#482](https://github.com/datalens-tech/datalens-ui/pull/482))

## 2024-01-24

### Updated images
- datalens-control-api: 0.2042.0 -> 0.2046.0
- datalens-data-api: 0.2042.0 -> 0.2046.0

### Changed

- Switched datalens-control-api and datalens-data-api containers to rootless mode
- Updated datalens-control-api & datalens-data-api base image from Ubuntu 20.04 to 22.04
- Fixed dataset loading when the connection is deleted
- Constant expressions are now removed from GROUP BY during query compilation

## 2024-01-20
- Add `UI_PORT` env param

## 2024-01-15
- Add `docker-compose-dev.yml`

## 2023-12-27

### Updated images
- datalens-control-api: 0.2040.0 -> 0.2042.0
- datalens-data-api: 0.2040.0 -> 0.2042.0

### Changed

- Enabled YDB connector

## 2023-12-26

### Updated images
- datalens-us: 0.132.0 -> 0.133.0
- datalens-ui: 0.1113.0 -> 0.1137.0

### Changed
- Added export to Excel feature
- Fix opening dash widget dialog with active widget tab
- Small interface improvements and bugfixies
- Fixed Apple M-series chips compatibility

## 2023-12-21

### Updated images
- datalens-control-api: 0.2038.1 -> 0.2040.0
- datalens-data-api: 0.2038.1 -> 0.2040.0
- datalens-us: 0.116.0 -> 0.132.0
- datalens-ui: 0.955.0 -> 0.1113.0

### Changed

- Updated system dependencies to fix vulnerabilities
- datalens-ui and datalens-us containers switched to rootless mode
- Fix table markup sorting
- Fix colors and shapes by field with prefix/postfix in title
- Fix ColorMode behaviour for bar charts
- New datepicker with relative dates for parameters in QL
- Add beta relations on dashboards
- Improve create dash entry without filling name first
- Collections & workbooks sorting fix
- Improve mobile dashboard page, added TOC & improve header mobile view


## 2023-11-24

### Updated images
- datalens-control-api: 0.2038.0 -> 0.2038.1
- datalens-data-api: 0.2038.0 -> 0.2038.1
- datalens-us: 0.110.0 -> 0.116.0

### Changed

- Add demo wokbook with local PostgreSQL database

## 2023-11-15

### Updated images
- datalens-control-api: 0.2037.0 -> 0.2038.0
- datalens-data-api: 0.2037.0 -> 0.2038.0
- datalens-us: 0.96.0 -> 0.110.0
- datalens-ui: 0.795.0 -> 0.966.0

### Changed
- UI improvements for dashboard editings
- Fixed gradient color settings on pie and pie charts
- UI improvements for workbooks (buttons grouping)
- QL charts: implemented a '+' button to add fields
