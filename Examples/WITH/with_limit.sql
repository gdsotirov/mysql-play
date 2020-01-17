/* MySQL 8.0.19 allows recursive CTEs with LIMIT 
 * See https://dev.mysql.com/doc/refman/8.0/en/with.html#common-table-expressions-recursion-limits
 */

WITH RECURSIVE cte (n) AS
(
  SELECT 1
  UNION ALL
  SELECT n + 1
    FROM cte
 /*WHERE n < 1000 */
)
SELECT * FROM cte;

/* Without (the intentionally omitted) WHERE clause this query would cause
 * the following error:
 *   ERROR: 3636: Recursive query aborted after 1001 iterations. Try increasing @@cte_max_recursion_depth to a larger value.
 * Thus not allowing you to understand what result is generated and why.
 */

WITH RECURSIVE cte (n) AS
(
  SELECT 1
  UNION ALL
  SELECT n + 1
    FROM cte
 /*WHERE n < 1000 */
   LIMIT 1000
)
SELECT * FROM cte;

/* With LIMIT clause the CTE would return efficiently that many rows and stop. */

