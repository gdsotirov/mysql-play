/* A Christmas tree with SQL using Common Table Expressions (CTE)
 * Inspired by SQL Daily's tweet - see https://twitter.com/sqldaily/status/1077534562518032390
 */

WITH RECURSIVE tree (i, t) AS (
  SELECT 1 AS i,
         CAST(CONCAT(LPAD(' ', 4 - 0, ' '), LPAD('*', (0 * 2) + 1, '*')) AS CHAR(128)) AS t
  UNION ALL
  SELECT i + 1,
         CONCAT(LPAD(' ', 4 - i, ' '), LPAD('*', (i * 2) + 1, '*'))
    FROM tree WHERE i <= 4
)
SELECT t AS TREE
  FROM tree;
