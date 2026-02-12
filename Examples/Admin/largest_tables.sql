/* Largest tables by total size of data and indexes
 * See https://dev.mysql.com/doc/refman/8.4/en/information-schema-tables-table.html
 */

SELECT TABLE_SCHEMA                                 AS "database",
       TABLE_NAME                                   AS "table",
       sys.format_bytes(DATA_LENGTH)                AS data_size,
       sys.format_bytes(INDEX_LENGTH)               AS index_size,
       sys.format_bytes(DATA_LENGTH + INDEX_LENGTH) AS total_size
  FROM INFORMATION_SCHEMA.TABLES
 WHERE TABLE_SCHEMA NOT IN ('information_schema', 'mysql', 'sys', 'performance_schema')
   AND TABLE_TYPE = 'BASE TABLE'
 /*AND (DATA_LENGTH + INDEX_LENGTH) > 1024 * 1024 # 2 - MB, 3 - GB, 4 - TB, etc.*/
 ORDER BY (DATA_LENGTH + INDEX_LENGTH) DESC;

