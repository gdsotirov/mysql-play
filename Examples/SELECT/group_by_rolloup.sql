/* MySQL 4.1.1 (released on 2023-12-01) added ROLLUP modifier to GROUP BY
 * ROLLUP is used for generation of extra output rows from higher-level
 * (supper-aggregate) summary operations. NULL represents all values.
 */

SELECT COALESCE(D.dname, 'Total') Dept,
       SUM(COALESCE(E.sal, 0)) Total
  FROM emp  E
       LEFT OUTER JOIN dept D
       ON E.deptno = D.deptno
 GROUP BY D.dname WITH ROLLUP;

/* 
 * +------------+----------+
 * | Dept       | Total    |
 * +------------+----------+
 * | ACCOUNTING |  8750.00 |
 * | RESEARCH   | 10875.00 |
 * | SALES      |  9400.00 |
 * | Total      | 29025.00 | <- This is supper-aggregate
 * +------------+----------+
 * 4 rows in set (0,01 sec)
 */

START TRANSACTION;

/* Lets add an employee without department and job */

INSERT INTO emp
  (empno, ename, job, mgr, hiredate, sal, deptno)
VALUES
  (9999, 'MULDER', 'SALESMAN', NULL, '1988-01-01', 1600, NULL);

SELECT COALESCE(D.dname, 'Total') Dept,
       SUM(COALESCE(E.sal, 0)) Total
  FROM emp  E
       LEFT OUTER JOIN dept D
       ON E.deptno = D.deptno
 GROUP BY D.dname WITH ROLLUP;

/*
 * +------------+----------+
 * | Dept       | Total    |
 * +------------+----------+
 * | Total      |  1600.00 | <- This is NULL in data
 * | ACCOUNTING |  8750.00 |
 * | RESEARCH   | 10875.00 |
 * | SALES      |  9400.00 |
 * | Total      | 30625.00 | <- This is supper-aggregate
 * +------------+----------+
 * 5 rows in set (0,00 sec)
 */

ROLLBACK;

