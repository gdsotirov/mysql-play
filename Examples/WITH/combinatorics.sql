/* How to visualize combinatorics to an 8th grader? */

/* Problem 1: In the main menu of a restaurant there are the following dishes:
 *  - 2 kinds of soup;
 *  - 5 kinds of main courses;
 *  - 3 kinds of dessert.
 * How many choices a guest has if he/she chooses one main course and one
 * desert?
 * Solution: V(n=5, k=1) * V(n=3, k=1) = 5 * 3 = 15
 * Solution with SQL (CTE):
 */

WITH RECURSIVE
maincourse AS (
  SELECT 1 AS mc
  UNION ALL
  SELECT mc + 1
    FROM maincourse
   WHERE mc < 5
),
dessert AS (
  SELECT 1 AS d
  UNION ALL
  SELECT d + 1
    FROM dessert
   WHERE d < 3
)
SELECT *
  FROM maincourse,
       dessert;

/* Result:
 * +----+---+
 * | mc | d |
 * +----+---+
 * |  1 | 1 |
 * |  1 | 2 |
 * |  1 | 3 |
 * |  2 | 1 |
 * |  2 | 2 |
 * |  2 | 3 |
 * |  3 | 1 |
 * |  3 | 2 |
 * |  3 | 3 |
 * |  4 | 1 |
 * |  4 | 2 |
 * |  4 | 3 |
 * |  5 | 1 |
 * |  5 | 2 |
 * |  5 | 3 |
 * +----+---+
 * 15 rows in set (0.0005 sec)
 */

/* Problem 2: How many are the different ways in which Ivan and his four friends
 * could line up for a photo, so that Ivan is always in the middle.
 * Solution: If Ivan is always in the middle only his friends permutate
 * (i.e. the row is XXIXX), so P(n=4) = 4! = 4.3.2.1 = 24
 * Solution with SQL (CTE):
 */

WITH RECURSIVE
f1 AS ( /* friend 1 */
  SELECT 1 AS p1 /* position 1 */
  UNION ALL
  SELECT p1 + 1
    FROM f1
   WHERE p1 < 4
),
f2 AS ( /* friend 2 */
  SELECT 1 AS p2 /* position 2 */
  UNION ALL
  SELECT p2 + 1
    FROM f2
   WHERE p2 < 4
),
f3 AS ( /* friend 3 */
  SELECT 1 AS p3 /* position 3 */
  UNION ALL
  SELECT p3 + 1
    FROM f3
   WHERE p3 < 4
),
f4 AS ( /* friend 4 */
  SELECT 1 AS p4 /* position 4 */
  UNION ALL
  SELECT p4 + 1
    FROM f4
   WHERE p4 < 4
)
SELECT f1.p1, f2.p2, 'I', f3.p3, f4.p4
  FROM f1,
       f2,
       f3,
       f4
 WHERE f1.p1 <> f2.p2
   AND f2.p2 <> f3.p3
   AND f3.p3 <> f4.p4
   AND f1.p1 <> f3.p3
   AND f1.p1 <> f4.p4
   AND f2.p2 <> f4.p4;

/* Result:
 * +----+----+---+----+----+
 * | p1 | p2 | I | p3 | p4 |
 * +----+----+---+----+----+
 * |  1 |  2 | I |  3 |  4 |
 * |  1 |  2 | I |  4 |  3 |
 * |  1 |  3 | I |  2 |  4 |
 * |  1 |  3 | I |  4 |  2 |
 * |  1 |  4 | I |  2 |  3 |
 * |  1 |  4 | I |  3 |  2 |
 * |  2 |  1 | I |  3 |  4 |
 * |  2 |  1 | I |  4 |  3 |
 * |  2 |  3 | I |  1 |  4 |
 * |  2 |  3 | I |  4 |  1 |
 * |  2 |  4 | I |  1 |  3 |
 * |  2 |  4 | I |  3 |  1 |
 * |  3 |  1 | I |  2 |  4 |
 * |  3 |  1 | I |  4 |  2 |
 * |  3 |  2 | I |  1 |  4 |
 * |  3 |  2 | I |  4 |  1 |
 * |  3 |  4 | I |  1 |  2 |
 * |  3 |  4 | I |  2 |  1 |
 * |  4 |  1 | I |  2 |  3 |
 * |  4 |  1 | I |  3 |  2 |
 * |  4 |  2 | I |  1 |  3 |
 * |  4 |  2 | I |  3 |  1 |
 * |  4 |  3 | I |  1 |  2 |
 * |  4 |  3 | I |  2 |  1 |
 * +----+----+---+----+----+
 * 24 rows in set (0.0007 sec)
 */

/* Problem 3: The 25 students in a class received three free invitations
 * for theater. In how many different ways these invitations could be
 * distributed, so that each students receives at most one invitation.
 * Solution: C(n=25, k=3) = 25.24.23 / 1.2.3 = 13 800 / 6 = 2 300
 * Solution with SQL (CTE):
 */

WITH RECURSIVE
i1 AS (
  SELECT 1 AS s1
  UNION ALL
  SELECT s1 + 1
    FROM i1
   WHERE s1 < 25
),
i2 AS (
  SELECT 1 AS s2
  UNION ALL
  SELECT s2 + 1
    FROM i2
   WHERE s2 < 25
),
i3 AS (
  SELECT 1 AS s3
  UNION ALL
  SELECT s3 + 1
    FROM i3
   WHERE s3 < 25
)
SELECT i1.s1, i2.s2, i3.s3
  FROM i1,
       i2,
       i3
 WHERE i1.s1 < i2.s2
   AND i2.s2 < i3.s3;

/* Result:
 * +----+----+----+
 * | s1 | s2 | s3 |
 * +----+----+----+
 * |  1 |  2 |  3 |
 * |  1 |  2 |  4 |
 * |  1 |  2 |  5 |
 * |  1 |  2 |  6 |
 * |  1 |  2 |  7 |
 * |  1 |  2 |  8 |
 * |  1 |  2 |  9 |
 * |  1 |  2 | 10 |
 * |  1 |  2 | 11 |
 * |  1 |  2 | 12 |
 * |  1 |  2 | 13 |
 * |  1 |  2 | 14 |
 * |  1 |  2 | 15 |
 * |  1 |  2 | 16 |
 * |  1 |  2 | 17 |
 * |  1 |  2 | 18 |
 * |  1 |  2 | 19 |
 * |  1 |  2 | 20 |
 * |  1 |  2 | 21 |
 * |  1 |  2 | 22 |
 * |  1 |  2 | 23 |
 * |  1 |  2 | 24 |
 * |  1 |  2 | 25 |
 * |  1 |  3 |  4 |
 * ...
 * | 22 | 23 | 25 |
 * | 22 | 24 | 25 |
 * | 23 | 24 | 25 |
 * +----+----+----+
 * 2300 rows in set (0.0180 sec)
 */

/* Problem 4: For an exam 20 questions and 20 problems were prepared. From them
 * exam tickets are compiled with each ticket having 3 questions and 2
 * problems. How many different tickets could be compiled?
 * Solution: C(n=20, k=3) * C(n=20, k=2) = 20.19.18 / 1.2.3 * 20.19 / 1.2 = 1 140 * 190 = 216 600
 * Solution with SQL (CTE):
 */

WITH RECURSIVE
q1 AS (
  SELECT 1 AS v1
  UNION ALL
  SELECT v1 + 1
    FROM q1
   WHERE v1 < 20
),
q2 AS (
  SELECT 1 AS v2
  UNION ALL
  SELECT v2 + 1
    FROM q2
   WHERE v2 < 20
),
q3 AS (
  SELECT 1 AS v3
  UNION ALL
  SELECT v3 + 1
    FROM q3
   WHERE v3 < 20
),
p1 AS (
  SELECT 1 AS v1
  UNION ALL
  SELECT v1 + 1
    FROM p1
   WHERE v1 < 20
),
p2 AS (
  SELECT 1 AS v2
  UNION ALL
  SELECT v2 + 1
    FROM p2
   WHERE v2 < 20
)
SELECT q1.v1 q1, q2.v2 q2, q3.v3 q3,
       p1.v1 p1, p2.v2 p2
  FROM q1, q2, q3,
       p1, p2
 WHERE q1.v1 < q2.v2
   AND q2.v2 < q3.v3
   AND p1.v1 < p2.v2;

/* Result:
 * +----+----+----+----+----+
 * | q1 | q2 | q3 | p1 | p2 |
 * +----+----+----+----+----+
 * |  1 |  2 |  3 |  1 |  2 |
 * |  1 |  2 |  3 |  1 |  3 |
 * |  1 |  2 |  3 |  1 |  4 |
 * |  1 |  2 |  3 |  1 |  5 |
 * |  1 |  2 |  3 |  1 |  6 |
 * |  1 |  2 |  3 |  1 |  7 |
 * |  1 |  2 |  3 |  1 |  8 |
 * |  1 |  2 |  3 |  1 |  9 |
 * |  1 |  2 |  3 |  1 | 10 |
 * |  1 |  2 |  3 |  1 | 11 |
 * |  1 |  2 |  3 |  1 | 12 |
 * |  1 |  2 |  3 |  1 | 13 |
 * |  1 |  2 |  3 |  1 | 14 |
 * |  1 |  2 |  3 |  1 | 15 |
 * |  1 |  2 |  3 |  1 | 16 |
 * |  1 |  2 |  3 |  1 | 17 |
 * |  1 |  2 |  3 |  1 | 18 |
 * |  1 |  2 |  3 |  1 | 19 |
 * |  1 |  2 |  3 |  1 | 20 |
 * |  1 |  2 |  3 |  2 |  3 |
 * |  1 |  2 |  3 |  2 |  4 |
 * |  1 |  2 |  3 |  2 |  5 |
 * |  1 |  2 |  3 |  2 |  6 |
 * |  1 |  2 |  3 |  2 |  7 |
 * ...
 * | 18 | 19 | 20 | 18 | 19 |
 * | 18 | 19 | 20 | 18 | 20 |
 * | 18 | 19 | 20 | 19 | 20 |
 * +----+----+----+----+----+
 * 216600 rows in set (0.0018 sec)
 */

/* Problem 5: From a class with 10 girls and 15 boys a representative group of
 * 8 students should be selected. In how many different ways this could happen,
 * so in the group there are at least 2 girls?
 * Solution: C(n=10, k=2) * C(n=15, k=6) =
 *           = 10.9 / 1.2 * 15.14.13.12.11.10 / 1.2.3.4.5.6 =
 *           = 90 / 2 * 3 603 600 / 720 = 45 * 5 005 = 225 225
 * Solution with SQL (CTE):
 */

WITH RECURSIVE
g1 AS (
  SELECT 1 AS v1
  UNION ALL
  SELECT v1 + 1
    FROM g1
   WHERE v1 < 10
),
g2 AS (
  SELECT 1 AS v2
  UNION ALL
  SELECT v2 + 1
    FROM g2
   WHERE v2 < 10
),
b1 AS (
  SELECT 1 AS v1
  UNION ALL
  SELECT v1 + 1
    FROM b1
   WHERE v1 < 15
),
b2 AS (
  SELECT 1 AS v2
  UNION ALL
  SELECT v2 + 1
    FROM b2
   WHERE v2 < 15
),
b3 AS (
  SELECT 1 AS v3
  UNION ALL
  SELECT v3 + 1
    FROM b3
   WHERE v3 < 15
),
b4 AS (
  SELECT 1 AS v4
  UNION ALL
  SELECT v4 + 1
    FROM b4
   WHERE v4 < 15
),
b5 AS (
  SELECT 1 AS v5
  UNION ALL
  SELECT v5 + 1
    FROM b5
   WHERE v5 < 15
),
b6 AS (
  SELECT 1 AS v6
  UNION ALL
  SELECT v6 + 1
    FROM b6
   WHERE v6 < 15
)
SELECT g1.v1 g1, g2.v2 g2,
       b1.v1 b1, b2.v2 b2, b3.v3 b3, b4.v4 b4, b5.v5 b5, b6.v6 b6
  FROM g1, g2,                /* girls */
       b1, b2, b3, b4, b5, b6 /* boys */
 WHERE g1.v1 < g2.v2
   AND b1.v1 < b2.v2
   AND b2.v2 < b3.v3
   AND b3.v3 < b4.v4
   AND b4.v4 < b5.v5
   AND b5.v5 < b6.v6;

/* Result:
 *+----+----+----+----+----+----+----+----+
 *| g1 | g2 | b1 | b2 | b3 | b4 | b5 | b6 |
 *+----+----+----+----+----+----+----+----+
 *|  1 |  2 |  1 |  2 |  3 |  4 |  5 |  6 |
 *|  1 |  3 |  1 |  2 |  3 |  4 |  5 |  6 |
 *|  1 |  4 |  1 |  2 |  3 |  4 |  5 |  6 |
 *|  1 |  5 |  1 |  2 |  3 |  4 |  5 |  6 |
 *|  1 |  6 |  1 |  2 |  3 |  4 |  5 |  6 |
 *|  1 |  7 |  1 |  2 |  3 |  4 |  5 |  6 |
 *|  1 |  8 |  1 |  2 |  3 |  4 |  5 |  6 |
 *|  1 |  9 |  1 |  2 |  3 |  4 |  5 |  6 |
 *|  1 | 10 |  1 |  2 |  3 |  4 |  5 |  6 |
 *|  2 |  3 |  1 |  2 |  3 |  4 |  5 |  6 |
 *|  2 |  4 |  1 |  2 |  3 |  4 |  5 |  6 |
 *|  2 |  5 |  1 |  2 |  3 |  4 |  5 |  6 |
 *|  2 |  6 |  1 |  2 |  3 |  4 |  5 |  6 |
 *|  2 |  7 |  1 |  2 |  3 |  4 |  5 |  6 |
 *|  2 |  8 |  1 |  2 |  3 |  4 |  5 |  6 |
 *|  2 |  9 |  1 |  2 |  3 |  4 |  5 |  6 |
 *|  2 | 10 |  1 |  2 |  3 |  4 |  5 |  6 |
 *|  3 |  4 |  1 |  2 |  3 |  4 |  5 |  6 |
 *|  3 |  5 |  1 |  2 |  3 |  4 |  5 |  6 |
 *|  3 |  6 |  1 |  2 |  3 |  4 |  5 |  6 |
 *|  3 |  7 |  1 |  2 |  3 |  4 |  5 |  6 |
 *|  3 |  8 |  1 |  2 |  3 |  4 |  5 |  6 |
 *|  3 |  9 |  1 |  2 |  3 |  4 |  5 |  6 |
 *|  3 | 10 |  1 |  2 |  3 |  4 |  5 |  6 |
 *...
 *|  8 |  9 | 10 | 11 | 12 | 13 | 14 | 15 |
 *|  8 | 10 | 10 | 11 | 12 | 13 | 14 | 15 |
 *|  9 | 10 | 10 | 11 | 12 | 13 | 14 | 15 |
 *+----+----+----+----+----+----+----+----+
 *225225 rows in set (0.0032 sec)
 */

