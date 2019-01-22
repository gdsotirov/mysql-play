/* MySQL 8.0.14: Lateral derived tables */

/* Calculate max salary per department */
SELECT D.dname, DT.max_sal
  FROM dept D,
       (SELECT E.deptno, MAX(E.sal) max_sal
          FROM emp E
         GROUP BY E.deptno
       ) AS DT
 WHERE DT.deptno = D.deptno;

SELECT D.dname, DT.max_sal
  FROM dept D
       LEFT JOIN
       (SELECT E.deptno, MAX(E.sal) max_sal
          FROM emp E
         GROUP BY E.deptno
       ) AS DT ON DT.deptno = D.deptno;

/* Make derived table depend on the other table ? */
SELECT D.dname, DT.max_sal
  FROM dept D,
       (SELECT MAX(E.sal) max_sal
          FROM emp E
         WHERE E.deptno = D.deptno
       ) AS DT;

/* Error Code: 1054. Unknown column 'D.deptno' in 'where clause' */

/* LATERAL keyword */
SELECT D.dname, LDT.max_sal
  FROM dept D,
       LATERAL
       (SELECT MAX(E.sal) max_sal
          FROM emp E
         WHERE E.deptno = D.deptno
       ) AS LDT;
