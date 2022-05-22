/* List slowest queries by average wait time
 * Requires performance_schema on
 */

SELECT first_seen                               AS first_seen,
       last_seen                                AS last_seen,
       count_star                               AS runs,
       ROUND(sum_timer_wait * pow(10, -12), 5)  AS sum_time_sec,
       ROUND(min_timer_wait * pow(10, -12), 5)  AS min_time_sec,
       ROUND(avg_timer_wait * pow(10, -12), 5)  AS avg_time_sec,
       ROUND(max_timer_wait * pow(10, -12), 5)  AS max_time_sec,
       schema_name                              AS db,
       digest_text                              AS query
  FROM performance_schema.events_statements_summary_by_digest
 WHERE IFNULL(schema_name, '') NOT IN ('', 'performance_schema')
 ORDER BY avg_time_sec DESC,
          sum_time_sec DESC;
