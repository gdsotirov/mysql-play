/* MySQL keeps index statistics like cardinality in table INFORMATION_SCHEMA.STATISTICS */

SELECT `table_name`,
        CASE non_unique WHEN 0 THEN 'TRUE' ELSE 'FALSE' END UNQ,
        index_name, seq_in_index AS SEQ, `column_name`, cardinality AS CARD,
        cardinality / CASE WHEN `table_name` = 'dept' THEN (SELECT COUNT(*) FROM dept_emp.dept)
                           WHEN `table_name` = 'emp'  THEN (SELECT COUNT(*) FROM dept_emp.emp)
                      END AS SEL
  FROM INFORMATION_SCHEMA.STATISTICS
 WHERE table_schema = 'dept_emp';

