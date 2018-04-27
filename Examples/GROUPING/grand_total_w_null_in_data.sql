﻿SELECT CASE GROUPING(D.dname)
         WHEN 1 THEN 'Grand Total'
         ELSE COALESCE(D.dname, 'No department')
       END Dept,
       SUM(COALESCE(E.sal, 0)) Total
  FROM emp  E
       LEFT OUTER JOIN dept D ON E.deptno = D.deptno
 GROUP BY D.dname WITH ROLLUP;
 