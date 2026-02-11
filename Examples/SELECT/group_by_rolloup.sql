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
  (9999, 'MULDER', NULL, NULL, '1988-01-01', 1600, NULL);

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

/*
 * MySQL 8.0.1 (released on 2017-04-10) added GROUPPING function to distinguish
 * between the supper-agregate rows and real NULLs in data
 * See https://dev.mysql.com/doc/relnotes/mysql/8.0/en/news-8-0-1.html
 * See https://dev.mysql.com/doc/refman/8.0/en/miscellaneous-functions.html#function_grouping
 */

SELECT CASE GROUPING(D.dname)
         WHEN 1 THEN 'Total'
         ELSE COALESCE(D.dname, 'No department')
       END Dept,
       SUM(COALESCE(E.sal, 0)) Total
  FROM emp  E
       LEFT OUTER JOIN dept D ON E.deptno = D.deptno
 GROUP BY D.dname WITH ROLLUP;

/*
 * +---------------+----------+
 * | Dept          | Total    |
 * +---------------+----------+
 * | No department |  1600.00 | <- This is NULL in data, clearly indicated
 * | ACCOUNTING    |  8750.00 |
 * | RESEARCH      | 10875.00 |
 * | SALES         |  9400.00 |
 * | Total         | 30625.00 | <- This is supper-aggregate
 * +---------------+----------+
 * 5 rows in set (0,00 sec)
 */

/*
 * MySQL 8.4.3 now supports an alternative syntax for the GROUP BY clause ROLLUP modifier
 * See https://dev.mysql.com/doc/relnotes/mysql/8.4/en/news-8-4-3.html#mysqld-8-4-3-feature
 * See https://dev.mysql.com/doc/refman/8.4/en/group-by-modifiers.html
 */

SELECT CASE GROUPING(D.dname)
         WHEN 1 THEN 'Total'
         ELSE COALESCE(D.dname, 'No department')
       END Dept,
       CASE GROUPING(E.job)
         WHEN 1 THEN 'Total'
         ELSE COALESCE(E.job, 'No job')
       END Job,
       SUM(COALESCE(E.sal, 0)) Total
  FROM emp  E
       LEFT OUTER JOIN dept D ON E.deptno = D.deptno
 GROUP BY ROLLUP (D.dname, E.job);
/* Same as
 GROUP BY D.dname, E.job WITH ROLLUP
 */

/*
 * +---------------+-----------+----------+
 * | Dept          | Job       | Total    |
 * +---------------+-----------+----------+
 * | No department | No job    |  1600.00 | <- This is NULL in data
 * | No department | Total     |  1600.00 | <- This is supper-aggregate for no department and no job
 * | ACCOUNTING    | CLERK     |  1300.00 |
 * | ACCOUNTING    | MANAGER   |  2450.00 |
 * | ACCOUNTING    | PRESIDENT |  5000.00 |
 * | ACCOUNTING    | Total     |  8750.00 | <- This is supper-aggregate for ACCOUNTING department
 * | RESEARCH      | ANALYST   |  6000.00 |
 * | RESEARCH      | CLERK     |  1900.00 |
 * | RESEARCH      | MANAGER   |  2975.00 |
 * | RESEARCH      | Total     | 10875.00 | <- This is supper-aggregate for RESEARCH department
 * | SALES         | CLERK     |   950.00 |
 * | SALES         | MANAGER   |  2850.00 |
 * | SALES         | SALESMAN  |  5600.00 |
 * | SALES         | Total     |  9400.00 | <- This is supper-aggregate for SALES department
 * | Total         | Total     | 30625.00 | <- This is supper-aggregate, e.g. grand total
 * +---------------+-----------+----------+
 * 15 rows in set (0,00 sec)
 */

ROLLBACK;

