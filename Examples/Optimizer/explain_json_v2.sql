/* MySQL 8.3.0: The new system variable explain_json_format_version selects
 * the version of the JSON output format used by EXPLAIN FORMAT=JSON statements.
 * The possible values are:
 *   1 - (the default) selects the same JSON form as in previous MySQL versions;
 *   2 - selects the new JSON format that is based on access paths, and is
 *       intended to provide better compatibility with future versions of
 *       the MySQL Optimizer.
 * See https://dev.mysql.com/doc/refman/8.3/en/explain.html
 * See https://dev.mysql.com/doc/refman/8.3/en/server-system-variables.html#sysvar_explain_json_format_version
 */

SELECT @@explain_json_format_version INTO @curr_json_format_version /* 1 by default */;
SET @@explain_json_format_version = 2; /* set to new JSON format */

EXPLAIN FORMAT=JSON INTO @my_explain
 SELECT E.ename, E.job, D.dname
   FROM dept D,
        emp  E
  WHERE E.deptno = D.deptno
    AND E.job    = 'CLERK';

SELECT @my_explain;

/* Produces the following result:
 * {
 *   "query": "* select#1 * select `E`.`ename` AS `ename`,`E`.`job` AS `job`,`D`.`dname` AS `dname` from `dept_emp`.`dept` `D` join `dept_emp`.`emp` `E` where ((`E`.`job` = 'CLERK') and (`D`.`deptno` = `E`.`deptno`))",
 *   "inputs": [
 *     {
 *       "inputs": [
 *         {
 *           "alias": "E",
 *           "operation": "Table scan on E",
 *           "table_name": "emp",
 *           "access_type": "table",
 *           "schema_name": "dept_emp",
 *           "used_columns": [
 *             "ename",
 *             "job",
 *             "deptno"
 *           ],
 *           "estimated_rows": 14.0,
 *           "estimated_total_cost": 2.399999953806401
 *         }
 *       ],
 *       "condition": "((E.job = 'CLERK') and (E.deptno is not null))",
 *       "operation": "Filter: ((E.job = 'CLERK') and (E.deptno is not null))",
 *       "access_type": "filter",
 *       "estimated_rows": 1.3999999165534973,
 *       "estimated_total_cost": 2.399999953806401
 *     },
 *     {
 *       "alias": "D",
 *       "covering": false,
 *       "operation": "Single-row index lookup on D using PRIMARY (deptno=E.deptno)",
 *       "index_name": "PRIMARY",
 *       "table_name": "dept",
 *       "access_type": "index",
 *       "schema_name": "dept_emp",
 *       "used_columns": [
 *         "deptno",
 *         "dname"
 *       ],
 *       "estimated_rows": 1.0,
 *       "lookup_condition": "deptno=E.deptno",
 *       "index_access_type": "index_lookup",
 *       "estimated_total_cost": 0.32142857462167757
 *     }
 *   ],
 *   "join_type": "inner join",
 *   "operation": "Nested loop inner join",
 *   "query_type": "select",
 *   "access_type": "join",
 *   "estimated_rows": 1.3999999165534973,
 *   "join_algorithm": "nested_loop",
 *   "estimated_total_cost": 2.889999929815531
 * }
 */

/* Which could be analyzed further */

SELECT JSON_UNQUOTE(JSON_EXTRACT(@my_explain, '$.estimated_total_cost')) total_cost;
SELECT *
  FROM JSON_TABLE(@my_explain, '$' COLUMNS(
         access_type          VARCHAR(16)     PATH '$.access_type',
         estimated_rows       DECIMAL(32,16)  PATH '$.estimated_rows',
         estimated_total_cost DECIMAL(32,16)  PATH '$.estimated_total_cost',
         join_algorithm       VARCHAR(16)     PATH '$.join_algorithm',
         join_type            VARCHAR(16)     PATH '$.join_type',
         operation            VARCHAR(64)     PATH '$.operation',
         query_type           VARCHAR(16)     PATH '$.query_type'
       )) AS explain_json_v2;

SELECT access_type,
       ROUND(estimated_rows, 2) AS estimated_rows,
       ROUND(est_total_cost, 2) AS est_total_cost,
       CONCAT(CASE access_type
         WHEN 'filter' THEN CONCAT(operation_filter, '; ')
         ELSE '' END,
         operation)             AS operation,
       CONCAT(CASE access_type
         WHEN 'filter' THEN `schema_filter`
         ELSE `schema_name`
       END, '.',
       CASE access_type
         WHEN 'filter' THEN `table_filter`
         ELSE `table_name`
       END,
       CASE WHEN COALESCE(alias_filter, alias) IS NOT NULL
         THEN CONCAT(' AS ', COALESCE(alias_filter, alias))
         ELSE ''
       END)                     AS `table_name`
  FROM JSON_TABLE(@my_explain, '$.inputs[*]' COLUMNS(
         alias            VARCHAR(16)     PATH '$.alias',
         alias_filter     VARCHAR(16)     PATH '$.inputs[0].alias',
         access_type      VARCHAR(16)     PATH '$.access_type',
         estimated_rows   DECIMAL(32,16)  PATH '$.estimated_rows',
         est_total_cost   DECIMAL(32,16)  PATH '$.estimated_total_cost',
         operation        VARCHAR(64)     PATH '$.operation',
         operation_filter VARCHAR(64)     PATH '$.inputs[0].operation',
         `schema_filter`  VARCHAR(64)     PATH '$.inputs[0].schema_name',
         `schema_name`    VARCHAR(64)     PATH '$.schema_name',
         `table_filter`   VARCHAR(64)     PATh '$.inputs[0].table_name',
         `table_name`     VARCHAR(64)     PATh '$.table_name'
       )) AS inputs;

SET @@explain_json_format_version = @curr_json_format_version;

