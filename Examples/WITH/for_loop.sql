/* For loop in SQL (see http://www.rosettacode.org/wiki/Loops/For) */

/* 1. With WITH
 *
 * Note: Does not actually solve the task, because there are no clear outer
 * and inner loops.
 */

WITH RECURSIVE ol AS (
  SELECT 1 AS i, CAST('*' AS CHAR(30)) AS star
  UNION ALL
  SELECT i + 1, CONCAT(star, '*')
    FROM ol
   WHERE i < 5
)
SELECT star
  FROM ol;

/* 2. With WITH and LATERAL */

WITH RECURSIVE outl AS (
  SELECT 1 AS oi
  UNION ALL
  SELECT oi + 1
    FROM outl
   WHERE oi < 5
)
SELECT inl.star
  FROM outl,
       LATERAL
       (WITH RECURSIVE stars AS (
          SELECT 1 ii, CAST('*' AS CHAR(128)) AS star
          UNION ALL
          SELECT ii + 1, CONCAT(star, '*')
            FROM stars
           WHERE ii < outl.oi
        )
        SELECT ii, star
          fROM stars
       ) inl
 WHERE outl.oi = 5;

/* 3. With WITH, LATERAL and REPEAT function */

WITH RECURSIVE outl AS (
  SELECT 1 AS oi
  UNION ALL
  SELECT oi + 1
    FROM outl
   WHERE oi < 5
)
SELECT inl.star
  FROM outl,
       LATERAL
       (SELECT REPEAT('*', outl.oi) star
       ) inl;

/* Explain results: In MySQL 8.0.16 first query has cost 2.84, second 6.21
 * (using auto_key for join between outl and stars) and third 11.21 (coming
 * from full table scan of intl).
 */

