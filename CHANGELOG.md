## v1.17.0 (2024-11-29)

### Image versions
- datalens-control-api: 0.2176.0 -> 0.2181.0 ([full changelog](https://github.com/datalens-tech/datalens-backend/compare/v0.2176.0...v0.2181.0))
- datalens-data-api: 0.2176.0 -> 0.2181.0 ([full changelog](https://github.com/datalens-tech/datalens-backend/compare/v0.2176.0...v0.2181.0))
- datalens-ui: 0.2312.0
- datalens-us: 0.260.0

### New features
- **Connectors**: Add ClickHouse readonly level control. [datalens-tech/datalens-backend#710](https://github.com/datalens-tech/datalens-backend/pull/710)


## v1.16.0 (2024-11-15)

### Image versions
- datalens-control-api: 0.2170.0 -> 0.2176.0 ([full changelog](https://github.com/datalens-tech/datalens-backend/compare/v0.2170.0...v0.2176.0))
- datalens-data-api: 0.2170.0 -> 0.2176.0 ([full changelog](https://github.com/datalens-tech/datalens-backend/compare/v0.2170.0...v0.2176.0))
- datalens-ui: 0.2312.0
- datalens-us: 0.260.0

### New features
- Enable datasource schema update for Bitrix. [datalens-tech/datalens-backend#685](https://github.com/datalens-tech/datalens-backend/pull/685)
- Add AUTH.TYPE = 'none'. [datalens-tech/datalens-backend#684](https://github.com/datalens-tech/datalens-backend/pull/684)
- Orjson for marshmallow. [datalens-tech/datalens-backend#689](https://github.com/datalens-tech/datalens-backend/pull/689)
- **Optimization**: Optimize AND/OR comparisons in filters. [datalens-tech/datalens-backend#694](https://github.com/datalens-tech/datalens-backend/pull/694)
- Use msgpack in RQE serialization. [datalens-tech/datalens-backend#692](https://github.com/datalens-tech/datalens-backend/pull/692)

### Bug fixes
- **Formula**: Fix LODs with constant functions in query. [datalens-tech/datalens-backend#668](https://github.com/datalens-tech/datalens-backend/pull/668)
- Fixes for connection replacements. [datalens-tech/datalens-backend#700](https://github.com/datalens-tech/datalens-backend/pull/700)

### Security
- **Connectors**: Forbid redirects in promql connector. [datalens-tech/datalens-backend#690](https://github.com/datalens-tech/datalens-backend/pull/690)
- **Connectors**: Forbid redirects in bitrix connector. [datalens-tech/datalens-backend#691](https://github.com/datalens-tech/datalens-backend/pull/691)


## v1.15.0 (2024-11-08)

### Image versions
- datalens-control-api: 0.2170.0
- datalens-data-api: 0.2170.0
- datalens-ui: 0.2248.0 -> 0.2312.0 ([full changelog](https://github.com/datalens-tech/datalens-ui/compare/v0.2248.0...v0.2312.0))
- datalens-us: 0.256.0 -> 0.260.0 ([full changelog](https://github.com/datalens-tech/datalens-us/compare/v0.256.0...v0.260.0))

### New features
- **Charts**: Enable export for d3 charts. [datalens-tech/datalens-ui#1707](https://github.com/datalens-tech/datalens-ui/pull/1707)
- **Dashboards**: Add resize handler to lower left corner of dash widgets. [datalens-tech/datalens-ui#1720](https://github.com/datalens-tech/datalens-ui/pull/1720)
- **Charts**: Add treemap visualization. [datalens-tech/datalens-ui#1709](https://github.com/datalens-tech/datalens-ui/pull/1709)
- **Charts**: Add a setting for the Y-axis of the area chart to connect empty values. [datalens-tech/datalens-ui#1680](https://github.com/datalens-tech/datalens-ui/pull/1680)

### Bug fixes
- **Charts**: Optimize table rendering. [datalens-tech/datalens-ui#1715](https://github.com/datalens-tech/datalens-ui/pull/1715)
- **Charts**: Fix simultaneous display of the fill indicator and the linear indicator. [datalens-tech/datalens-ui#1721](https://github.com/datalens-tech/datalens-ui/pull/1721)
- **Dashboards**: Fix creating aliases for ql-indicators. [datalens-tech/datalens-ui#1722](https://github.com/datalens-tech/datalens-ui/pull/1722)
- **Charts**: Fix linear indicator that goes beyond the boundaries of the cell. [datalens-tech/datalens-ui#1730](https://github.com/datalens-tech/datalens-ui/pull/1730)
- **Charts**: Fix linear indicator with custom scale. [datalens-tech/datalens-ui#1735](https://github.com/datalens-tech/datalens-ui/pull/1735)
- **Charts**: Fix coloring by field fake title in the scatter plot. [datalens-tech/datalens-ui#1734](https://github.com/datalens-tech/datalens-ui/pull/1734)
- **Charts**: Table widget improvements. [datalens-tech/datalens-ui#1742](https://github.com/datalens-tech/datalens-ui/pull/1742)
- **Dashboards**: Fix blocking interface due to dataset selectors on mobile. [datalens-tech/datalens-ui#1764](https://github.com/datalens-tech/datalens-ui/pull/1764)
- **Charts**: Fix date field distinct values for filters section. [datalens-tech/datalens-ui#1767](https://github.com/datalens-tech/datalens-ui/pull/1767)
- **Charts**: Display values for string fields in total (flat table). [datalens-tech/datalens-ui#1763](https://github.com/datalens-tech/datalens-ui/pull/1763)
- **Charts**: Fix chart click processing for working with hierarchies(d3). [datalens-tech/datalens-ui#1768](https://github.com/datalens-tech/datalens-ui/pull/1768)

### Tests
- **Dashboards**: Add screenshot tests for dash. [datalens-tech/datalens-ui#1677](https://github.com/datalens-tech/datalens-ui/pull/1677)

### Chores
- **General components**: Up @gravity-ui/chartkit 5.15.0 -> 5.17.1. [datalens-tech/datalens-ui#1716](https://github.com/datalens-tech/datalens-ui/pull/1716), [datalens-tech/datalens-ui#1751](https://github.com/datalens-tech/datalens-ui/pull/1751)
- **General components**: Add expresskit language detection. [datalens-tech/datalens-ui#1718](https://github.com/datalens-tech/datalens-ui/pull/1718)
- **General components**: Update @gravity-ui/components 3.11.0 -> 3.12.3, fix styles. [datalens-tech/datalens-ui#1732](https://github.com/datalens-tech/datalens-ui/pull/1732), [datalens-tech/datalens-ui#1753](https://github.com/datalens-tech/datalens-ui/pull/1753)
- **Navigation**: Add UseMovePermAction feature, change types. [datalens-tech/datalens-ui#1731](https://github.com/datalens-tech/datalens-ui/pull/1731)
- **General components**: Update @gravity-ui/app-builder. [datalens-tech/datalens-ui#1711](https://github.com/datalens-tech/datalens-ui/pull/1711)
- Delete unused DLS actions, types. [datalens-tech/datalens-ui#1739](https://github.com/datalens-tech/datalens-ui/pull/1739)
- **General components**: Update @gravity-ui/nodekit 1.6.0 -> 1.7.0, @gravity-ui/gateway 2.6.1 -> 2.6.2. [datalens-tech/datalens-ui#1756](https://github.com/datalens-tech/datalens-ui/pull/1756)
- **General components**: Update @gravity-ui/dashkit 8.17.4 -> 8.18.0. [datalens-tech/datalens-ui#1770](https://github.com/datalens-tech/datalens-ui/pull/1770)


## v1.14.0 (2024-11-06)

### Image versions
- datalens-control-api: 0.2139.0 -> 0.2170.0 ([full changelog](https://github.com/datalens-tech/datalens-backend/compare/v0.2139.0...v0.2170.0))
- datalens-data-api: 0.2139.0 -> 0.2170.0 ([full changelog](https://github.com/datalens-tech/datalens-backend/compare/v0.2139.0...v0.2170.0))
- datalens-ui: 0.2248.0
- datalens-us: 0.256.0

### New features
- **Connectors**: Enable metrica and appmetrica. [datalens-tech/datalens-backend#616](https://github.com/datalens-tech/datalens-backend/pull/616)
- **Optimization**: Optimize binary operators comparisons in filters. [datalens-tech/datalens-backend#626](https://github.com/datalens-tech/datalens-backend/pull/626)
- **Optimization**: Support IN/NOT IN in the binary operators comparisons optimization. [datalens-tech/datalens-backend#635](https://github.com/datalens-tech/datalens-backend/pull/635)
- **Formula**: Optimize constant math operations. [datalens-tech/datalens-backend#647](https://github.com/datalens-tech/datalens-backend/pull/647)

### Bug fixes
- **Connectors**, **Datasets**: Fix file connection datasource replacement. [datalens-tech/datalens-backend#591](https://github.com/datalens-tech/datalens-backend/pull/591)
- **Connectors**: Handle google api errors & bad creds error in BQ connector. [datalens-tech/datalens-backend#601](https://github.com/datalens-tech/datalens-backend/pull/601)
- **Datasets**: Fix source refresh with deleted fields, do not force refresh always. [datalens-tech/datalens-backend#604](https://github.com/datalens-tech/datalens-backend/pull/604)
- **Embeds**: Handle the INCORRECT_ENTRY_ID_FOR_EMBED error from US. [datalens-tech/datalens-backend#631](https://github.com/datalens-tech/datalens-backend/pull/631)
- **Formula**: Quarter support for PostgreSQL and Oracle. [datalens-tech/datalens-backend#645](https://github.com/datalens-tech/datalens-backend/pull/645)

### Security
- Update versions. [datalens-tech/datalens-backend#651](https://github.com/datalens-tech/datalens-backend/pull/651)
- Upgrade cryptography. [datalens-tech/datalens-backend#660](https://github.com/datalens-tech/datalens-backend/pull/660)

### Docs
- Add a page about the project structure to kb. [datalens-tech/datalens-backend#621](https://github.com/datalens-tech/datalens-backend/pull/621)


## v1.13.0 (2024-10-21)

### Image versions
- datalens-control-api: 0.2139.0
- datalens-data-api: 0.2139.0
- datalens-ui: 0.2140.0 -> 0.2248.0 ([full changelog](https://github.com/datalens-tech/datalens-ui/compare/v0.2140.0...v0.2248.0))
- datalens-us: 0.246.0 -> 0.256.0  ([full changelog](https://github.com/datalens-tech/datalens-us/compare/v0.246.0...v0.256.0))

### Security
- **General components**: Dependencies with vulnerabilities have been updated. [datalens-tech/datalens-ui#1654](https://github.com/datalens-tech/datalens-ui/pull/1654)

### Development
- **Dashboards**: Moved DashControlsConfigContext as default wrapper for Dashkit container. [datalens-tech/datalens-ui#1436](https://github.com/datalens-tech/datalens-ui/pull/1436)
- **General components**: Removed page reloading while renaming or moving entities. 

### Chores
- **General components**: Up @gravity-ui/dashkit@8.17.1. [datalens-tech/datalens-ui#1592](https://github.com/datalens-tech/datalens-ui/pull/1592)
- Update `@gravity-ui/chartkit` from v5.12.0 to v5.14.0. [datalens-tech/datalens-ui#1614](https://github.com/datalens-tech/datalens-ui/pull/1614), [datalens-tech/datalens-ui#1665](https://github.com/datalens-tech/datalens-ui/pull/1665)
- **General components**: Up `@gravity-ui/dashkit` from v8.16.0 to v8.17.4. [datalens-tech/datalens-ui#1622](https://github.com/datalens-tech/datalens-ui/pull/1622), [datalens-tech/datalens-ui#1658](https://github.com/datalens-tech/datalens-ui/pull/1658), [datalens-tech/datalens-ui#1685](https://github.com/datalens-tech/datalens-ui/pull/1685)
- **General components**: Bump micromatch from 4.0.5 to 4.0.8. [datalens-tech/datalens-ui#1410](https://github.com/datalens-tech/datalens-ui/pull/1410)
- **General components**: Bump webpack from 5.91.0 to 5.94.0. [datalens-tech/datalens-ui#1428](https://github.com/datalens-tech/datalens-ui/pull/1428)
- **General components**: Update `@gravity-ui/uikit` from v6.20.0 to v6.31.0. [datalens-tech/datalens-ui#1662](https://github.com/datalens-tech/datalens-ui/pull/1662), [datalens-tech/datalens-ui#1678](https://github.com/datalens-tech/datalens-ui/pull/1678)
- **General components**: Bump uplot and `@gravity-ui/yagr`. [datalens-tech/datalens-ui#1663](https://github.com/datalens-tech/datalens-ui/pull/1663)
- **General components**: Update `@gravity-ui/date-components` to v2.10.2. [datalens-tech/datalens-ui#1668](https://github.com/datalens-tech/datalens-ui/pull/1668)
- **General components**: Update `@gravity-ui/navigation` 2.23.1 -> 2.27.0. [datalens-tech/datalens-ui#1684](https://github.com/datalens-tech/datalens-ui/pull/1684)
- **General components**: Update `@gravity-ui/expresskit` to 2.0.1 and `@gravity-ui/nodekit` to 1.6.0. [datalens-tech/datalens-ui#1686](https://github.com/datalens-tech/datalens-ui/pull/1686), [datalens-tech/datalens-ui#1699](https://github.com/datalens-tech/datalens-ui/pull/1699)
- **General components**: Bump cookie and @sentry/node. [datalens-tech/datalens-ui#1701](https://github.com/datalens-tech/datalens-ui/pull/1701)

### New features
- **Charts**: Supported compact tooltip in maps. [datalens-tech/datalens-ui#1546](https://github.com/datalens-tech/datalens-ui/pull/1546)
- **Charts**: Add save dialog before screenshot on QL. [datalens-tech/datalens-ui#1569](https://github.com/datalens-tech/datalens-ui/pull/1569)
- **Dashboards**: Support copying connections together with copying widget on the dash. [datalens-tech/datalens-ui#1595](https://github.com/datalens-tech/datalens-ui/pull/1595)
- **Charts**: Improve error text from api/run. [datalens-tech/datalens-ui#1611](https://github.com/datalens-tech/datalens-ui/pull/1611)
- **Charts**: Sorting with continuous axis in a line chart. [datalens-tech/datalens-ui#1598](https://github.com/datalens-tech/datalens-ui/pull/1598)  
- **Dashboards**: Add comprasion operations for text field in selectors. [datalens-tech/datalens-ui#1667](https://github.com/datalens-tech/datalens-ui/pull/1667)
- **General components**: Move and rename entities without reload. [datalens-tech/datalens-ui#1676](https://github.com/datalens-tech/datalens-ui/pull/1676), [datalens-tech/datalens-ui#1651](https://github.com/datalens-tech/datalens-ui/pull/1651)
- **Charts**: Setting to hide the axis. [datalens-tech/datalens-ui#1645](https://github.com/datalens-tech/datalens-ui/pull/1645)
- **Charts**: Add a setting to disable the tooltip. [datalens-tech/datalens-ui#1648](https://github.com/datalens-tech/datalens-ui/pull/1648)

### Bug fixes
- **Dashboards**: Fix margin for last p-block with term. [datalens-tech/datalens-ui#1591](https://github.com/datalens-tech/datalens-ui/pull/1591)
- **Charts**: Fixed the display of markup in maps with the clustering points. [datalens-tech/datalens-ui#1599](https://github.com/datalens-tech/datalens-ui/pull/1599)
- **Auth**: Fix logout route with Zitadel integration. [datalens-tech/datalens-ui#1615](https://github.com/datalens-tech/datalens-ui/pull/1615)
- **Charts**: Fix chart dnd on Wizard. [datalens-tech/datalens-ui#1597](https://github.com/datalens-tech/datalens-ui/pull/1597)
- **Charts**: Fix pseudo field from table when change visualization. [datalens-tech/datalens-ui#1616](https://github.com/datalens-tech/datalens-ui/pull/1616)
- **Datasets**: Fix dataset filter dialog layout. [datalens-tech/datalens-ui#1620](https://github.com/datalens-tech/datalens-ui/pull/1620)
- **Dashboards**: Fix z-index for table of content in mobile. [datalens-tech/datalens-ui#1612](https://github.com/datalens-tech/datalens-ui/pull/1612)
- **Charts**: Fix gradient coloring of the table for zero values. [datalens-tech/datalens-ui#1623](https://github.com/datalens-tech/datalens-ui/pull/1623)
- **Navigation**: Fix theme override by query. [datalens-tech/datalens-ui#1624](https://github.com/datalens-tech/datalens-ui/pull/1624)
- **Navigation**: Fixed navigation dialog width. [datalens-tech/datalens-ui#1625](https://github.com/datalens-tech/datalens-ui/pull/1625)
- **Charts**: Fix gradient coloring for null values (flat table). [datalens-tech/datalens-ui#1633](https://github.com/datalens-tech/datalens-ui/pull/1633)
- **Charts**: Fixed sorting of dates with null values. [datalens-tech/datalens-ui#1634](https://github.com/datalens-tech/datalens-ui/pull/1634)
- **Charts**: Fix axis mode for combined charts. [datalens-tech/datalens-ui#1641](https://github.com/datalens-tech/datalens-ui/pull/1641)
- **Charts**: Fix column width of the table with virtualization. [datalens-tech/datalens-ui#1629](https://github.com/datalens-tech/datalens-ui/pull/1629)
- **Charts**: Fix: a table in QL crashes with an error when there is no data. [datalens-tech/datalens-ui#1649](https://github.com/datalens-tech/datalens-ui/pull/1649)
- **Charts**: Fix: column width is incorrectly calculated for cells with a possible…. [datalens-tech/datalens-ui#1660](https://github.com/datalens-tech/datalens-ui/pull/1660)
- **Dashboards**: Fix loss of connections on other tabs if disconnect all is made. [datalens-tech/datalens-ui#1661](https://github.com/datalens-tech/datalens-ui/pull/1661)
- **Dashboards**: Reset tab when leaving the dashboard. [datalens-tech/datalens-ui#1671](https://github.com/datalens-tech/datalens-ui/pull/1671)
- **Charts**: Fix endless table rendering cycle. [datalens-tech/datalens-ui#1674](https://github.com/datalens-tech/datalens-ui/pull/1674)
- **Charts**: Fix duplicate content when highlighting the entire page. [datalens-tech/datalens-ui#1697](https://github.com/datalens-tech/datalens-ui/pull/1697)
- **Charts**: Fix linear indicator with manual scale. [datalens-tech/datalens-ui#1700](https://github.com/datalens-tech/datalens-ui/pull/1700)


## v1.12.0 (2024-09-23)

### Image versions
- datalens-control-api: 0.2139.0
- datalens-data-api: 0.2139.0
- datalens-ui: 0.2000.0 -> 0.2140.0 ([full changelog](https://github.com/datalens-tech/datalens-ui/compare/v0.2000.0...v0.2140.0))
- datalens-us: 0.239.0 -> 0.246.0 ([full changelog](https://github.com/datalens-tech/datalens-us/compare/v0.239.0...v0.246.0))

### Breaking changes
- **Charts**: Replace convertConnectionType with another function in registry(QL). [datalens-tech/datalens-ui#1493](https://github.com/datalens-tech/datalens-ui/pull/1493)

### New features
- **Dashboards**: Enable dash auto refresh. [datalens-tech/datalens-ui#1510](https://github.com/datalens-tech/datalens-ui/pull/1510)
- **Datasets**: Mass actions for datasets (Aggregations and change type). [datalens-tech/datalens-ui#1492](https://github.com/datalens-tech/datalens-ui/pull/1492)
- **Charts**: Add edit history in Wizard. [datalens-tech/datalens-ui#1585](https://github.com/datalens-tech/datalens-ui/pull/1585)
- **Charts**: Pivot inline sort. [datalens-tech/datalens-ui#1557](https://github.com/datalens-tech/datalens-ui/pull/1557)
- **Charts**: Add pinned columns feature for tables. [datalens-tech/datalens-ui#1588](https://github.com/datalens-tech/datalens-ui/pull/1588)
- **Dashboards**: Add fixed header for dashboards. [datalens-tech/datalens-ui#1589](https://github.com/datalens-tech/datalens-ui/pull/1589)

### Bug fixes
- **Charts**: Fixed setting line id when using split. [datalens-tech/datalens-ui#1431](https://github.com/datalens-tech/datalens-ui/pull/1431)
- **Charts**: Fixed the missing hint in the table when replacing the dataset. [datalens-tech/datalens-ui#1437](https://github.com/datalens-tech/datalens-ui/pull/1437)
- **Charts**: Fixed initialization of categories for a scatter chart. [datalens-tech/datalens-ui#1443](https://github.com/datalens-tech/datalens-ui/pull/1443)
- **Charts**: Fixed the display of old dates with an offset. [datalens-tech/datalens-ui#1440](https://github.com/datalens-tech/datalens-ui/pull/1440)
- **Charts**: Add form checks for logarithmic axis type and fallbacks. [datalens-tech/datalens-ui#1433](https://github.com/datalens-tech/datalens-ui/pull/1433)
- **General components**: Fix dash body overflow for mobile. [datalens-tech/datalens-ui#1452](https://github.com/datalens-tech/datalens-ui/pull/1452)
- **Charts**: Fixed an incorrect error when there are no access rights. [datalens-tech/datalens-ui#1454](https://github.com/datalens-tech/datalens-ui/pull/1454)
- **Charts**: Fixed pagination control is not displayed in tables with hierarchies. [datalens-tech/datalens-ui#1468](https://github.com/datalens-tech/datalens-ui/pull/1468)
- **Dashboards**: Add useMemoCallback hook for partial deps update. [datalens-tech/datalens-ui#1502](https://github.com/datalens-tech/datalens-ui/pull/1502)
- **Charts**: Fixed empty ql dialog. [datalens-tech/datalens-ui#1530](https://github.com/datalens-tech/datalens-ui/pull/1530)
- **Dashboards**: Fixed note p margin in yfm. [datalens-tech/datalens-ui#1551](https://github.com/datalens-tech/datalens-ui/pull/1551)

### Chores
- **General components**: Update @gravity-ui/app-layout. [datalens-tech/datalens-ui#1425](https://github.com/datalens-tech/datalens-ui/pull/1425)
- **General components**: Update @gravity-ui/dashkit 8.10.2 -> 8.15.3. [datalens-tech/datalens-ui#1441](https://github.com/datalens-tech/datalens-ui/pull/1441), [datalens-tech/datalens-ui#1469](https://github.com/datalens-tech/datalens-ui/pull/1469), [datalens-tech/datalens-ui#1528](https://github.com/datalens-tech/datalens-ui/pull/1528), [datalens-tech/datalens-ui#1542](https://github.com/datalens-tech/datalens-ui/pull/1542), [datalens-tech/datalens-ui#1543](https://github.com/datalens-tech/datalens-ui/pull/1543), [datalens-tech/datalens-ui#1563](https://github.com/datalens-tech/datalens-ui/pull/1563)
- **Dashboards**: Remove beta from charts filtering on dash. [datalens-tech/datalens-ui#1463](https://github.com/datalens-tech/datalens-ui/pull/1463)
- **Dashboards**: Widgets update optimizations. [datalens-tech/datalens-ui#1504](https://github.com/datalens-tech/datalens-ui/pull/1504)
- **Navigation**, **General components**: Update `@gravity-ui/navigation`. [datalens-tech/datalens-ui#1521](https://github.com/datalens-tech/datalens-ui/pull/1521)
- **General components**: Bump body-parser and express. [datalens-tech/datalens-ui#1526](https://github.com/datalens-tech/datalens-ui/pull/1526)
- **General components**: Up @gravity-ui/app-layout 2.0.1 -> 2.1.0. [datalens-tech/datalens-ui#1536](https://github.com/datalens-tech/datalens-ui/pull/1536)
- **Charts**: Clickable links in labels (markup) + up @gravity-ui/chartkit 5.11.2 -> 5.12.0. [datalens-tech/datalens-ui#1552](https://github.com/datalens-tech/datalens-ui/pull/1552)


## v1.11.1 (2024-09-03)

### Image versions
- datalens-control-api: 0.2139.0
- datalens-data-api: 0.2139.0
- datalens-ui: 0.2000.0
- datalens-us: 0.239.0

### Bug fixes
- **Navigation**: Fix navigate route in Zitadel mode. [datalens-tech/datalens#195](https://github.com/datalens-tech/datalens/pull/195)

## v1.11.0 (2024-09-02)

### Image versions
- datalens-control-api: 0.2139.0
- datalens-data-api: 0.2139.0
- datalens-ui: 0.1906.0 -> 0.2000.0 ([full changelog](https://github.com/datalens-tech/datalens-ui/compare/v0.1906.0...v0.2000.0))
- datalens-us: 0.224.0 -> 0.239.0 ([full changelog](https://github.com/datalens-tech/datalens-us/compare/v0.224.0...v0.239.0))

### New features
- **Dashboards**: Support top placement for selectors titles. [datalens-tech/datalens-ui#1316](https://github.com/datalens-tech/datalens-ui/pull/1316)
- **Navigation**: Add menu for zitadel user. [datalens-tech/datalens-ui#1344](https://github.com/datalens-tech/datalens-ui/pull/1344)
- **Navigation**: Show tooltip with absolute modification date for collections table. [datalens-tech/datalens-ui#1370](https://github.com/datalens-tech/datalens-ui/pull/1370)
- **Charts**: Add ENV to enable Yandex Map and set HC endpoint from ENV. [datalens-tech/datalens-ui#1413](https://github.com/datalens-tech/datalens-ui/pull/1413)

### Bug fixes
- **Dashboards**: Fix filling hint of selector with dataset description. [datalens-tech/datalens-ui#1323](https://github.com/datalens-tech/datalens-ui/pull/1323)
- **Dashboards**: Fix margins of buttons and checkboxes in selectors. [datalens-tech/datalens-ui#1324](https://github.com/datalens-tech/datalens-ui/pull/1324)
- **Dashboards**: Fix layout of old selector when resaving with the addition of selectors. [datalens-tech/datalens-ui#1330](https://github.com/datalens-tech/datalens-ui/pull/1330)
- **Dashboards**: Fix dash crash when canceling deleting of selector in autoupdating group. [datalens-tech/datalens-ui#1326](https://github.com/datalens-tech/datalens-ui/pull/1326)
- **Dashboards**: Fix too large size of widget when canceling changes to old selector on dash. [datalens-tech/datalens-ui#1325](https://github.com/datalens-tech/datalens-ui/pull/1325)
- **Datasets**: Fix for resetting source name in sql subrequest in dataset. [datalens-tech/datalens-ui#1361](https://github.com/datalens-tech/datalens-ui/pull/1361)
- **Charts**: Fix wizard geo-chart with old config. [datalens-tech/datalens-ui#1369](https://github.com/datalens-tech/datalens-ui/pull/1369)
- **Navigation**: Block clicks around checkboxes in collections. [datalens-tech/datalens-ui#1368](https://github.com/datalens-tech/datalens-ui/pull/1368)

### Chores
- **General components**: Up @gravity-ui/navigation. [datalens-tech/datalens-ui#1332](https://github.com/datalens-tech/datalens-ui/pull/1332)
- **General components**: Bump fast-xml-parser and @aws-sdk/client-s3. [datalens-tech/datalens-ui#1308](https://github.com/datalens-tech/datalens-ui/pull/1308)
- **General components**: Update @gravity-ui/dashkit 8.10.0 -> 8.10.1. [datalens-tech/datalens-ui#1390](https://github.com/datalens-tech/datalens-ui/pull/1390)
- **General components**: Up @gravity-ui/chartkit(5.10.2 -> 5.11.2). [datalens-tech/datalens-ui#1409](https://github.com/datalens-tech/datalens-ui/pull/1409)


## v1.10.0 (2024-08-29)

### Image versions
- datalens-control-api: 0.2132.0 -> 0.2139.0 ([full changelog](https://github.com/datalens-tech/datalens-backend/compare/v0.2132.0...v0.2139.0))
- datalens-data-api: 0.2132.0 -> 0.2139.0 ([full changelog](https://github.com/datalens-tech/datalens-backend/compare/v0.2132.0...v0.2139.0))
- datalens-ui: 0.1906.0
- datalens-us: 0.224.0

### New features
- **General components**: Add native types serialization. [datalens-tech/datalens-backend#574](https://github.com/datalens-tech/datalens-backend/pull/574)
- **Connectors**: Add secure to file settings. [datalens-tech/datalens-backend#581](https://github.com/datalens-tech/datalens-backend/pull/581)
- CSRF multiple secrets support added. [datalens-tech/datalens-backend#579](https://github.com/datalens-tech/datalens-backend/pull/579)
- **General components**: Add an option to use the json serializer for non-stream requests in RQE. [datalens-tech/datalens-backend#569](https://github.com/datalens-tech/datalens-backend/pull/569)

### Bug fixes
- **Connectors**: Bitrix user field filtering fix. [datalens-tech/datalens-backend#575](https://github.com/datalens-tech/datalens-backend/pull/575)

### Dependencies
- Update Zitadel version. [datalens-tech/datalens#191](https://github.com/datalens-tech/datalens/pull/191)


## v1.9.0 (2024-08-15)

### Image versions
- datalens-control-api: 0.2102.2 -> 0.2132.0 ([full changelog](https://github.com/datalens-tech/datalens-backend/compare/v0.2102.2...v0.2132.0))
- datalens-data-api: 0.2102.2 -> 0.2132.0 ([full changelog](https://github.com/datalens-tech/datalens-backend/compare/v0.2102.2...v0.2132.0))
- datalens-ui: 0.1906.0
- datalens-us: 0.224.0

### New features
- **Connectors**: Add DB name validation to prevent custom parameters passing to the driver. [datalens-tech/datalens-backend#490](https://github.com/datalens-tech/datalens-backend/pull/490)
- **Formula**: Add REGEXP_EXTRACT_ALL function. [datalens-tech/datalens-backend#485](https://github.com/datalens-tech/datalens-backend/pull/485)
- **Datasets**: Add groups support in RLS. [datalens-tech/datalens-backend#534](https://github.com/datalens-tech/datalens-backend/pull/534)
- Support extra ca_data in backend apps. [datalens-tech/datalens-backend#558](https://github.com/datalens-tech/datalens-backend/pull/558)
- **Connectors**: Enable MSSQL connector. [datalens-tech/datalens-backend#573](https://github.com/datalens-tech/datalens-backend/pull/573)

### Bug fixes
- **Connectors**: Add Content-Type header to all requests to ClickHouse. [datalens-tech/datalens-backend#512](https://github.com/datalens-tech/datalens-backend/pull/512)
- **Connectors**: Fallback to new connection type when replacing connection with no access. [datalens-tech/datalens-backend#566](https://github.com/datalens-tech/datalens-backend/pull/566)

### Docs
- **Connectors**: Add development guides to the [knowledge base](https://github.com/datalens-tech/datalens-backend/blob/main/kb/index.md). [datalens-tech/datalens-backend#494](https://github.com/datalens-tech/datalens-backend/pull/494)


## v1.8.0 (2024-08-05)

### Image versions
- datalens-control-api: 0.2102.2
- datalens-data-api: 0.2102.2
- datalens-ui: 0.1863.0 -> 0.1906.0 ([full changelog](https://github.com/datalens-tech/datalens-ui/compare/v0.1863.0...v0.1906.0))
- datalens-us: 0.224.0

### New features
- **Dashboards**: Add the ability to create group controls on dash. [datalens-tech/datalens-ui#1262](https://github.com/datalens-tech/datalens-ui/pull/1262)

### Bug fixes
- **Dashboards**: Support group controls in old links. [datalens-tech/datalens-ui#1294](https://github.com/datalens-tech/datalens-ui/pull/1294)

### Chores
- **Dashboards**: Refactoring dash components. [datalens-tech/datalens-ui#1263](https://github.com/datalens-tech/datalens-ui/pull/1263)


## v1.7.0 (2024-07-17)

### Image versions
- datalens-control-api: 0.2102.2
- datalens-data-api: 0.2102.2
- datalens-ui: 0.1794.0 -> 0.1863.0 ([full changelog](https://github.com/datalens-tech/datalens-ui/compare/v0.1794.0...v0.1863.0))
- datalens-us: 0.214.0 -> 0.224.0 ([full changelog](https://github.com/datalens-tech/datalens-us/compare/v0.214.0...v0.224.0))

### New features
- **Auth**: Added integration with Zitadel which brings user authentication and vertical roles, see more in [readme](https://github.com/datalens-tech/datalens?tab=readme-ov-file#authentication-beta)
- **Datasets**: Add mass operations for dataset. [datalens-tech/datalens-ui#1147](https://github.com/datalens-tech/datalens-ui/pull/1147)
- **Dashboards**: Support adding values by enter in Possible values dialog of list control. [datalens-tech/datalens-ui#1203](https://github.com/datalens-tech/datalens-ui/pull/1203)
- **General components**: Unify deletion confirm dialogs layout on collections page. [datalens-tech/datalens-ui#1228](https://github.com/datalens-tech/datalens-ui/pull/1228)

### Bug fixes
- **Charts**: Allow rows highlighting for pivot tables without groups. [datalens-tech/datalens-ui#1186](https://github.com/datalens-tech/datalens-ui/pull/1186)
- **Charts**: Fix the display of a tooltip on map charts. [datalens-tech/datalens-ui#1196](https://github.com/datalens-tech/datalens-ui/pull/1196)
- **General components**: Increase max-height in DialogRelatedEntities. [datalens-tech/datalens-ui#1201](https://github.com/datalens-tech/datalens-ui/pull/1201)
- **Charts**: Display shape settings icon for Y2. [datalens-tech/datalens-ui#1211](https://github.com/datalens-tech/datalens-ui/pull/1211)
- **Navigation**: Fix layout of DeleteDialog in workbooks. [datalens-tech/datalens-ui#1256](https://github.com/datalens-tech/datalens-ui/pull/1256)
- **Charts**: Fix coloring zero values (pivot table). [datalens-tech/datalens-ui#1259](https://github.com/datalens-tech/datalens-ui/pull/1259)

### Chores
- **General components**: Upgrade expresskit to 1.3.0 version. [datalens-tech/datalens-ui#1238](https://github.com/datalens-tech/datalens-ui/pull/1238)


## v1.6.0 (2024-06-28)

### Image versions
- datalens-control-api: 0.2102.2
- datalens-data-api: 0.2102.2
- datalens-ui: 0.1765.0 -> 0.1794.0 ([full changelog](https://github.com/datalens-tech/datalens-ui/compare/v0.1765.0...v0.1794.0))
- datalens-us: 0.209.0 -> 0.214.0 ([full changelog](https://github.com/datalens-tech/datalens-us/compare/v0.209.0...v0.214.0))

### New features
- **Auth**: Basic Zitadel integration. [datalens-tech/datalens#137](https://github.com/datalens-tech/datalens/pull/137)
- **General components**: Improve layout on mobile. [datalens-tech/datalens-ui#1168](https://github.com/datalens-tech/datalens-ui/pull/1168)
- **Dashboards**: Add widget background like chart. [datalens-tech/datalens-ui#1099](https://github.com/datalens-tech/datalens-ui/pull/1099)
- **General components**: Enable menu option showing related objects of current object. [datalens-tech/datalens-ui#1172](https://github.com/datalens-tech/datalens-ui/pull/1172)
- **Connectors**: Support `visibility_mode` in connector items. [datalens-tech/datalens-ui#1180](https://github.com/datalens-tech/datalens-ui/pull/1180)

### Tests
- **General components**: Tests improvements. [datalens-tech/datalens-us#130](https://github.com/datalens-tech/datalens-us/pull/130)


## v1.5.0 (2024-06-25)

### Image versions
- datalens-control-api: 0.2091.0 -> 0.2102.2 ([full changelog](https://github.com/datalens-tech/datalens-backend/compare/v0.2091.0...v0.2102.2))
- datalens-data-api: 0.2091.0 -> 0.2102.2 ([full changelog](https://github.com/datalens-tech/datalens-backend/compare/v0.2091.0...v0.2102.2))
- datalens-ui: 0.1765.0
- datalens-us: 0.209.0

### New features
- **Connectors**: Add user-password & oauth auth modes to YDB connector. [datalens-tech/datalens-backend#390](https://github.com/datalens-tech/datalens-backend/pull/390)

### Bug fixes
- **Formula**: Use upper median in case of even number of values. [datalens-tech/datalens-backend#466](https://github.com/datalens-tech/datalens-backend/pull/466)
- **Formula**: Round -0 to 0 in ClickHouse connector. [datalens-tech/datalens-backend#474](https://github.com/datalens-tech/datalens-backend/pull/474)
- **Formula**: Round -0 to 0 in MySQL connector. [datalens-tech/datalens-backend#481](https://github.com/datalens-tech/datalens-backend/pull/481)
- **Datasets**: Return deleted fields on dataset refresh. [datalens-tech/datalens-backend#493](https://github.com/datalens-tech/datalens-backend/pull/493)


## v1.4.0 (2024-06-20)

### Image versions
- datalens-control-api: 0.2091.0
- datalens-data-api: 0.2091.0
- datalens-ui: 0.1741.0 -> 0.1765.0 ([full changelog](https://github.com/datalens-tech/datalens-ui/compare/v0.1741.0...v0.1765.0))
- datalens-us: 0.209.0

### New features
- **Charts**: Add title options for indicator chart. [datalens-tech/datalens-ui#1105](https://github.com/datalens-tech/datalens-ui/pull/1105)
- **Charts**: Add bar-y d3 visualization. [datalens-tech/datalens-ui#1122](https://github.com/datalens-tech/datalens-ui/pull/1122)
- **Datasets**: Toggle dataset preview by default. [datalens-tech/datalens-ui#1046](https://github.com/datalens-tech/datalens-ui/pull/1046)

### Bug fixes
- **Charts**: Fix relative date interval for colors setting. [datalens-tech/datalens-ui#1123](https://github.com/datalens-tech/datalens-ui/pull/1123)
- **Datasets**: Fix error view for PLATFORM_PERMISSION_REQUIRED. [datalens-tech/datalens-ui#1138](https://github.com/datalens-tech/datalens-ui/pull/1138)
- **Navigation**: Add wrapper to workbook action panel left block. [datalens-tech/datalens-ui#1142](https://github.com/datalens-tech/datalens-ui/pull/1142)
- **Dashboards**: Fixed the display of the hint depending on the enabled checkbox. [datalens-tech/datalens-ui#1139](https://github.com/datalens-tech/datalens-ui/pull/1139)
- **Charts**: Fix indicator title for old charts. [datalens-tech/datalens-ui#1151](https://github.com/datalens-tech/datalens-ui/pull/1151)


## v1.3.0 (2024-06-14)

### Image versions
- datalens-control-api: 0.2091.0
- datalens-data-api: 0.2091.0
- datalens-ui: 0.1712.0 -> 0.1741.0 ([full changelog](https://github.com/datalens-tech/datalens-ui/compare/v0.1712.0...v0.1741.0))
- datalens-us: 0.205.0 -> 0.209.0 ([full changelog](https://github.com/datalens-tech/datalens-us/compare/v0.205.0...v0.209.0))

### Bug fixes
- **General components**: Fix yfm image background on light theme. [datalens-tech/datalens-ui#1089](https://github.com/datalens-tech/datalens-ui/pull/1089)
- **Navigation**: Add ability to hide breadcrumbs button when items are selected. [datalens-tech/datalens-ui#1088](https://github.com/datalens-tech/datalens-ui/pull/1088)
- **Dashboards**: Fix empty charts layout that is outside of widget boundaries. [datalens-tech/datalens-ui#1101](https://github.com/datalens-tech/datalens-ui/pull/1101)
- **Charts**: Fixed saving the hint in the wizard chart. [datalens-tech/datalens-ui#1102](https://github.com/datalens-tech/datalens-ui/pull/1102)
- **Datasets**: Show confirmation dialog in case of changing field visibility. [datalens-tech/datalens-ui#1109](https://github.com/datalens-tech/datalens-ui/pull/1109)
- **Charts**: Fixed a bug with sorting by rows in pivot tables. [datalens-tech/datalens-ui#1111](https://github.com/datalens-tech/datalens-ui/pull/1111)
- **Charts**, **Dashboards**: Fix cancellation of request in charts and selectors. [datalens-tech/datalens-ui#1106](https://github.com/datalens-tech/datalens-ui/pull/1106)
- **Dashboards**: Fix overlaying chart layout on dash. [datalens-tech/datalens-ui#1118](https://github.com/datalens-tech/datalens-ui/pull/1118)
- **Charts**: Fix pagination error for table without columns or measures. [datalens-tech/datalens-ui#1116](https://github.com/datalens-tech/datalens-ui/pull/1116)
- **Charts**: Fix date filtration for wizard charts. [datalens-tech/datalens-ui#1115](https://github.com/datalens-tech/datalens-ui/pull/1115)

### Chores
- **Dashboards**: Change empty dash text. [datalens-tech/datalens-ui#1079](https://github.com/datalens-tech/datalens-ui/pull/1079)


## v1.2.0 (2024-06-07)

### Image versions
- datalens-control-api: 0.2091.0
- datalens-data-api: 0.2091.0
- datalens-ui: 0.1685.0 -> 0.1712.0 ([full changelog](https://github.com/datalens-tech/datalens-ui/compare/v0.1685.0...v0.1712.0))
- datalens-us: 0.204.0 -> 0.205.0 ([full changelog](https://github.com/datalens-tech/datalens-us/compare/v0.204.0...v0.205.0))

### New features
- **Dashboards**: Enable Dash DND ActionPanel for opensource production. [datalens-tech/datalens-ui#1063](https://github.com/datalens-tech/datalens-ui/pull/1063)
- **Dashboards**: Hide hint field in selector dialog when hint is not enabled. [datalens-tech/datalens-ui#1061](https://github.com/datalens-tech/datalens-ui/pull/1061)

### Bug fixes
- **General components**: Fix image bg in yfm. [datalens-tech/datalens-ui#1050](https://github.com/datalens-tech/datalens-ui/pull/1050)
- **Charts**: Custom palette for linear indicator. [datalens-tech/datalens-ui#1052](https://github.com/datalens-tech/datalens-ui/pull/1052)
- **Dashboards**: Increase the virtualization limit for dash tabs. [datalens-tech/datalens-ui#1058](https://github.com/datalens-tech/datalens-ui/pull/1058)
- **Dashboards**: Fix sub dialog width for defaults values. [datalens-tech/datalens-ui#1060](https://github.com/datalens-tech/datalens-ui/pull/1060)
- **Charts**: Fix ignore nulls behaviour. [datalens-tech/datalens-ui#1065](https://github.com/datalens-tech/datalens-ui/pull/1065)
- **Charts**: Add secondary layers list to ignore. [datalens-tech/datalens-ui#1066](https://github.com/datalens-tech/datalens-ui/pull/1066)
- **Charts**: Fix default behaviour for area. [datalens-tech/datalens-ui#1071](https://github.com/datalens-tech/datalens-ui/pull/1071)
- **Dashboards**: Fix chart-chart filtering when number parameter is passed. [datalens-tech/datalens-ui#1073](https://github.com/datalens-tech/datalens-ui/pull/1073)
- **Dashboards**: Fix mobile selectors hint. [datalens-tech/datalens-ui#1078](https://github.com/datalens-tech/datalens-ui/pull/1078)
- **Navigation**: Fix dashboard copy\duplicate action. [datalens-tech/datalens-ui#1080](https://github.com/datalens-tech/datalens-ui/pull/1080)

### Security
- **General components**: Add express trust proxy number param. [datalens-tech/datalens-ui#1082](https://github.com/datalens-tech/datalens-ui/pull/1082)


## v1.1.0 (2024-06-05)

### Image versions
- datalens-control-api: 0.2091.0
- datalens-data-api: 0.2091.0
- datalens-ui: 0.1675.0 -> 0.1685.0 ([full changelog](https://github.com/datalens-tech/datalens-ui/compare/v0.1675.0...v0.1685.0))
- datalens-us: 0.204.0

### New features
- **Dashboards**. Remove flag ShowDashWidgetBg (enable feature without flag). [datalens-tech/datalens-ui#1044](https://github.com/datalens-tech/datalens-ui/pull/1044)

### Bug fixes
- **Dashboards**. Add min height equals to 2 rows for autoheight widgets. [datalens-tech/datalens-ui#1042](https://github.com/datalens-tech/datalens-ui/pull/1042)
- **Dashboards**. Fix link of dataset in 'Open' dataset button in selector modal. [datalens-tech/datalens-ui#1043](https://github.com/datalens-tech/datalens-ui/pull/1043)
- **Dashboards**. Fix values of presets in Control dialog. [datalens-tech/datalens-ui#1045](https://github.com/datalens-tech/datalens-ui/pull/1045)
- **Dashboards**. Fix paste error while paste chart in not saved folder dash. [datalens-tech/datalens-ui#1048](https://github.com/datalens-tech/datalens-ui/pull/1048)


## v1.0.0 (2024-05-31)

### Changes
- Introducing the new versioning system


## 2024-05-30

- datalens-control-api: 0.2080.0 -> 0.2091.0
- datalens-data-api: 0.2080.0 -> 0.2091.0

### Changes

- Add IMAGE markup formula ([backend:#422](https://github.com/datalens-tech/datalens-backend/pull/422))
- Add load_preview_by_default field to datasets ([backend:#433](https://github.com/datalens-tech/datalens-backend/pull/433))
- Add rate limiting config ([backend:#441](https://github.com/datalens-tech/datalens-backend/pull/441))
- Add trace_id to logging contexts ([backend:#442](https://github.com/datalens-tech/datalens-backend/pull/442))

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
