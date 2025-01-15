/* MySQL 8.0.31 finally supports EXCEPT clause
 * See https://dev.mysql.com/doc/refman/8.0/en/except.html and
 *     https://dev.mysql.com/doc/relnotes/mysql/8.0/en/news-8-0-31.html#mysqld-8-0-31-sql-syntax
 * Note: EXCEPT clause is equivalent to MINUS (in Oracle)
 */

/* The following would return only the negative numbers from a, because they
 * are not present in b
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
EXCEPT
SELECT *
  FROM b;

/* Result:
 * +------+
 * | n    |
 * +------+
 * |    1 |
 * |    3 |
 * |    5 |
 * |    7 |
 * |    9 |
 * +------+
 * 5 rows in set (0,00 sec)
 */

/* The same is also possible with NOT IN, which was one of the
 * options with previous versions
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
SELECT n
  FROM a
 WHERE n NOT IN (SELECT n FROM b);

/* The same is also possible with LEFT JOIN, which was the other
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
/* only positive numbers from 1 to 10 */
b AS (
  SELECT 2 AS n
  UNION ALL
  SELECT n + 2
    FROM b
   WHERE n < 10
)
SELECT A.n
  FROM a AS A LEFT JOIN b as B USING (n)
 WHERE B.n IS NULL;

