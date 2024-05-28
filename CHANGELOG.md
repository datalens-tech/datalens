## v1.0.0 (2024-05-28)

### Changes
- Introducing the new versioning system


## 2024-05-28

- datalens-us: 0.202.0 -> 0.204.0
- datalens-ui: 0.1641.0 -> 0.1675.0

### Changes

- Fix widget params with invalid values ([ui:#1008](https://github.com/datalens-tech/datalens-ui/pull/1008))
- Fix table rows selection on Windows & Linux (for cross chart filtration) ([ui:#1009](https://github.com/datalens-tech/datalens-ui/pull/1009))
- Support widget selection in dash relations ([ui:#997](https://github.com/datalens-tech/datalens-ui/pull/997))
- Disable paste for entries linked to another workbook\directory ([ui:#824](https://github.com/datalens-tech/datalens-ui/pull/824))
- Display dash info by url param (`_opened_info=1`) ([ui:#1012](https://github.com/datalens-tech/datalens-ui/pull/1012))
- Support adding dataset in control dialog by link ([ui:#1017](https://github.com/datalens-tech/datalens-ui/pull/1017))
- Remove custom sort from manageTooltipConfig ([ui:#1023](https://github.com/datalens-tech/datalens-ui/pull/1023))
- Add hint for selectors and table header ([ui:#1030](https://github.com/datalens-tech/datalens-ui/pull/1030))
- Move RelativeDatesPicker to new DatePicker component ([ui:#1024](https://github.com/datalens-tech/datalens-ui/pull/1024))
- Normalize yfm styles between chart and dash ([ui:#1036](https://github.com/datalens-tech/datalens-ui/pull/1036))

## 2024-05-20

- datalens-us: 0.192.0 -> 0.202.0
- datalens-ui: 0.1586.0 -> 0.1641.0

### Changes

- Fix markdown term plugin ([ui:#950](https://github.com/datalens-tech/datalens-ui/pull/950))
- Change position of action panel on dash ([ui:#949](https://github.com/datalens-tech/datalens-ui/pull/949))
- Fix `p` template margin styles for markdown ([ui:#954](https://github.com/datalens-tech/datalens-ui/pull/954))
- Fix png images background styles in yfm ([ui:#958](https://github.com/datalens-tech/datalens-ui/pull/958))
- Fix datepicker focus behavior on clear ([ui:#961](https://github.com/datalens-tech/datalens-ui/pull/961))
- Added reload event and render notification for charts in embedded mode ([ui:#964](https://github.com/datalens-tech/datalens-ui/pull/964))
- Fix dataset source table styles ([ui:#969](https://github.com/datalens-tech/datalens-ui/pull/969))
- Fix markup item check ([ui:#971](https://github.com/datalens-tech/datalens-ui/pull/971))
- Fix tree-colors palette coloring ([ui:#986](https://github.com/datalens-tech/datalens-ui/pull/986))
- Fix duplicating filters on diff apply for wizard Undo ([ui:#983](https://github.com/datalens-tech/datalens-ui/pull/983))
- Fix tag param with big value in params settings section in widgets ([ui:#993](https://github.com/datalens-tech/datalens-ui/pull/993))
- Fix retry handler in case of connection data fetching failure ([ui:#996](https://github.com/datalens-tech/datalens-ui/pull/996))
- Hierarchy chart warning ([ui:#850](https://github.com/datalens-tech/datalens-ui/pull/850))
- Fix dataset select position (wizard) ([ui:#1000](https://github.com/datalens-tech/datalens-ui/pull/1000))
- Fix title bg in edit mode on contrast theme ([ui:#1001](https://github.com/datalens-tech/datalens-ui/pull/1001))

## 2024-05-02

### Updated images
- datalens-control-api: 0.2058.0 -> 0.2080.0
- datalens-data-api: 0.2058.0 -> 0.2080.0

### Changes

- Add image markup ([backend:#408](https://github.com/datalens-tech/datalens-backend/pull/408))
- Allow to disable joins optimization ([backend:#329](https://github.com/datalens-tech/datalens-backend/pull/329))
- Allow null as a default for LAG in CH ([backend:#395](https://github.com/datalens-tech/datalens-backend/pull/395)
- Typed query processor improvements
- Add execution timeout to PG, ClickHouse connectors
- Enable MySQL as connector type ([backend:#409](https://github.com/datalens-tech/datalens-backend/pull/409))
- Enable Greenplum as connector type ([backend:#410](https://github.com/datalens-tech/datalens-backend/pull/410))

[Full changelog](https://github.com/datalens-tech/datalens-backend/releases/tag/v0.2080.0).

## 2024-04-27

- datalens-ui: 0.1564.0 -> 0.1586.0

### Changes

- Improve calendar component in connections ([ui:#913](https://github.com/datalens-tech/datalens-ui/pull/913))
- Refactor mobile header + mobile fixes ([ui:#918](https://github.com/datalens-tech/datalens-ui/pull/918))
- Fix breadcrumbs styles for full-width stretching ([ui:#922](https://github.com/datalens-tech/datalens-ui/pull/922))
- Fix dash white body background ([ui:#924](https://github.com/datalens-tech/datalens-ui/pull/924))

Markdown text widget improvements:
- Fix term display ([ui:#914](https://github.com/datalens-tech/datalens-ui/pull/914))
- Add focus grid item z-index ([ui:#905](https://github.com/datalens-tech/datalens-ui/pull/905))
- Enable focusable elements for dashkit ([ui:#915](https://github.com/datalens-tech/datalens-ui/pull/915))
- Fix hr in yfm ([ui:#926](https://github.com/datalens-tech/datalens-ui/pull/926))
- Support term color ([ui:#929](https://github.com/datalens-tech/datalens-ui/pull/929))
- Fix yfm term jump ([ui:#931](https://github.com/datalens-tech/datalens-ui/pull/931))
- Fix latex render after edit ([ui:#933](https://github.com/datalens-tech/datalens-ui/pull/933))

## 2024-04-22

- datalens-us: 0.189.0 -> 0.192.0
- datalens-ui: 0.1532.0 -> 0.1564.0

### Changes

- Fix color and ellipsis styles in Breadcrumbs ([ui:#882](https://github.com/datalens-tech/datalens-ui/pull/882))
- Fix chart inspector dialog styles ([ui:#910](https://github.com/datalens-tech/datalens-ui/pull/910))
- Remove extra rerenders on text widgets ([ui:#911](https://github.com/datalens-tech/datalens-ui/pull/911))
- Fix autoheight in texts widgets with formula & magiclinks ([ui:#912](https://github.com/datalens-tech/datalens-ui/pull/912))

Markdown text widget improvements:
- Fix markdown chart autoheight on cut expand ([ui:#889](https://github.com/datalens-tech/datalens-ui/pull/889))
- Add markdown term, remove overflow on higher widget wrapper ([ui:#890](https://github.com/datalens-tech/datalens-ui/pull/890))
- Add markdown colorify ([ui:#894](https://github.com/datalens-tech/datalens-ui/pull/894))
- Yfm bugfixes ([ui:#899](https://github.com/datalens-tech/datalens-ui/pull/899))
- Fix term popup background ([ui:#904](https://github.com/datalens-tech/datalens-ui/pull/904))

## 2024-04-15

- datalens-us: 0.185.0 -> 0.189.0
- datalens-ui: 0.1488.0 -> 0.1532.0

### Changes

- Fix custom palettes in QL charts ([ui:#835](https://github.com/datalens-tech/datalens-ui/pull/835))
- Fix pivot table with page number over limit ([ui:#839](https://github.com/datalens-tech/datalens-ui/pull/839))
- Fix default displaying retry button for chart edit modes ([ui:#845](https://github.com/datalens-tech/datalens-ui/pull/845))
- Fix double request on Run button click in QL ([ui:#852](https://github.com/datalens-tech/datalens-ui/pull/852))
- Add text&title widget autoheight setting ([ui:#880](https://github.com/datalens-tech/datalens-ui/pull/880))

## 2024-04-05

- datalens-us: 0.184.0 -> 0.185.0
- datalens-ui: 0.1485.0 -> 0.1488.0

### Changes

- Fix flat table with totals and without data ([ui:#834](https://github.com/datalens-tech/datalens-ui/pull/834))

## 2024-04-01

- datalens-us: 0.179.0 -> 0.184.0
- datalens-ui: 0.1462.0 -> 0.1485.0

### Changes

- Add dataset optimize join (required) field ([ui:#810](https://github.com/datalens-tech/datalens-ui/pull/810))
- Enable chart cross filteration ([ui:#827](https://github.com/datalens-tech/datalens-ui/pull/827))
- Fix chart cross filteration setting in widget dialog ([ui:#823](https://github.com/datalens-tech/datalens-ui/pull/823))
- Add chart cross filteration settings on demo with d3 charts ([us:#104](https://github.com/datalens-tech/datalens-ui/pull/104))
- Improve render time for multidataset charts data ([ui:#820](https://github.com/datalens-tech/datalens-ui/pull/820))
- Fix drillDown with datetime field ([ui:#814](https://github.com/datalens-tech/datalens-ui/pull/814))
- Fix chart widget loading in mobile ([ui:#803](https://github.com/datalens-tech/datalens-ui/pull/803))
- Collections and workbooks UI improvements ([ui:#707](https://github.com/datalens-tech/datalens-ui/pull/707))

## 2024-03-22

- datalens-us: 0.175.0 -> 0.179.0
- datalens-ui: 0.1440.0 -> 0.1462.0

### Changes
- Fix nginx port 80 permission denied on ubuntu 16 ([ui:#797](https://github.com/datalens-tech/datalens-ui/pull/797))
- Fix ql tabs styles ([ui:#795](https://github.com/datalens-tech/datalens-ui/pull/795))
- Fix both way connection selection total connections reset for dash relations ([ui:#777](https://github.com/datalens-tech/datalens-ui/pull/777))
- Fix subtotals for NULL values for pivot tables ([ui:#776](https://github.com/datalens-tech/datalens-ui/pull/776))

## 2024-03-18

### Updated images

- datalens-control-api: 0.2048.2 -> 0.2058.0
- datalens-data-api: 0.2048.2 -> 0.2058.0

### Changes

- Use root ca explicitly in http-based adapters reducing disk reads ([backend:#262](https://github.com/datalens-tech/datalens-backend/pull/262))
- Allow constant expressions in GROUP BY for everything except YDB ([backend:#290](https://github.com/datalens-tech/datalens-backend/pull/290))
- Enable gp_recursive_cte during statement preparation in the Greenplum connector ([backend:#175](https://github.com/datalens-tech/datalens-backend/pull/175))
- Fix a date subtraction bug in MySQL connector ([backend:#314](https://github.com/datalens-tech/datalens-backend/pull/314))
- Added new query types for DashSQL:
  * generic_distinct - Generic type for queries with a single-column result (i.e. all distinct values of a dimension column)
  * generic_label_values - More specific than generic_distinct for connectors that have the concept of labels

[Full changelog](https://github.com/datalens-tech/datalens-backend/releases/tag/v0.2058.0).

## 2024-03-16

### Updated images

- datalens-us: 0.168.0 -> 0.175.0
- datalens-ui: 0.1410.0 -> 0.1440.0

### Changes

- Unify empty states styles ([ui:#731](https://github.com/datalens-tech/datalens-ui/pull/731))
- Switched to `@diplodoc/transform` v4, changed markdown default styles ([ui:#740](https://github.com/datalens-tech/datalens-ui/pull/740))
- Minor improvements for mobile version ([ui:#763](https://github.com/datalens-tech/datalens-ui/pull/763))

#### Some improvements for relations:

- Improve disable dash relations select ([ui:#767](https://github.com/datalens-tech/datalens-ui/pull/767))
- Fix displaying saved new dash relation, disable close relations modal by esc and click by outside ([ui:#759](https://github.com/datalens-tech/datalens-ui/pull/759))
- Add indirect relation unknown relations support ([ui:#758](https://github.com/datalens-tech/datalens-ui/pull/758))
- Fix random aliases deletion ([ui:#770](https://github.com/datalens-tech/datalens-ui/pull/770))

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
