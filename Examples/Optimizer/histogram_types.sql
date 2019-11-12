/* Singleton and Equi-height histograms examples */

/* If number of distinct values is eual or lower the number of specified
 * buckets MySQL creates singleton histogram. If number of distinc values is
 * higher then number of buckets MySQL creates equi-height histogram. Frequent
 * values are in separate buckets.
 */

/***** Singleton histogram *****/

CREATE TABLE shist (val INT);

INSERT INTO shist (val)
WITH RECURSIVE nums AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1
    FROM nums
  WHERE n < 100
)
SELECT gen_range(1, 5) FROM nums;

SELECT val, COUNT(*) cnt
  FROM shist
 GROUP BY val
 ORDER BY cnt DESC;

ANALYZE TABLE shist UPDATE HISTOGRAM ON val WITH 5 BUCKETS;

SELECT (SELECT COUNT(DISTINCT val) FROM shist)                      unq_val,
       JSON_LENGTH(JSON_EXTRACT(`histogram`, '$."buckets"'))        bkts,
       JSON_EXTRACT(`histogram`, '$."histogram-type"')              htype,
       JSON_EXTRACT(`histogram`, '$."number-of-buckets-specified"') bkts_spec
  FROM INFORMATION_SCHEMA.COLUMN_STATISTICS CS
 WHERE CS.`table_name`  = 'shist'
   AND CS.`column_name` = 'val';

/* Just 5 unique values, so singleton histogram
 *
 * +---------+------+-------------+-----------+
 * | unq_val | bkts | htype       | bkts_spec |
 * +---------+------+-------------+-----------+
 * |       5 |    5 | "singleton" | 5         |
 * +---------+------+-------------+-----------+
 * 1 row in set (0.00 sec)
 */

SELECT HG.val, ROUND(HG.freq, 3) cfreq,
       ROUND(HG.freq - LAG(HG.freq, 1, 0) OVER (), 3) freq
  FROM INFORMATION_SCHEMA.COLUMN_STATISTICS CS,
       JSON_TABLE(`histogram`->'$.buckets', '$[*]'
                  COLUMNS(val  VARCHAR(10) PATH '$[0]',
                          freq DOUBLE      PATH '$[1]')) HG
 WHERE CS.`schema_name` = 'dept_emp'
   AND CS.`table_name`  = 'shist'
   AND CS.`column_name` = 'val';

/* +------+-------+-------+
 * | val  | cfreq | freq  |
 * +------+-------+-------+
 * | 1    | 0.240 | 0.240 |
 * | 2    | 0.450 | 0.210 |
 * | 3    | 0.660 | 0.210 |
 * | 4    | 0.840 | 0.180 |
 * | 5    | 1.000 | 0.160 |
 * +------+-------+-------+
 * 5 rows in set (0.00 sec)
 */

/***** Equi-height histogram *****/

CREATE TABLE eqhist (val INT);

INSERT INTO eqhist (val)
WITH RECURSIVE nums AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1
    FROM nums
  WHERE n < 100
)
SELECT gen_range(1, 25) FROM nums;

/* Generate frequent value */
INSERT INTO eqhist (val)
WITH RECURSIVE nums AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1
    FROM nums
  WHERE n < 30
)
SELECT 8 FROM nums;

SELECT val, COUNT(*) cnt
  FROM eqhist
 GROUP BY val
 ORDER BY cnt DESC;

ANALYZE TABLE eqhist UPDATE HISTOGRAM ON val WITH 5 BUCKETS;

SELECT (SELECT COUNT(DISTINCT val) FROM eqhist)                     unq_val,
       JSON_LENGTH(JSON_EXTRACT(`histogram`, '$."buckets"'))        bkts,
       JSON_EXTRACT(`histogram`, '$."histogram-type"')              htype,
       JSON_EXTRACT(`histogram`, '$."number-of-buckets-specified"') bkts_spec
  FROM INFORMATION_SCHEMA.COLUMN_STATISTICS CS
 WHERE CS.`table_name`  = 'eqhist'
   AND CS.`column_name` = 'val';

/* More than 5 unique values, so equi-height histogram
 *
 * +---------+------+---------------+-----------+
 * | unq_val | bkts | htype         | bkts_spec |
 * +---------+------+---------------+-----------+
 * |      25 |    5 | "equi-height" | 5         |
 * +---------+------+---------------+-----------+
 * 1 row in set (0.00 sec)
 */

SELECT HG.val_min, HG.val_max,
       ROUND(HG.freq, 3) cfreq,
       ROUND(HG.freq - LAG(HG.freq, 1, 0) OVER (), 3) freq,
       HG.dstval dstval
  FROM INFORMATION_SCHEMA.COLUMN_STATISTICS CS,
       JSON_TABLE(`histogram`->'$.buckets', '$[*]'
                  COLUMNS(val_min  VARCHAR(10) PATH '$[0]',
                          val_max  VARCHAR(10) PATH '$[1]',
                          freq     DOUBLE      PATH '$[2]',
                          dstval   INT         PATH '$[3]')) HG
 WHERE CS.`table_name`  = 'eqhist'
   AND CS.`column_name` = 'val';

/*
 * +---------+---------+-------+-------+--------+
 * | val_min | val_max | cfreq | freq  | dstval |
 * +---------+---------+-------+-------+--------+
 * | 1       | 7       | 0.200 | 0.200 |      7 |
 * | 8       | 8       | 0.469 | 0.269 |      1 | <- frequent value in separate bucket
 * | 9       | 12      | 0.615 | 0.146 |      4 |
 * | 13      | 19      | 0.808 | 0.192 |      7 |
 * | 20      | 25      | 1.000 | 0.192 |      6 |
 * +---------+---------+-------+-------+--------+
 * 5 rows in set (0.00 sec)
 */

