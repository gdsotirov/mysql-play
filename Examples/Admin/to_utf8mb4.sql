/* Generate ALTER TABLE ... MODIFY COLUMN statements for all columns
 * not yet in utf8mb4 character set and set default for table to utf8mb4.
 */
SELECT CONCAT('ALTER TABLE ', TABLE_SCHEMA, '.', TABLE_NAME, ' ',
        GROUP_CONCAT(
          CONCAT('MODIFY COLUM ', COLUMN_NAME,
            CASE
              WHEN DATA_TYPE IN ('char', 'varchar')
                THEN CONCAT(' ', DATA_TYPE, '(', CHARACTER_MAXIMUM_LENGTH, ')')
              WHEN DATA_TYPE = 'enum'
                THEN CONCAT(' ', COLUMN_TYPE)
              ELSE
                CONCAT(' ', DATA_TYPE)
            END,
            ' CHARACTER SET utf8mb4 ',
            CASE WHEN IS_NULLABLE = 'NO' THEN 'NOT NULL' ELSE '' END
          )
          ORDER BY COLUMN_NAME
          SEPARATOR ', '
        ),
        ', DEFAULT CHARACTER SET utf8mb4;'
       ) statements
  FROM information_schema.COLUMNS
 WHERE TABLE_SCHEMA NOT IN ('information_schema', 'mysql', 'performance_schema', 'sys')
   AND CHARACTER_SET_NAME <> 'utf8mb4'
 GROUP BY TABLE_SCHEMA, TABLE_NAME
 ORDER BY TABLE_SCHEMA, TABLE_NAME;

/* Generate ALTER TABLE statements for all tables not yet in ut8mb4 */
SELECT CONCAT('ALTER TABLE ', TABLE_SCHEMA, '.', TABLE_NAME, ' DEFAULT CHARACTER SET utf8mb4;') statement
  FROM information_schema.TABLES
 WHERE TABLE_SCHEMA NOT IN ('information_schema', 'mysql', 'performance_schema', 'sys')
   AND TABLE_COLLATION NOT LIKE 'utf8mb4%'
 ORDER BY TABLE_SCHEMA, TABLE_NAME;
