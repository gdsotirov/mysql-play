WITH RECURSIVE employee_chain (empno, ename, deptno, job, mgr, `rank`, `path`) AS
(
  SELECT empno, ename, deptno, job, empno, 1, CAST(ename AS CHAR(128))
    FROM emp
   WHERE mgr IS NULL
  UNION ALL
  SELECT E.empno, E.ename, E.deptno, E.job, E.mgr, `rank` + 1, CONCAT(EC.`path`, ' <- ', E.ename)
    FROM employee_chain EC,
         emp            E
   WHERE E.mgr = EC.empno
)
SELECT ECTE.empno, ECTE.ename, D.dname, ECTE.job, ECTE.`rank`, ECTE.`path`
  FROM employee_chain ECTE,
       dept           D
 WHERE D.deptno = ECTE.deptno
 ORDER BY D.dname, ECTE.`rank`;