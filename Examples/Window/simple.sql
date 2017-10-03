/* In MySQL 8.0 or newer */

SELECT E.ename, E.job, D.dname,
       E.sal, SUM(E.sal) OVER (PARTITION BY E.deptno) AS dept_sal,
       E.comm, SUM(IFNULL(E.comm, 0)) OVER (PARTITION BY E.deptno) AS dept_com
  FROM emp  E,
       dept D
 WHERE E.deptno = D.deptno;

/* In MySQL 5.7 or older */

SELECT E.ename, E.job, D.dname,
       E.sal, dept_sal,
       E.comm, dept_comm
  FROM emp  E,
       dept D,
       (SELECT deptno, SUM(sal) dept_sal
          FROM emp
         GROUP BY deptno) DSAL,
       (SELECT deptno, SUM(IFNULL(comm, 0)) dept_comm
          FROM emp
         GROUP BY deptno) DCOM
 WHERE E.deptno = D.deptno
   AND DSAL.deptno = D.deptno
   AND DCOM.deptno = D.deptno;
