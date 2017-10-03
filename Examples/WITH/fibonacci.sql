WITH RECURSIVE fib(iter, prev_n, n) AS
(
  SELECT 1, 0 AS fst, 1 AS scd
  UNION ALL
  SELECT iter + 1, n, prev_n + n FROM fib
   WHERE iter < 92
)
SELECT iter, prev_n from fib;