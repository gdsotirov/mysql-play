/* MySQL 8.1.0 It is now possible to capture EXPLAIN FORMAT=JSON output
 * in a user variable using a syntax extension added in this release.
 * See https://dev.mysql.com/doc/refman/8.1/en/explain.html#explain-execution-plan
 */

EXPLAIN FORMAT=JSON INTO @my_explain 
 SELECT E.ename, E.job, D.dname
   FROM dept D,
        emp  E
  WHERE E.deptno = D.deptno
    AND E.job    = 'CLERK';

/* And then you could further analyze the JSON output */

SELECT @my_explain;
SELECT JSON_UNQUOTE(JSON_EXTRACT(@my_explain, '$.query_block.cost_info.query_cost')) query_cost;
SELECT JSON_EXTRACT(@my_explain, '$.query_block.nested_loop[*].table.table_name') join_tables,
       JSON_EXTRACT(@my_explain, '$.query_block.nested_loop[*].table.access_type') access,
       JSON_EXTRACT(@my_explain, '$.query_block.nested_loop[*].table.possible_keys') `keys`;
