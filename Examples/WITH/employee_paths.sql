WITH RECURSIVE employee_paths (empno, ename, deptno, job, mgr, rang, path) AS
(
  SELECT empno, ename, deptno, job, empno, 1, CAST(ename AS CHAR(200))
    FROM emp
   WHERE mgr IS NULL
  UNION ALL
  SELECT E.empno, E.ename, E.deptno, E.job, E.mgr, rang + 1, CONCAT(EP.path, ' -> ', E.ename)
    FROM employee_paths EP,
         emp            E
   WHERE EP.empno = E.mgr
)
SELECT ECTE.empno, ECTE.ename, D.dname, ECTE.job, ECTE.rang, ECTE.path
  FROM employee_paths ECTE,
       dept           D
 WHERE ECTE.deptno = D.deptno
 ORDER BY D.dname, ECTE.rang;
