/* Histogram example
 * Histograms are available since MySQL 8.0.3 RC, released 2017-09-21
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

/* Cumulative frequancy of values in a histogram with calculation of frequancy for each value */
SELECT HG.val,
       ROUND(HG.freq, 3) cfreq,
       ROUND(HG.freq - LAG(HG.freq, 1, 0) OVER (), 3) freq
  FROM information_schema.column_statistics CS,
       JSON_TABLE(`histogram`->'$.buckets', '$[*]'
                  COLUMNS(val  VARCHAR(10) PATH '$[0]',
                          freq DOUBLE      PATH '$[1]')
                 ) HG
 WHERE CS.`schema_name` = 'dept_emp'
   AND CS.`table_name`  = 'emp'
   AND CS.`column_name` = 'job';

/*
 * +-----------+-------+-------+
 * | val       | cfreq | freq  |
 * +-----------+-------+-------+
 * | ANALYST   | 0.143 | 0.143 |
 * | CLERK     | 0.429 | 0.286 |
 * | MANAGER   | 0.643 | 0.214 |
 * | PRESIDENT | 0.714 | 0.071 |
 * | SALESMAN  |     1 | 0.286 |
 * +-----------+-------+-------+
 * 5 rows in set (0.0012 sec)
 */

/* Check query */
SELECT E.ename, D.dname
  FROM dept D,
       emp  E
 WHERE E.deptno = D.deptno
   AND E.job    = 'PRESIDENT';

/* Filtered on E is 0.00009999860048992559, instaed of 9.999999046325684 (guestimate) */

/* Remove histogram */
ANALYZE TABLE emp DROP HISTOGRAM ON job;

