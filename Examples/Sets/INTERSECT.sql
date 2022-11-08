/* MySQL 8.0.31 finally added INTERSECT clause
 * See https://dev.mysql.com/doc/refman/8.0/en/intersect.html and
 *     https://dev.mysql.com/doc/relnotes/mysql/8.0/en/news-8-0-31.html#mysqld-8-0-31-sql-syntax
 */

/* The following would return only the positive numbers from a, because they
 * are also present in b
 */

WITH RECURSIVE
/* all numbers from 1 to 10 */
a AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1
    FROM a
   WHERE n < 10
),
/* only positive numbers from 1 to 10 */
b AS (
  SELECT 2 AS n
  UNION ALL
  SELECT n + 2
    FROM b
   WHERE n < 10
)
SELECT *
  FROM a
INTERSECT
SELECT *
  FROM b;

/* Result:
 * +------+
 * | n    |
 * +------+
 * |    2 |
 * |    4 |
 * |    6 |
 * |    8 |
 * |   10 |
 * +------+
 * 5 rows in set (0,00 sec)
 */

/* The same is also possible with INNER JOIN, which was the only
 * option with previous versions
 */

WITH RECURSIVE
/* all numbers from 1 to 10 */
a AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1
    FROM a
   WHERE n < 10
),
/* only positive number from 1 to 10 */
b AS (
  SELECT 2 AS n
  UNION ALL
  SELECT n + 2
    FROM b
   WHERE n < 10
)
SELECT *
  FROM a INNER JOIN b USING (n);
