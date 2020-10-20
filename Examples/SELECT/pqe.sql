/* Parenthesized Query Expressions appeared in MySQL 8.0.22
 * They have the following form
 *   ( query_expression ) [order_by_clause] [limit_clause] [into_clause]
 * See https://dev.mysql.com/doc/refman/8.0/en/parenthesized-query-expressions.html
 */

/* A few examples to get the idea */

(SELECT 1 AS col UNION SELECT 2);

/* Result is two rows with values 1 and 2 */

(SELECT 1 AS col UNION SELECT 2) LIMIT 1;

/* Result is just the first row with value 1 */

(SELECT 1 AS col UNION SELECT 2) LIMIT 1 OFFSET 1;

/* Result is just the second row with value 2 */

(SELECT 1 AS col UNION SELECT 2) ORDER BY col DESC LIMIT 1;

/* Result is just the first row with value 2 */

(SELECT 1 LIMIT 1) UNION (SELECT 2 LIMIT 1) LIMIT 1;

/* Result is just the first row with value 1 from the first query block
 * as final LIMIT is enforced on the entire query expression.
 */

