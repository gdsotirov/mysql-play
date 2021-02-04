/* Benchmark performance of LATERAL compared to select list subquery and left join */

/* 1. Use Examples/Schema/dept_emp.sql for test schema */

/* 2. Generate 1 million employees with Examples/WITH/gen_emps.sql script
 *    For 100k rows -  16.156 sec
 *    For 1m   rows - 171.797 sec
 */

/* 3. Evaluate execution plans of the queries from Examples/Join/lateral.sql and record execution times */

/* 4. Evaluate execution plans of the following modified queries that select just one of the departments */

/* I */
SELECT D.dname,
       (SELECT MIN(E.sal) FROM emp E WHERE E.deptno = D.deptno) AS min_sal,
       (SELECT AVG(E.sal) FROM emp E WHERE E.deptno = D.deptno) AS avg_sal,
       (SELECT MAX(E.sal) FROM emp E WHERE E.deptno = D.deptno) AS max_sal
  FROM dept D
 WHERE deptno = 10;

/* II */
SELECT D.dname, DT.min_sal, DT.avg_sal, DT.max_sal
  FROM dept D
       LEFT JOIN
       (SELECT E.deptno,
               MIN(E.sal) min_sal, AVG(E.sal) avg_sal, MAX(E.sal) max_sal
          FROM emp E
         GROUP BY E.deptno
       ) AS DT
       ON DT.deptno = D.deptno
 WHERE D.deptno = 10;

/* III */
SELECT D.dname, LDT.min_sal, LDT.avg_sal, LDT.max_sal
  FROM dept D,
       LATERAL
       (SELECT MIN(E.sal) min_sal, AVG(E.sal) avg_sal, MAX(E.sal) max_sal
          FROM emp E
         WHERE E.deptno = D.deptno
       ) AS LDT
 WHERE D.deptno = 10;

/* 5. Results
 *
 * All departments 100k rows
 * I   Cost:     0.65 Time: 0.297 sec / 0.000 sec
 * II  Cost:  1398.72 Time: 0.109 sec / 0.000 sec
 * III Cost:  3649.63 Time: 0.093 sec / 0.000 sec
 *
 * All departments 1m rows
 * I   Cost:     0.65 Time: 7.781 sec / 0.000 sec
 * II  Cost: 13951.97 Time: 2.110 sec / 0.000 sec
 * III Cost:  6148.63 Time: 2.125 sec / 0.000 sec
 *
 * One department 1m rows
 * I   Cost:     1.00 Time: 1.954 sec / 0.000 sec
 * II  Cost:     3.50 Time: 2.141 sec / 0.000 sec
 * III Cost:     2.72 Time: 0.719 sec / 0.000 sec
 *
 */

