/* A Christmas tree with SQL using Common Table Expressions (CTE) that were
 * introduced with SQL:1999 standard (see https://en.wikipedia.org/wiki/SQL:1999)
 * Inspired by SQL Daily's tweet - see https://twitter.com/sqldaily/status/1077534562518032390
 * Should work in:
 * - MariaDB >= 10.2.1 (see https://mariadb.com/kb/en/mariadb-1021-release-notes/);
 * - MySQL >= 8.0.1 (see https://dev.mysql.com/doc/relnotes/mysql/8.0/en/news-8-0-1.html); and
 * - PostgreSQL >= 8.4.0 (see https://www.postgresql.org/docs/release/8.4.0/)
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

