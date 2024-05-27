## v1.6.0 (2024-05-27)

### Image versions
- datalens-control-api: 0.2088.0-rc.1
- datalens-data-api: 0.2088.0-rc.1
- datalens-ui: 0.1370.0 -> 0.1380.0 ([full changelog](https://github.com/datalens-tech/datalens-ui/compare/v0.1370.0...v0.1380.0))
- datalens-us: 0.195.0 -> 0.198.0 ([full changelog](https://github.com/datalens-tech/datalens-us/compare/v0.195.0...v0.198.0))

### Changes
- Add dnd for sorting manual values on settings. [datalens-tech/datalens-ui#677](https://github.com/datalens-tech/datalens-ui/pull/677)


## v1.5.0 (2024-05-27)

### Image versions
- datalens-control-api: 0.2087.0-rc.1 -> 0.2088.0-rc.1 ([full changelog](https://github.com/datalens-tech/datalens-backend/compare/v0.2087.0-rc.1...v0.2088.0-rc.1))
- datalens-data-api: 0.2087.0-rc.1 -> 0.2088.0-rc.1 ([full changelog](https://github.com/datalens-tech/datalens-backend/compare/v0.2087.0-rc.1...v0.2088.0-rc.1))
- datalens-ui: 0.1360.0 -> 0.1370.0 ([full changelog](https://github.com/datalens-tech/datalens-ui/compare/v0.1360.0...v0.1370.0))
- datalens-us: 0.190.0 -> 0.195.0 ([full changelog](https://github.com/datalens-tech/datalens-us/compare/v0.190.0...v0.195.0))

### Changes
- Disable old relations tests by flag. [datalens-tech/datalens-ui#672](https://github.com/datalens-tech/datalens-ui/pull/672)
- Remove stub for workbook isolation interruption. [datalens-tech/datalens-ui#670](https://github.com/datalens-tech/datalens-ui/pull/670)
- Fix E2E report on test failure. [datalens-tech/datalens-ui#674](https://github.com/datalens-tech/datalens-ui/pull/674)
- fix dataLabel for bar chart. [datalens-tech/datalens-ui#675](https://github.com/datalens-tech/datalens-ui/pull/675)
- Fix metric page view. [datalens-tech/datalens-ui#676](https://github.com/datalens-tech/datalens-ui/pull/676)
- Dialog relations fix & improve disconnect action. [datalens-tech/datalens-ui#669](https://github.com/datalens-tech/datalens-ui/pull/669)
- Fix axis mode for combined chart. [datalens-tech/datalens-ui#678](https://github.com/datalens-tech/datalens-ui/pull/678)
- Refactored wizards geolayer tests. [datalens-tech/datalens-ui#679](https://github.com/datalens-tech/datalens-ui/pull/679)
- Up markdown-it-link-attributes. [datalens-tech/datalens-ui#680](https://github.com/datalens-tech/datalens-ui/pull/680)
- Fix "Connection terminated unexpectedly" from knex. [datalens-tech/datalens-us#111](https://github.com/datalens-tech/datalens-us/pull/111)
- Fix deletion of workbooks when deleting a collection. [datalens-tech/datalens-us#112](https://github.com/datalens-tech/datalens-us/pull/112)
- build(deps): bump express from 4.18.2 to 4.19.2. [datalens-tech/datalens-us#105](https://github.com/datalens-tech/datalens-us/pull/105)
- build(deps): bump follow-redirects from 1.15.2 to 1.15.6. [datalens-tech/datalens-us#94](https://github.com/datalens-tech/datalens-us/pull/94)
- Update snyk-container.yml. [datalens-tech/datalens-us#113](https://github.com/datalens-tech/datalens-us/pull/113)
- Fix for mypy. [datalens-tech/datalens-backend#449](https://github.com/datalens-tech/datalens-backend/pull/449)


## v1.4.0 (2024-05-26)

### Image versions
- datalens-control-api: 0.2080.0 -> 0.2087.0-rc.1 ([full changelog](https://github.com/datalens-tech/datalens-backend/compare/v0.2080.0...v0.2087.0-rc.1))
- datalens-data-api: 0.2080.0 -> 0.2087.0-rc.1 ([full changelog](https://github.com/datalens-tech/datalens-backend/compare/v0.2080.0...v0.2087.0-rc.1))
- datalens-ui: 0.1350.0 -> 0.1360.0 ([full changelog](https://github.com/datalens-tech/datalens-ui/compare/v0.1350.0...v0.1360.0))
- datalens-us: 0.180.0 -> 0.190.0 ([full changelog](https://github.com/datalens-tech/datalens-us/compare/v0.180.0...v0.190.0))

### Other
- Add user-info type to markup component. [datalens-tech/datalens-ui#642](https://github.com/datalens-tech/datalens-ui/pull/642)
- Add autoheight support in markup. [datalens-tech/datalens-ui#656](https://github.com/datalens-tech/datalens-ui/pull/656)
- Fix axis mode for combined chart. [datalens-tech/datalens-ui#660](https://github.com/datalens-tech/datalens-ui/pull/660)
- Add support basic tab for new connection based control. [datalens-tech/datalens-ui#658](https://github.com/datalens-tech/datalens-ui/pull/658)
- Remove unused routes for connection & datasets. [datalens-tech/datalens-ui#661](https://github.com/datalens-tech/datalens-ui/pull/661)
- Add custom error for workbook isolation interruption. [datalens-tech/datalens-ui#630](https://github.com/datalens-tech/datalens-ui/pull/630)
- Fix invalid popup height. [datalens-tech/datalens-ui#664](https://github.com/datalens-tech/datalens-ui/pull/664)
- Moved isEntryId and extractEntryId functions to registry.common.functions. [datalens-tech/datalens-ui#663](https://github.com/datalens-tech/datalens-ui/pull/663)
- Fix publish platform external contrib. [datalens-tech/datalens-ui#667](https://github.com/datalens-tech/datalens-ui/pull/667)
- Add manual dispatch trigger to publish platform. [datalens-tech/datalens-ui#668](https://github.com/datalens-tech/datalens-ui/pull/668)
- Add connection selector for connection based control configuration tab. [datalens-tech/datalens-ui#666](https://github.com/datalens-tech/datalens-ui/pull/666)
- Add new error - INCORRECT_ACTION. [datalens-tech/datalens-us#100](https://github.com/datalens-tech/datalens-us/pull/100)
- Add support configurable SSL for postgres. [datalens-tech/datalens-us#101](https://github.com/datalens-tech/datalens-us/pull/101)
- Enable feature WorkbookIsolationEnabled. [datalens-tech/datalens-us#103](https://github.com/datalens-tech/datalens-us/pull/103)
- Fixes in D3 Demo dash. [datalens-tech/datalens-us#104](https://github.com/datalens-tech/datalens-us/pull/104)
- Support for multiple master tokens. [datalens-tech/datalens-us#102](https://github.com/datalens-tech/datalens-us/pull/102)
- Remove data from CREATE_STATE_REQUEST log. [datalens-tech/datalens-us#106](https://github.com/datalens-tech/datalens-us/pull/106)
- Change instance service error code. [datalens-tech/datalens-us#107](https://github.com/datalens-tech/datalens-us/pull/107)
- Changes in embeds. [datalens-tech/datalens-us#108](https://github.com/datalens-tech/datalens-us/pull/108)
- Fix tests. [datalens-tech/datalens-us#109](https://github.com/datalens-tech/datalens-us/pull/109)
- Renaming in embedding. [datalens-tech/datalens-us#110](https://github.com/datalens-tech/datalens-us/pull/110)
- Add 1,2,3 args implementation of image markup. [datalens-tech/datalens-backend#422](https://github.com/datalens-tech/datalens-backend/pull/422)
- Readonly transaction in MySQL connector. [datalens-tech/datalens-backend#389](https://github.com/datalens-tech/datalens-backend/pull/389)
- Make fake tenant parametrizable by fixture in tests. [datalens-tech/datalens-backend#424](https://github.com/datalens-tech/datalens-backend/pull/424)
- Moved some request logging tools to classes to enable their customization. [datalens-tech/datalens-backend#425](https://github.com/datalens-tech/datalens-backend/pull/425)
- Added module name to dba_cls serialization. [datalens-tech/datalens-backend#426](https://github.com/datalens-tech/datalens-backend/pull/426)
- Introduced DEFAULT_INTERNAL_SERVER_ERROR_DATA. [datalens-tech/datalens-backend#427](https://github.com/datalens-tech/datalens-backend/pull/427)
- Allow for multiple PUBLIC_API_KEYs to enable its rotation. [datalens-tech/datalens-backend#429](https://github.com/datalens-tech/datalens-backend/pull/429)
- DOCSUP-66650: Fixes in function ref texts (part 2). [datalens-tech/datalens-backend#423](https://github.com/datalens-tech/datalens-backend/pull/423)
- COLOR func description update. [datalens-tech/datalens-backend#434](https://github.com/datalens-tech/datalens-backend/pull/434)
- Add a headers fixture for all connector api tests. [datalens-tech/datalens-backend#431](https://github.com/datalens-tech/datalens-backend/pull/431)
- Add field load_preview_by_default. [datalens-tech/datalens-backend#433](https://github.com/datalens-tech/datalens-backend/pull/433)
- make ConnectorAvailability dynamic. [datalens-tech/datalens-backend#435](https://github.com/datalens-tech/datalens-backend/pull/435)
- Add missing headers in the connection base suite. [datalens-tech/datalens-backend#437](https://github.com/datalens-tech/datalens-backend/pull/437)
- Mark test_insert_fetch as flaky. [datalens-tech/datalens-backend#436](https://github.com/datalens-tech/datalens-backend/pull/436)
- Allow to pass auth_data to the auth_trust_middleware. [datalens-tech/datalens-backend#439](https://github.com/datalens-tech/datalens-backend/pull/439)
- pass tenant to get_available_connectors. [datalens-tech/datalens-backend#440](https://github.com/datalens-tech/datalens-backend/pull/440)
- Clarify publication error text a bit. [datalens-tech/datalens-backend#432](https://github.com/datalens-tech/datalens-backend/pull/432)
- feat: enable rate_limiter settings. [datalens-tech/datalens-backend#441](https://github.com/datalens-tech/datalens-backend/pull/441)
- chore: fix DATALENS_UI_FOLDER for e2e taskfile. [datalens-tech/datalens-backend#444](https://github.com/datalens-tech/datalens-backend/pull/444)
- Add unit tests for the supported functions registry. [datalens-tech/datalens-backend#446](https://github.com/datalens-tech/datalens-backend/pull/446)
- Add unit tests for the native type schema. [datalens-tech/datalens-backend#447](https://github.com/datalens-tech/datalens-backend/pull/447)
- Add trace_id to logging contexts. [datalens-tech/datalens-backend#442](https://github.com/datalens-tech/datalens-backend/pull/442)
- Add data to ut reporting. [datalens-tech/datalens-backend#445](https://github.com/datalens-tech/datalens-backend/pull/445)


## v1.3.0 (2024-05-26)

### Image versions
- datalens-control-api: 0.2066.0-rc.1 -> 0.2080.0 ([full changelog](https://github.com/datalens-tech/datalens-backend/compare/v0.2066.0-rc.1...v0.2080.0))
- datalens-data-api: 0.2066.0-rc.1 -> 0.2080.0 ([full changelog](https://github.com/datalens-tech/datalens-backend/compare/v0.2066.0-rc.1...v0.2080.0))
- datalens-ui: 0.1330.0 -> 0.1350.0 ([full changelog](https://github.com/datalens-tech/datalens-ui/compare/v0.1330.0...v0.1350.0))
- datalens-us: 0.170.0 -> 0.180.0 ([full changelog](https://github.com/datalens-tech/datalens-us/compare/v0.170.0...v0.180.0))

### Other
- Correct handle of no data case in markup wizard chart. [datalens-tech/datalens-ui#631](https://github.com/datalens-tech/datalens-ui/pull/631)
- Fix background color for null values in flat table. [datalens-tech/datalens-ui#634](https://github.com/datalens-tech/datalens-ui/pull/634)
- Add missing key. [datalens-tech/datalens-ui#635](https://github.com/datalens-tech/datalens-ui/pull/635)
- Fix title selection for segments. [datalens-tech/datalens-ui#637](https://github.com/datalens-tech/datalens-ui/pull/637)
- Fix rendering chart when line name matches with JavaScript Object properties. [datalens-tech/datalens-ui#639](https://github.com/datalens-tech/datalens-ui/pull/639)
- Update @gravity-ui/gateway to v2. [datalens-tech/datalens-ui#632](https://github.com/datalens-tech/datalens-ui/pull/632)
- Remove market_couriers connector data. [datalens-tech/datalens-ui#641](https://github.com/datalens-tech/datalens-ui/pull/641)
- Add keys consistency check for i18n keysets. [datalens-tech/datalens-ui#643](https://github.com/datalens-tech/datalens-ui/pull/643)
- Improve group controls improvements pt3. [datalens-tech/datalens-ui#616](https://github.com/datalens-tech/datalens-ui/pull/616)
- Update publish platform permission. [datalens-tech/datalens-ui#640](https://github.com/datalens-tech/datalens-ui/pull/640)
- Update mdb form i18n. [datalens-tech/datalens-ui#644](https://github.com/datalens-tech/datalens-ui/pull/644)
- New relations improvements. [datalens-tech/datalens-ui#647](https://github.com/datalens-tech/datalens-ui/pull/647)
- Update @gravity-ui/page-constructor to v4.52.0. [datalens-tech/datalens-ui#650](https://github.com/datalens-tech/datalens-ui/pull/650)
- Remove x-charts-id subrequest header. [datalens-tech/datalens-ui#646](https://github.com/datalens-tech/datalens-ui/pull/646)
- Add dashboard helpers for filtering tests. [datalens-tech/datalens-ui#605](https://github.com/datalens-tech/datalens-ui/pull/605)
- Use local chart editor templates. [datalens-tech/datalens-ui#606](https://github.com/datalens-tech/datalens-ui/pull/606)
- Fix aliases validation for the same dataset. [datalens-tech/datalens-ui#652](https://github.com/datalens-tech/datalens-ui/pull/652)
- Temporally disable tests. [datalens-tech/datalens-ui#657](https://github.com/datalens-tech/datalens-ui/pull/657)
- Add problematic alias to error output. [datalens-tech/datalens-ui#654](https://github.com/datalens-tech/datalens-ui/pull/654)
- Fix colors for the custom palette in the combined chart. [datalens-tech/datalens-ui#655](https://github.com/datalens-tech/datalens-ui/pull/655)
- Data fetcher proxied headers refactoring. [datalens-tech/datalens-ui#651](https://github.com/datalens-tech/datalens-ui/pull/651)
- ci: add DOCKER_HOST to env Taskfile. [datalens-tech/datalens-backend#374](https://github.com/datalens-tech/datalens-backend/pull/374)
- BI-5267 Add execution timeout to PG connector; use readonly transactions in PG. [datalens-tech/datalens-backend#375](https://github.com/datalens-tech/datalens-backend/pull/375)
- Fix source execution timeout for ClickHouse by lowering it. [datalens-tech/datalens-backend#376](https://github.com/datalens-tech/datalens-backend/pull/376)
- Preparing for migrations. [datalens-tech/datalens-us#87](https://github.com/datalens-tech/datalens-us/pull/87)
- Fix billingInstanceServiceIdPrefix missed error code. [datalens-tech/datalens-us#90](https://github.com/datalens-tech/datalens-us/pull/90)
- Add execution timeout to MSSQL connector. [datalens-tech/datalens-backend#377](https://github.com/datalens-tech/datalens-backend/pull/377)
- Change YADOCS_INVALID_PUBLIC_LINK_PREFIX from 500 to 400. [datalens-tech/datalens-backend#379](https://github.com/datalens-tech/datalens-backend/pull/379)
- Add two billing migrations. [datalens-tech/datalens-us#89](https://github.com/datalens-tech/datalens-us/pull/89)
- Run US migrations before tests. [datalens-tech/datalens-backend#371](https://github.com/datalens-tech/datalens-backend/pull/371)
- Remove uwsgi from file uploader. [datalens-tech/datalens-backend#380](https://github.com/datalens-tech/datalens-backend/pull/380)
- Up jest. [datalens-tech/datalens-us#91](https://github.com/datalens-tech/datalens-us/pull/91)
- Run mypy in parallel. [datalens-tech/datalens-backend#373](https://github.com/datalens-tech/datalens-backend/pull/373)
- execute-mypy-multi: make parameters named, run mypy in parallel. [datalens-tech/datalens-backend#381](https://github.com/datalens-tech/datalens-backend/pull/381)
- Add returning full collection models in getCollectionBreadcrumbs. [datalens-tech/datalens-us#93](https://github.com/datalens-tech/datalens-us/pull/93)
- Add new billing fields. [datalens-tech/datalens-us#92](https://github.com/datalens-tech/datalens-us/pull/92)
- fix some mypy in dl_formula.shortcuts. [datalens-tech/datalens-backend#383](https://github.com/datalens-tech/datalens-backend/pull/383)
- Improve workbook isolation. [datalens-tech/datalens-us#96](https://github.com/datalens-tech/datalens-us/pull/96)
- Fix US storage schema of yadocs connection source. [datalens-tech/datalens-backend#386](https://github.com/datalens-tech/datalens-backend/pull/386)
- remove an erroneous type check on making a join expression. [datalens-tech/datalens-backend#385](https://github.com/datalens-tech/datalens-backend/pull/385)
- Add some profiling to mutation caches; propagate allow_slave up to dataset preparer. [datalens-tech/datalens-backend#378](https://github.com/datalens-tech/datalens-backend/pull/378)
- Add npm migration scripts. [datalens-tech/datalens-us#97](https://github.com/datalens-tech/datalens-us/pull/97)
- Switch to port 8083. [datalens-tech/datalens-us#98](https://github.com/datalens-tech/datalens-us/pull/98)
- Update US port. [datalens-tech/datalens-backend#392](https://github.com/datalens-tech/datalens-backend/pull/392)
- Upgrade gitpython to >=3.1.41. [datalens-tech/datalens-backend#393](https://github.com/datalens-tech/datalens-backend/pull/393)
- feat: add ActionNonStreamExecuteQuery to RQE. [datalens-tech/datalens-backend#388](https://github.com/datalens-tech/datalens-backend/pull/388)
- Add createWorkbook to api. [datalens-tech/datalens-us#99](https://github.com/datalens-tech/datalens-us/pull/99)
- Allow NULL as a default for LAG in CH. [datalens-tech/datalens-backend#395](https://github.com/datalens-tech/datalens-backend/pull/395)
- Add avatar relation "required" field to the storage schema. [datalens-tech/datalens-backend#399](https://github.com/datalens-tech/datalens-backend/pull/399)
- Fix 'argument not bound to an attrs class' mypy errors. [datalens-tech/datalens-backend#394](https://github.com/datalens-tech/datalens-backend/pull/394)
- fix: rqe_execute_request_mode env_var_converter. [datalens-tech/datalens-backend#400](https://github.com/datalens-tech/datalens-backend/pull/400)
- Fix UpdateConnectionDataRequestSchema. [datalens-tech/datalens-backend#401](https://github.com/datalens-tech/datalens-backend/pull/401)
- Print affected packages in router. [datalens-tech/datalens-backend#403](https://github.com/datalens-tech/datalens-backend/pull/403)
- Add COLOR, SIZE, BR to docs & suggest. [datalens-tech/datalens-backend#382](https://github.com/datalens-tech/datalens-backend/pull/382)
- Revert CH max_execution_time parameter. [datalens-tech/datalens-backend#404](https://github.com/datalens-tech/datalens-backend/pull/404)
- Fix some type annotations, cleanup. [datalens-tech/datalens-backend#397](https://github.com/datalens-tech/datalens-backend/pull/397)
- feat: add dl_rate_limiter. [datalens-tech/datalens-backend#402](https://github.com/datalens-tech/datalens-backend/pull/402)
- feat: remove bitrix join experimental flag. [datalens-tech/datalens-backend#406](https://github.com/datalens-tech/datalens-backend/pull/406)
- DOCSUP-66197: Fixes in function ref texts. [datalens-tech/datalens-backend#391](https://github.com/datalens-tech/datalens-backend/pull/391)
- Added overridable method get_session_cookies to AiohttpDBAdapter. [datalens-tech/datalens-backend#407](https://github.com/datalens-tech/datalens-backend/pull/407)
- Enable mysql OS. [datalens-tech/datalens-backend#409](https://github.com/datalens-tech/datalens-backend/pull/409)
- add custom error code for workbook isolation error. [datalens-tech/datalens-backend#358](https://github.com/datalens-tech/datalens-backend/pull/358)
- Turn on greenplum os. [datalens-tech/datalens-backend#410](https://github.com/datalens-tech/datalens-backend/pull/410)
- Image markup. [datalens-tech/datalens-backend#408](https://github.com/datalens-tech/datalens-backend/pull/408)
- feat: add app rate_limiter settings. [datalens-tech/datalens-backend#411](https://github.com/datalens-tech/datalens-backend/pull/411)
- tests: mark rate_limiter middleware tests flaky. [datalens-tech/datalens-backend#412](https://github.com/datalens-tech/datalens-backend/pull/412)
- replace some TypeVars with typing_extensions.Self. [datalens-tech/datalens-backend#396](https://github.com/datalens-tech/datalens-backend/pull/396)
- Refine required relations & JOINs optimization. [datalens-tech/datalens-backend#414](https://github.com/datalens-tech/datalens-backend/pull/414)
- fix: yet another fix for rate limiter settings. [datalens-tech/datalens-backend#415](https://github.com/datalens-tech/datalens-backend/pull/415)
- fix: yet another fix for rate limiter settings. [datalens-tech/datalens-backend#416](https://github.com/datalens-tech/datalens-backend/pull/416)
- fix: rate_limiter config. [datalens-tech/datalens-backend#417](https://github.com/datalens-tech/datalens-backend/pull/417)
- Move YQL datetime functions to the YDB connector package. [datalens-tech/datalens-backend#413](https://github.com/datalens-tech/datalens-backend/pull/413)
- DLHELP-9856: add more logs to file connectors. [datalens-tech/datalens-backend#418](https://github.com/datalens-tech/datalens-backend/pull/418)
- feat: temporarily disable rate_limiter settings. [datalens-tech/datalens-backend#419](https://github.com/datalens-tech/datalens-backend/pull/419)
- Moved get_data_source_template_templates method implementation from ConnectionCHYTToken to BaseConnectionCHYT. [datalens-tech/datalens-backend#421](https://github.com/datalens-tech/datalens-backend/pull/421)
- Markup image fix. [datalens-tech/datalens-backend#420](https://github.com/datalens-tech/datalens-backend/pull/420)


## v1.2.0 (2024-05-26)

### Image versions
- datalens-control-api: 0.2063.0-rc.1 -> 0.2066.0-rc.1 ([full changelog](https://github.com/datalens-tech/datalens-backend/compare/v0.2063.0-rc.1...v0.2066.0-rc.1))
- datalens-data-api: 0.2063.0-rc.1 -> 0.2066.0-rc.1 ([full changelog](https://github.com/datalens-tech/datalens-backend/compare/v0.2063.0-rc.1...v0.2066.0-rc.1))
- datalens-ui: 0.1316.0 -> 0.1330.0 ([full changelog](https://github.com/datalens-tech/datalens-ui/compare/v0.1316.0...v0.1330.0))
- datalens-us: 0.159.0 -> 0.170.0 ([full changelog](https://github.com/datalens-tech/datalens-us/compare/v0.159.0...v0.170.0))

### Breaking changes
- Fix bigquery dependencies (add a required pyarrow extra). [datalens-tech/datalens-backend#365](https://github.com/datalens-tech/datalens-backend/pull/365)
- Implemented typed query processor factories in SR. [datalens-tech/datalens-backend#367](https://github.com/datalens-tech/datalens-backend/pull/367)

### New features
- **Connectors**, **Datasets**. Removing ExecutorBasedMixin. Part 2. [datalens-tech/datalens-backend#345](https://github.com/datalens-tech/datalens-backend/pull/345)

### CI
- Fixed circular import dependencies in api connector. [datalens-tech/datalens-backend#344](https://github.com/datalens-tech/datalens-backend/pull/344)

### Other
- Improve GroupControls behavior. [datalens-tech/datalens-ui#596](https://github.com/datalens-tech/datalens-ui/pull/596)
- Fix the test falling at midnight. [datalens-tech/datalens-ui#618](https://github.com/datalens-tech/datalens-ui/pull/618)
- Fix i18n flow. [datalens-tech/datalens-ui#617](https://github.com/datalens-tech/datalens-ui/pull/617)
- Fix export forbidden fail in chartEditor. [datalens-tech/datalens-ui#620](https://github.com/datalens-tech/datalens-ui/pull/620)
- Fix buttons position on mobile fullscreen. [datalens-tech/datalens-ui#603](https://github.com/datalens-tech/datalens-ui/pull/603)
- Fix dashboard publish link xss. [datalens-tech/datalens-ui#612](https://github.com/datalens-tech/datalens-ui/pull/612)
- Fix resolveUsersByIds mock. [datalens-tech/datalens-ui#621](https://github.com/datalens-tech/datalens-ui/pull/621)
- Fix displaying alias modal on select ignore link. [datalens-tech/datalens-ui#623](https://github.com/datalens-tech/datalens-ui/pull/623)
- Workbook page redesign. [datalens-tech/datalens-ui#562](https://github.com/datalens-tech/datalens-ui/pull/562)
- Add changelog label to release comment. [datalens-tech/datalens-ui#626](https://github.com/datalens-tech/datalens-ui/pull/626)
- Disable test and lints for translation branches. [datalens-tech/datalens-ui#625](https://github.com/datalens-tech/datalens-ui/pull/625)
- Add new label to release. [datalens-tech/datalens-ui#627](https://github.com/datalens-tech/datalens-ui/pull/627)
- Change onRender -> onLoad for MarkupWidget. [datalens-tech/datalens-ui#629](https://github.com/datalens-tech/datalens-ui/pull/629)
- Update docker-compose.e2e.yml. [datalens-tech/datalens-ui#628](https://github.com/datalens-tech/datalens-ui/pull/628)
- Update @gravity-ui/gateway. [datalens-tech/datalens-us#77](https://github.com/datalens-tech/datalens-us/pull/77)
- Add migration for change index tenants_billing_instance_service_id_id on UNIQUE. [datalens-tech/datalens-us#76](https://github.com/datalens-tech/datalens-us/pull/76)
- Some naming fixes. [datalens-tech/datalens-us#78](https://github.com/datalens-tech/datalens-us/pull/78)
- Remove favorites migration. [datalens-tech/datalens-us#80](https://github.com/datalens-tech/datalens-us/pull/80)
- Add foreign key (entry_id, tenant_id) for favorites (2). [datalens-tech/datalens-us#81](https://github.com/datalens-tech/datalens-us/pull/81)
- Add yadocs to file connections. [datalens-tech/datalens-us#82](https://github.com/datalens-tech/datalens-us/pull/82)
- Added branding column to tenants table. [datalens-tech/datalens-us#85](https://github.com/datalens-tech/datalens-us/pull/85)
- Specify correct data source spec in GP dsrc migrator (inherit GP dsrc migrator from PG). [datalens-tech/datalens-backend#336](https://github.com/datalens-tech/datalens-backend/pull/336)
- Move some model-related modules to dl_model_tools. [datalens-tech/datalens-backend#363](https://github.com/datalens-tech/datalens-backend/pull/363)
- Moved a couple of modules out of dl_core. [datalens-tech/datalens-backend#362](https://github.com/datalens-tech/datalens-backend/pull/362)
- Fixes in function ref texts. [datalens-tech/datalens-backend#364](https://github.com/datalens-tech/datalens-backend/pull/364)
- Add existing operation codes for us client. [datalens-tech/datalens-backend#369](https://github.com/datalens-tech/datalens-backend/pull/369)
- Get rid of templateTenantId. [datalens-tech/datalens-us#83](https://github.com/datalens-tech/datalens-us/pull/83)
- Add new error for existing serviceInstanceIdPrefix in cofig. [datalens-tech/datalens-us#88](https://github.com/datalens-tech/datalens-us/pull/88)
- Added branding handlers. [datalens-tech/datalens-us#86](https://github.com/datalens-tech/datalens-us/pull/86)
- **Connectors**. Implemented CachedTypedQueryProcessor. [datalens-tech/datalens-backend#372](https://github.com/datalens-tech/datalens-backend/pull/372)


## v1.1.0 (2024-03-17)

### Image versions
- datalens-control-api: 0.2061.0-rc.1 -> 0.2063.0-rc.1 ([full changelog](https://github.com/datalens-tech/datalens-backend/compare/v0.2061.0-rc.1...v0.2063.0-rc.1))
- datalens-data-api: 0.2061.0-rc.1 -> 0.2063.0-rc.1 ([full changelog](https://github.com/datalens-tech/datalens-backend/compare/v0.2061.0-rc.1...v0.2063.0-rc.1))
- datalens-ui: 0.1316.0
- datalens-us: 0.159.0
- test update

### Other
- ci: release prerelease in parallel with build images step. [datalens-tech/datalens-backend#361](https://github.com/datalens-tech/datalens-backend/pull/361)
- Remove useless null check. [datalens-tech/datalens-backend#360](https://github.com/datalens-tech/datalens-backend/pull/360)


## v1.0.0 (2024-05-26)

### Changes
- Introduce the new versioning system


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
