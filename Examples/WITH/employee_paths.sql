WITH RECURSIVE employee_paths (empno, ename, deptno, mgr, rang, path) AS
(
  SELECT empno, ename, deptno, empno, 1, CAST(ename AS CHAR(200))
    FROM emp
   WHERE mgr IS NULL
  UNION ALL
  SELECT e.empno, e.ename, e.deptno, e.mgr, rang + 1, CONCAT(ep.path, ' -> ', e.ename)
    FROM employee_paths ep,
         emp e
   WHERE ep.empno = e.mgr
)
SELECT emps.empno, emps.ename, d.dname, rang, emps.path
  FROM employee_paths emps,
       dept d
 WHERE emps.deptno = d.deptno
 ORDER BY d.dname, emps.rang;
