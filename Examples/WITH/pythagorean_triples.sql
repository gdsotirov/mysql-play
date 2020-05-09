/* Generate Pythagorean triples with a CTE
 * See https://en.wikipedia.org/wiki/Pythagorean_triple
 * Requires: Examples/Math/gcd.sql
 */

/* Query 1: Evaluate three sets of numbers from 1 to 100 calculating powers of 2 */
WITH RECURSIVE nums AS
(SELECT 1 AS n
 UNION ALL
 SELECT n + 1
   FROM nums
  WHERE n < 100
)
SELECT x.n AS a, y.n AS b, z.n AS c
  FROM nums x,
       nums y,
       nums z
 WHERE pow(x.n, 2) + pow(y.n, 2) = pow(z.n, 2)
   AND x.n < y.n
   AND y.n < z.n
   AND gcd(x.n, y.n) = 1 /* coprimes */
 ORDER BY c, b DESC, a;

/* Query 2: Generation by the variant of Euclid's formula
 * See https://en.wikipedia.org/wiki/Pythagorean_triple#A_variant
 */
WITH RECURSIVE
limits AS (SELECT 100 AS mx),
nums AS
(SELECT 1 AS n
 UNION ALL
 SELECT n + 1
   FROM nums
  WHERE n < (SELECT mx FROM limits)
)
SELECT LEAST(m.n * n.n,   /* swap a and b to have same order as Query 1 */
             (pow(m.n, 2) - pow(n.n, 2)) / 2) AS a,
       GREATEST(m.n * n.n,
             (pow(m.n, 2) - pow(n.n, 2)) / 2) AS b,
       (pow(m.n, 2) + pow(n.n, 2)) / 2        AS c
  FROM nums   m,
       nums   n,
       limits l
 WHERE m.n % 2 = 1        /* If m and ... */
   AND n.n % 2 = 1        /* ... n are two odd integers */
   AND m.n > n.n          /* such that m > n, then a, b and c are three integers that form a triple, */
   AND gcd(m.n, n.n) = 1  /* which is primitive if and only if m and n are coprime */
   AND (pow(m.n, 2) + pow(n.n, 2)) / 2 < l.mx
 ORDER BY c, b DESC, a;

/* Both queries produce the same result:
 *
 * +----+----+----+
 * | a  | b  | c  |
 * +----+----+----+
 * |  3 |  4 |  5 |
 * |  5 | 12 | 13 |
 * |  8 | 15 | 17 |
 * |  7 | 24 | 25 |
 * | 20 | 21 | 29 |
 * | 12 | 35 | 37 |
 * |  9 | 40 | 41 |
 * | 28 | 45 | 53 |
 * | 11 | 60 | 61 |
 * | 16 | 63 | 65 |
 * | 33 | 56 | 65 |
 * | 48 | 55 | 73 |
 * | 13 | 84 | 85 |
 * | 36 | 77 | 85 |
 * | 39 | 80 | 89 |
 * | 65 | 72 | 97 |
 * +----+----+----+
 * 16 rows in set
 *
 * i.e. the 16 primitive triples for c <= 100.
 *
 * Runtime results (in seconds):
 * +-----------+----------+---------+
 * | c         | Query 1  | Query 2 |
 * +-----------+----------+---------+
 * |   <= 100  |   0.3543 |  0.0874 |
 * +-----------+----------+---------+
 * |   <= 300  |   5.1551 |  0.9197 |
 * +-----------+----------+---------+
 * |   <= 1000 | 113.5940 | 14.2690 |
 * +-----------+----------+---------+
 *
 */

