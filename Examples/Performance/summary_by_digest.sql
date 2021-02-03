/* Is digest summary table representative?
 * See https://dev.mysql.com/doc/refman/5.7/en/performance-schema-statement-digests.html ,
 *     https://dev.mysql.com/doc/refman/5.7/en/statement-summary-tables.html ,
 *     https://dev.mysql.com/doc/refman/5.7/en/performance-schema-system-variables.html#sysvar_performance_schema_digests_size
 *     https://dev.mysql.com/doc/refman/5.7/en/performance-schema-status-variables.html#statvar_Performance_schema_digest_lost
 */

SELECT (SELECT COUNT_STAR
          FROM performance_schema.events_statements_summary_by_digest
         WHERE DIGEST IS NULL)
       /
       (SELECT SUM(COUNT_STAR)
          FROM performance_schema.events_statements_summary_by_digest
          WHERE DIGEST IS NOT NULL)
       * 100 AS digest_ratio;

/* If ratio is 5 % then digest summary table is representative. If ratio is
 * 50% then digest summary table is NOT very representative, so consider
 * increasing the value of performance_schema_digests_size system variable.
 */

SELECT variable_name, variable_value
  FROM performance_schema.global_variables
 WHERE variable_name IN ('performance_schema_digests_size',
                         'performance_schema_max_digest_length');

SELECT variable_name, variable_value
  FROM performance_schema.global_status
 WHERE variable_name = 'Performance_schema_digest_lost';

/* This should correspond to COUNT_STAR ... WHERE digest IS NULL */

