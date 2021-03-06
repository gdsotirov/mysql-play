﻿SELECT E.ename, E.job, D.dname,
       E.sal, SUM(E.sal)
         OVER (PARTITION BY E.deptno ORDER BY E.ename) AS dept_sal,
       E.comm, SUM(COALESCE(E.comm, 0))
         OVER (PARTITION BY E.deptno ORDER BY E.ename) AS dept_com
  FROM emp  E,
       dept D
 WHERE E.deptno = D.deptno
 ORDER BY D.dname, E.ename;

