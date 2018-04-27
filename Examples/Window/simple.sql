/* In MySQL 8.0.2 or newer */

SELECT E.ename, E.job, D.dname,
       E.sal, SUM(E.sal) OVER (PARTITION BY E.deptno) AS dept_sal,
       E.comm, SUM(COALESCE(E.comm, 0)) OVER (PARTITION BY E.deptno) AS dept_com
  FROM emp  E,
       dept D
 WHERE E.deptno = D.deptno;
