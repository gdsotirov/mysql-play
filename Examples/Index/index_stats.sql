/* MySQL keeps index statistics like cardinality in table INFORMATION_SCHEMA.STATISTICS */

SELECT *
  FROM PERFORMANCE_SCHEMA.global_variables
 WHERE variable_name IN ('innodb_stats_persistent',
                         'innodb_stats_auto_recalc',
                         'innodb_stats_persistent_sample_pages');

SELECT `table_name`,
        CASE non_unique WHEN 0 THEN 'TRUE' ELSE 'FALSE' END UNQ,
        index_name, seq_in_index AS SEQ, `column_name`, cardinality AS CARD,
        cardinality / CASE WHEN `table_name` = 'dept' THEN (SELECT COUNT(*) FROM dept_emp.dept)
                           WHEN `table_name` = 'emp'  THEN (SELECT COUNT(*) FROM dept_emp.emp)
                      END AS SEL
  FROM INFORMATION_SCHEMA.STATISTICS
 WHERE table_schema = 'dept_emp';

SELECT last_update, n_rows, clustered_index_size, sum_of_other_index_sizes
  FROM mysql.innodb_table_stats
 WHERE `table_name` = 'emp';

SELECT index_name, last_update, stat_name, stat_value, sample_size
  FROM mysql.innodb_index_stats
 WHERE `table_name` = 'emp';

SET GLOBAL innodb_stats_persistent_sample_pages = 5000;

ANALYZE TABLE emp;

