/* A regression with LATERAL in MySQL 8.0.16
 * See https://bugs.mysql.com/bug.php?id=95411
 */

/* 1. Create the sample DEPT/EMP database with the script from Examples/Schema/dept_emp.sql */

/* 2. Execute the following query: */

SELECT D.dname, LDT.min_sal, LDT.avg_sal, LDT.max_sal
  FROM dept D,
       LATERAL
       (SELECT MIN(E.sal) min_sal, AVG(E.sal) avg_sal, MAX(E.sal) max_sal
          FROM emp E
         WHERE E.deptno = D.deptno
       ) AS LDT;

/* 3. The result in MySQL 8.0.14 is:

+------------+---------+-------------+---------+
| dname      | min_sal | avg_sal     | max_sal |
+------------+---------+-------------+---------+
| ACCOUNTING | 1300.00 | 2916.666667 | 5000.00 |
| RESEARCH   |  800.00 | 2175.000000 | 3000.00 |
| SALES      |  950.00 | 1566.666667 | 2850.00 |
| OPERATIONS |    NULL |        NULL |    NULL | <-- OK
+------------+---------+-------------+---------+
4 rows in set (0.00 sec)

Which is *correct*, because there are no employees registered for department
OPERATIONS.

The result in MySQL 8.0.16 however is:

+------------+---------+-------------+---------+
| dname      | min_sal | avg_sal     | max_sal |
+------------+---------+-------------+---------+
| ACCOUNTING | 1300.00 | 2916.666667 | 5000.00 |
| RESEARCH   |  800.00 | 2175.000000 | 3000.00 |
| SALES      |  950.00 | 1566.666667 | 2850.00 |
| OPERATIONS |  950.00 | 1566.666667 | 2850.00 | <-- !? KO
+------------+---------+-------------+---------+
4 rows in set (0.00 sec)

Which is *wrong*, because there are no employees registered for department
OPERATIONS (see above). Seems like the last aggregates are copied on the next
rows where NULLs should normally appear.
*/

/* For comparison the following equivalent query with LEFT JOIN */

SELECT D.dname, DT.min_sal, DT.avg_sal, DT.max_sal
  FROM dept D
       LEFT JOIN
       (SELECT E.deptno, MIN(E.sal) min_sal, AVG(E.sal) avg_sal, MAX(E.sal) max_sal
          FROM emp E
         GROUP BY E.deptno
       ) AS DT ON DT.deptno = D.deptno;

/*
produces correct results in both MySQL 8.0.14 and 8.0.16 as follows:

+------------+---------+-------------+---------+
| dname      | min_sal | avg_sal     | max_sal |
+------------+---------+-------------+---------+
| ACCOUNTING | 1300.00 | 2916.666667 | 5000.00 |
| RESEARCH   |  800.00 | 2175.000000 | 3000.00 |
| SALES      |  950.00 | 1566.666667 | 2850.00 |
| OPERATIONS |    NULL |        NULL |    NULL |
+------------+---------+-------------+---------+
4 rows in set (0.00 sec)

*/
