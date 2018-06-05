WITH RECURSIVE sals AS
(SELECT 0 AS min_lvl, 1000 AS max_lvl
 UNION ALL
 SELECT min_lvl + 1000, max_lvl + 1000
   FROM sals
  WHERE max_lvl + 1000 <= (SELECT MAX(sal) FROM emp)
)
SELECT SL.min_lvl, SL.max_lvl, COUNT(*) emp_cnt,
       (COUNT(*) / SUM(COUNT(*)) OVER ()) AS prcnt
  FROM emp  E,
       sals SL
 WHERE E.sal >  SL.min_lvl
   AND E.sal <= SL.max_lvl
 GROUP BY SL.min_lvl, SL.max_lvl;
