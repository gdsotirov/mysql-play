/* A Christmas tree with SQL using Common Table Expressions (CTE)
 * Inspired by SQL Daily's tweet - see https://twitter.com/sqldaily/status/1077534562518032390
 */

WITH RECURSIVE tree (i, t) AS (
  WITH args AS (SELECT 5 AS height)
  SELECT 1 AS i,
         CONCAT(LPAD(' ', args.height, ' '), LPAD('*', 1, '*')) AS t
    FROM args
  UNION ALL
  SELECT i + 1 AS i,
         CONCAT(LPAD(' ', args.height - i, ' '), LPAD('*', (i * 2) + 1, '*')) AS t
    FROM tree JOIN args ON 1 = 1 /* for Postgres */
   WHERE tree.i < args.height
)
SELECT t AS TREE
  FROM tree;

