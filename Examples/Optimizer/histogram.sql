/* MySQL 8.0.2: Enables management of histogram statistics for table
 * column values by adding support for UPDATE HISTOGRAM and DROP HISTOGRAM
 * clauses to ANALYZE TABLE statement.
 * See https://dev.mysql.com/doc/refman/8.0/en/analyze-table.html#analyze-table-histogram-statistics-analysis
 */

SET histogram_generation_max_mem_size = 184*1024*1024;

/* Create histogram */
ANALYZE TABLE emp
  UPDATE HISTOGRAM ON job WITH 5 BUCKETS;

/* +--------------+-----------+----------+------------------------------------------------+
 * | Table        | Op        | Msg_type | Msg_text                                       |
 * +--------------+-----------+----------+------------------------------------------------+
 * | dept_emp.emp | histogram | status   | Histogram statistics created for column 'job'. |
 * +--------------+-----------+----------+------------------------------------------------+
 * 1 row in set (0.0107 sec)
 */

/* Query information about histograms */
SELECT `schema_name`, `table_name`, `column_name`,
       JSON_PRETTY(`histogram`) `histogram`
  FROM information_schema.COLUMN_STATISTICS;

/*
 * +-------------+------------+-------------+------------------------------------------------+
 * | SCHEMA_NAME | TABLE_NAME | COLUMN_NAME | histogram                                      |
 * +-------------+------------+-------------+------------------------------------------------+
 * | dept_emp    | emp        | job         | {"buckets": [
 *                                               [
 *                                                 "base64:type254:QU5BTFlTVA==",
 *                                                 0.14285714285714285
 *                                               ],
 *                                               [
 *                                                 "base64:type254:Q0xFUks=",
 *                                                 0.42857142857142855
 *                                               ],
 *                                               [
 *                                                 "base64:type254:TUFOQUdFUg==",
 *                                                 0.6428571428571428
 *                                               ],
 *                                               [
 *                                                 "base64:type254:UFJFU0lERU5U",
 *                                                 0.7142857142857142
 *                                               ],
 *                                               [
 *                                                 "base64:type254:U0FMRVNNQU4=",
 *                                                 0.9999999999999999
 *                                               ]
 *                                             ],
 *                                             "data-type": "string",
 *                                             "null-values": 0.0,
 *                                             "collation-id": 33,
 *                                             "last-updated": "2019-09-25 16:06:24.192002",
 *                                             "sampling-rate": 1.0,
 *                                             "histogram-type": "singleton",
 *                                             "number-of-buckets-specified": 5
 *                                           } |
 * +-------------+------------+-------------+------------------------------------------------+
 * 1 row in set (0.0005 sec)
 */

/* Cumulative frequency of values in a histogram with calculation of frequency for each value */
SELECT HG.val,
       ROUND(HG.freq, 5) cfreq,
       ROUND(HG.freq - LAG(HG.freq, 1, 0) OVER (), 5) freq
  FROM information_schema.column_statistics CS,
       JSON_TABLE(`histogram`->'$.buckets', '$[*]'
                  COLUMNS(val  VARCHAR(10) PATH '$[0]',
                          freq DOUBLE      PATH '$[1]')
                 ) HG
 WHERE CS.`schema_name` = 'dept_emp'
   AND CS.`table_name`  = 'emp'
   AND CS.`column_name` = 'job';

/*
 * +-----------+---------+---------+
 * | val       | cfreq   | freq    |
 * +-----------+---------+---------+
 * | ANALYST   | 0.14286 | 0.14286 |
 * | CLERK     | 0.42857 | 0.28571 |
 * | MANAGER   | 0.64286 | 0.21429 |
 * | PRESIDENT | 0.71429 | 0.07143 |
 * | SALESMAN  |       1 | 0.28571 |
 * +-----------+---------+---------+
 * 5 rows in set (0.00 sec)
 */

/* Check query */
SELECT E.ename, D.dname
  FROM dept D,
       emp  E
 WHERE E.deptno = D.deptno
   AND E.job    = 'PRESIDENT';

/*
 * +----+-------------+-------+------------+--------+---------------+---------+---------+-------------------+------+----------+-------------+
 * | id | select_type | table | partitions | type   | possible_keys | key     | key_len | ref               | rows | filtered | Extra       |
 * +----+-------------+-------+------------+--------+---------------+---------+---------+-------------------+------+----------+-------------+
 * |  1 | SIMPLE      | E     | NULL       | ALL    | fk_deptno     | NULL    | NULL    | NULL              |   14 |     7.14 | Using where |
 * |  1 | SIMPLE      | D     | NULL       | eq_ref | PRIMARY       | PRIMARY | 4       | dept_emp.E.deptno |    1 |   100.00 | NULL        |
 * +----+-------------+-------+------------+--------+---------------+---------+---------+-------------------+------+----------+-------------+
 * 2 rows in set, 1 warning (0.00 sec)
 */

/* Filtered on E is 7.143 % of 14 rows, i.e. roughly 1 rows, instead of 10 % (guesstimate) */

/* Remove histogram */
ANALYZE TABLE emp DROP HISTOGRAM ON job;

