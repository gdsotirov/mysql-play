SELECT COALESCE(D.dname, 'Grand Total') Dept,
       SUM(COALESCE(E.sal, 0)) Total
  FROM emp  E
       LEFT OUTER JOIN dept D
       ON E.deptno = D.deptno
GROUP BY D.dname WITH ROLLUP;
