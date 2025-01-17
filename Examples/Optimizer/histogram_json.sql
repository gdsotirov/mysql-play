/* MySQL 8.0.31: It is now possible to set a column histogram to
 * a user-specified JSON value with USING DATA.
 * See https://dev.mysql.com/doc/refman/8.0/en/analyze-table.html#analyze-table-histogram-statistics-analysis
 */

/* You could first generate histogram's definition in JSON like this */

SELECT JSON_OBJECT(
    'buckets', JSON_ARRAY(
      JSON_ARRAY(CONCAT('base64:type254:', TO_BASE64('ANALYST'))  , 0.14285714285714285),
      JSON_ARRAY(CONCAT('base64:type254:', TO_BASE64('CLERK'))    , 0.42857142857142855),
      JSON_ARRAY(CONCAT('base64:type254:', TO_BASE64('MANAGER'))  , 0.6428571428571429),
      JSON_ARRAY(CONCAT('base64:type254:', TO_BASE64('PRESIDENT')), 0.7142857142857143),
      JSON_ARRAY(CONCAT('base64:type254:', TO_BASE64('SALESMAN')) , 1.0)
    ),
    'data-type', 'string',
    'null-values', 0.0,
    'collation-id', 255,
    'last-updated', DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s.%f'),
    'sampling-rate', 1.0,
    'histogram-type', 'singleton',
    'number-of-buckets-specified', 5
  ) AS histogram_json;

/* and then */

ANALYZE TABLE emp
  UPDATE HISTOGRAM ON job
  USING DATA '{"buckets": [["base64:type254:QU5BTFlTVA==", 0.14285714285714285], ["base64:type254:Q0xFUks=", 0.42857142857142855], ["base64:type254:TUFOQUdFUg==", 0.6428571428571429], ["base64:type254:UFJFU0lERU5U", 0.7142857142857143], ["base64:type254:U0FMRVNNQU4=", 1.0]], "data-type": "string", "null-values": 0.0, "collation-id": 255, "last-updated": "2025-01-17 17:42:00.000000", "sampling-rate": 1.0, "histogram-type": "singleton", "number-of-buckets-specified": 5}';

/* as apparently USING DATA does not support direct input from JSON_OBJECT
 * or any function at all. The value should be a string literal. */

/* Be ware what you are doing and keep in mind that whatever histogram data
 * you set manually would be overwritten by the next UPDATE HISTOGRAM.
 */

ANALYZE TABLE emp UPDATE HISTOGRAM ON job;

