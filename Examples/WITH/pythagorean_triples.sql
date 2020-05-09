/* Generate Pythagorean triples with a CTE
 * See https://en.wikipedia.org/wiki/Pythagorean_triple
 * TODO: Reduce to only primitives, e.g. exclude (6, 8, 10) as it is
 *       a multiple of (3, 4, 5).
 */
WITH RECURSIVE nums AS
(SELECT 1 AS n
 UNION ALL
 SELECT n + 1
   FROM nums
  WHERE n < 100
)
SELECT x.n AS x, y.n AS y, z.n AS z
  FROM nums x,
       nums y,
       nums z
 WHERE pow(x.n, 2) + pow(y.n, 2) = pow(z.n, 2)
   AND x.n < y.n
   AND y.n < z.n
 ORDER BY x.n, y.n, z.n;

