/* MySQL 8.0.14: Lateral derived tables */

/* Problem: Calculate min/avg/max salary per department */

/* Solution 1: with derived table (and INNER JOIN) */
SELECT D.dname, DT.min_sal, DT.avg_sal, DT.max_sal
  FROM dept D,
       (SELECT E.deptno, MIN(E.sal) min_sal, AVG(E.sal) avg_sal, MAX(E.sal) max_sal
          FROM emp E
         GROUP BY E.deptno
       ) AS DT
 WHERE DT.deptno = D.deptno;

/* ... and with LEFT JOIN */
SELECT D.dname, DT.min_sal, DT.avg_sal, DT.max_sal
  FROM dept D
       LEFT JOIN
       (SELECT E.deptno, MIN(E.sal) min_sal, AVG(E.sal) avg_sal, MAX(E.sal) max_sal
          FROM emp E
         GROUP BY E.deptno
       ) AS DT ON DT.deptno = D.deptno;

/* Solution 2: with subqueries in SELECT */

/* Subqueries in SELECT are restricted to 1 column */
SELECT D.dname,
       (SELECT E.deptno, MIN(E.sal) min_sal, AVG(E.sal) avg_sal, MAX(E.sal) max_sal
          FROM emp E
         WHERE E.deptno = D.deptno)
  FROM dept D;

/* Error Code: 1241. Operand should contain 1 column(s) */

SELECT D.dname,
       (SELECT MIN(E.sal) FROM emp E WHERE E.deptno = D.deptno) AS min_sal,
       (SELECT AVG(E.sal) FROM emp E WHERE E.deptno = D.deptno) AS avg_sal,
       (SELECT MAX(E.sal) FROM emp E WHERE E.deptno = D.deptno) AS max_sal
  FROM dept D;

/* Solution 3: Lateral derived table */

/* Why not make the derived table depend on the other table? */
SELECT D.dname, DT.max_sal
  FROM dept D,
       (SELECT MAX(E.sal) max_sal
          FROM emp E
         WHERE E.deptno = D.deptno
       ) AS DT;

/* Error Code: 1054. Unknown column 'D.deptno' in 'where clause' */

/* LATERAL keyword */
SELECT D.dname, LDT.min_sal, LDT.avg_sal, LDT.max_sal
  FROM dept D,
       LATERAL
       (SELECT MIN(E.sal) min_sal, AVG(E.sal) avg_sal, MAX(E.sal) max_sal
          FROM emp E
         WHERE E.deptno = D.deptno
       ) AS LDT;
