WITH RECURSIVE chain_cmd (empno, mgr, `path`) AS
(
SELECT empno, mgr, CAST(ename AS CHAR(200))
  FROM emp
 WHERE empno = 7788 /* SCOTT */
UNION ALL
SELECT EMP.empno, EMP.mgr, CONCAT(CCMD.`path`, ' -> ', EMP.ename)
  FROM chain_cmd CCMD,
       emp       EMP
 WHERE EMP.empno = CCMD.mgr
)
SELECT *
  FROM chain_cmd
 WHERE mgr IS NULL;
