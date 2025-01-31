/* Requires performance_schema to be enabled (i.e. performance_schema = on)
 * See https://dev.mysql.com/doc/refman/8.4/en/performance-schema-system-variables.html#sysvar_performance_schema
 */

/* Currently allocated memory */

SELECT total_allocated
  FROM sys.memory_global_total;

/* Per host */

SELECT `host`, current_memory, total_memory_allocated
  FROM sys.host_summary;

