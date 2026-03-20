# mysql-play

My [MySQL](https://www.mysql.com/)/[MariaDB](https://mariadb.org/) playground
(including sample schemas, examples of new features, experimental queries,
test cases, utility routines, fun scripts, etc.)

## Contents

* [DataMask](Datamask) - data masking routines.
* [Debug](Debug) - examples for tracing stored routines.
* [Examples](Examples):
  - [AI](Examples/AI) - examples related to `VECTOR` datatype and vector search;
  - [Admin](Examples/Admin) - examples related to administration;
  - [CHECK](Examples/CHECK) - examples with `CHECK` constraints;
  - [Index](Examples/Index) - examples with indexes (e.g. functional, multi-valued, etc.);
  - [JSON](Examples/JSON) - examples with `JSON` data type and functions;
  - [Join](Examples/Join) - examples with joins (e.g. lateral, hash, etc.);
  - [Math](Examples/Math) - examples related to mathematics;
  - [Optimizer](Examples/Optimizer) - examples related to optimization (e.g. histogram, `EXPLAIN` statements, etc.);
  - [PSM](Examples/PSM) - examples with Persistent Stored Modules (i.e. stored routines);
  - [Performance](Examples/Performance) - examples related to performance;
  - [SELECT](Examples/SELECT) - examples with `SELECT` statements;
  - [Schema](Examples/Schema) - sample schemas and operations on schemas;
  - [Sets](Examples/Sets) - examples with SQL set operators (e.g. `EXCEPT`, `INTERSECT` and `MINUS` statements);
  - [Spatial](Examples/Spatial) - examples with spatial data and functions;
  - [TABLE](Examples/TABLE) - examples with `CREATE TABLE` and `TABLE` statements;
  - [Temporal](Examples/Temporal) - examples for application and system versioned tables;
  - [VALUES](Examples/VALUES) - examples with `VALUES` statement;
  - [Views](Examples/Views) - examples with views;
  - [WITH](Examples/WITH) - examples with CTEs (e.g. `WITH` statements);
  - [Window](Examples/Window) - examples with window functions (e.g. `OVER`, `PARTITION BY` clauses).
* [Fun](Fun) - fun scripts :-)
* [Misc](Misc) - miscellaneous scripts;
* [Scripts](Scripts) - utility scripts in AWK, Bash and Perl.

## My MySQL bugs

This is a list of all MySQL bugs that I reported over the years with their
status and details. The test cases for some of them could be found in this
repository as marked below.

|Bug|Submitted|Synopsis|Status|Last updated|Details|
|---|---------|--------|------|------------|-------|
|[108789](https://bugs.mysql.com/bug.php?id=108789)|2022-10-15|OverflowBitsetTest.ZeroInitialize failure on x86|Unsupported|2022-11-08||
|[107147](https://bugs.mysql.com/bug.php?id=107147)|2022-04-28|Slow server upgrades with MySQL 8|Not a Bug|2022-11-08||
|[106721](https://bugs.mysql.com/bug.php?id=106721)|2022-03-13|Hash join test failure on x86|Closed|2022-04-28||
|[103397](https://bugs.mysql.com/bug.php?id=103397)|2021-04-21|More meaninful message for missing include directory|Closed|2021-06-14||
|[102466](https://bugs.mysql.com/bug.php?id=102466)|2021-02-03|Wrong default for performance_schema_digests_size on Statement Summary Tables|Closed|2021-02-05||
|[102364](https://bugs.mysql.com/bug.php?id=102364)|2021-01-25|MySQL Workbench 8.0.23 unable to start due to wrong system python paths|Duplicate|2021-04-15||
|[102308](https://bugs.mysql.com/bug.php?id=102308)|2021-01-20|Compilation error for Boolean literal in sql/mysqld.cc with MySQL 8.0.23|Closed|2021-01-22||
|[101231](https://bugs.mysql.com/bug.php?id=101231)|2020-10-19|Min required Protobuf version not properly detected|Closed|2020-11-10||
|[101230](https://bugs.mysql.com/bug.php?id=101230)|2020-10-19|Please, specify required Protobuf version in docs and release notes|Can't repeat|2020-11-19||
|[98266](https://bugs.mysql.com/bug.php?id=98266)|2020-01-17|Workbench editor shows syntax error on TABLE statement|Closed|2020-04-01||
|[98263](https://bugs.mysql.com/bug.php?id=98263)|2020-01-17|Workbench editor shows syntax error on VALUES statement|Closed|2020-04-01||
|[97595](https://bugs.mysql.com/bug.php?id=97595)|2019-11-12|Wrong visual explain for queries using window functions in Workbench|Verified|2019-11-20||
|[97492](https://bugs.mysql.com/bug.php?id=97492)|2019-11-05|Print unit for timings in EXPLAIN ANALYZE|Closed|2019-11-06||
|[97416](https://bugs.mysql.com/bug.php?id=97416)|2019-10-29|EXPLAIN ANALYZE shows syntax error in SQL editor|Closed|2020-01-14||
|[97282](https://bugs.mysql.com/bug.php?id=97282)|2019-10-18|Integrate TREE explain format and EXPLAIN ANALYZE in Workbench|Verified|2019-10-30||
|[97281](https://bugs.mysql.com/bug.php?id=97281)|2019-10-18|Histogram creation and removal statements with syntax errors in Workbench|Closed|2020-01-14||
|[97280](https://bugs.mysql.com/bug.php?id=97280)|2019-10-18|Hash join not displayed in traditional and JSON formats|Verified|2019-10-18||
|[96222](https://bugs.mysql.com/bug.php?id=96222)|2019-07-16|MySQL Workbench doesn't display the comment on a generated column|Verified|2019-07-16||
|[95804](https://bugs.mysql.com/bug.php?id=95804)|2019-06-14|Synchronize Model always generates VISIBLE indexes no matter the server version|Verified|2020-11-05||
|[95415](https://bugs.mysql.com/bug.php?id=95415)|2019-05-19|Table Data Import Wizard fails on UTF-8 encoded file with BOM|Verified|2022-02-07||
|[95411](https://bugs.mysql.com/bug.php?id=95411)|2019-05-17|LATERAL produces wrong results (values instead of NULLs) on 8.0.16|Duplicate|2019-05-20|[95411 test case](Examples/J[oin/bug_954](https://bugs.mysql.com/bug.php?id=)11_test_case.sql)|
|[95192](https://bugs.mysql.com/bug.php?id=95192)|2019-04-29|CHECK constraint comparing column with default value is not enforced|Closed|2019-10-29|[95192 test case](Examples/C[HECK/bug_951](https://bugs.mysql.com/bug.php?id=)92_test_case.sql)|
|[95189](https://bugs.mysql.com/bug.php?id=95189)|2019-04-29|CHECK constraint comparing columns is not always enforced with UPDATE queries|Closed|2019-07-31|[95189 test case]([Examples/CHECK/b](https://bugs.mysql.com/bug.php?id=)ug_95189_test_case.sql)|
|[95143](https://bugs.mysql.com/bug.php?id=95143)|2019-04-26|No support for CHECK constraints in Workbench|Verified|2019-05-14||
|[94012](https://bugs.mysql.com/bug.php?id=94012)|2019-01-23|MySQL Workbench 8.0.14 doesn't support LATERAL keyword|Closed|2019-05-18||
|[93835](https://bugs.mysql.com/bug.php?id=93835)|2019-01-07|Display warning when keyword is used as identifier|Verified|2019-01-10||
|[92908](https://bugs.mysql.com/bug.php?id=92908)|2018-10-23|MySQL Workbench 8.0.13 doesn't support expressions as key parts|Closed|2019-05-18||
|[92900](https://bugs.mysql.com/bug.php?id=92900)|2018-10-23|MySQL Workbench 8.0.13 doesn't support expressions in DEFAULT|Closed|2019-12-25||
|[92898](https://bugs.mysql.com/bug.php?id=92898)|2018-10-23|Error MY-013235 Error in parsing View during upgrade with MySQL 8.0.13|Not a Bug|2018-10-23||
|[91841](https://bugs.mysql.com/bug.php?id=91841)|2018-07-31|MySQL Connector/ODBC 5.3.11 does not compile on Slackware Linux|Closed|2019-01-25||
|[90876](https://bugs.mysql.com/bug.php?id=90876)|2018-05-15|Shell 8.0.11 gives error 5115 on adding documents to collection in Server 5.7|Closed|2022-07-05||
|[90772](https://bugs.mysql.com/bug.php?id=90772)|2018-05-06|Synchronize model makes different between single quotes escapes|Verified|2021-04-15||
|[90727](https://bugs.mysql.com/bug.php?id=90727)|2018-05-03|Linking errors for missing mysql_sys and mysql_strings libraries|Closed|2018-06-01||
|[90620](https://bugs.mysql.com/bug.php?id=90620)|2018-04-25|MySQL Workbench SQL Editor displays error on SELECT query with window functions|Closed|2020-05-07||
|[90619](https://bugs.mysql.com/bug.php?id=90619)|2018-04-25|MySQL Installer for windows doesn't offer upgrade from 5.7 to 8.0|Duplicate|2018-04-25||
|[89615](https://bugs.mysql.com/bug.php?id=89615)|2018-02-10|Building Shell 1.0.10 and above from source fails for undefined vio* functions|Unsupported|2018-08-23||
|[89608](https://bugs.mysql.com/bug.php?id=89608)|2018-02-09|MySQL Workbench password requirements messages to match server configuration|Verified|2018-02-13||
|[84951](https://bugs.mysql.com/bug.php?id=84951)|2017-02-10|Problem compiling jsonparser.cpp and jsonview.ccp on Slackware (32 bits)|Duplicate|2017-02-12||
|[82202](https://bugs.mysql.com/bug.php?id=82202)|2016-07-12|Cannot link to libmysqlclient.so due to undef my_malloc, my_free and others|Closed|2018-01-31||
|[73770](https://bugs.mysql.com/bug.php?id=73770)|2014-08-29|Make the synchronizer display the actual differences|Verified|2018-02-05||
|[73708](https://bugs.mysql.com/bug.php?id=73708)|2014-08-25|Diagrams completely mangled|Closed|2014-12-01||
|[73079](https://bugs.mysql.com/bug.php?id=73079)|2014-06-23|Cell not refreshed after setting value to NULL|Closed|2014-09-15||
|[73076](https://bugs.mysql.com/bug.php?id=73076)|2014-06-23|Applying modifications in a record set actually commits them|Closed|2014-08-26||
|[69459](https://bugs.mysql.com/bug.php?id=69459)|2013-06-13|Crash on entering dot in a SQL string when automatic code completion is enabled|Can't repeat|2013-12-24||
|[20098](https://bugs.mysql.com/bug.php?id=20098)|2006-05-26|Query browser is searching for a file that is not present (preferences.glade)|No Feedback|2006-06-30||

See [current list](https://bugs.mysql.com/search.php?cmd=display&status=All&severity=all&reporter=554578)
can always be found at [Bugs Home](https://bugs.mysql.com).

