/* Hash join optimization was added in MySQL 8.0.18
 * See https://dev.mysql.com/doc/refman/8.0/en/hash-joins.html
 */

/* Create table for salary ranges by job */
CREATE TABLE job_sal (
  job     VARCHAR(9),
  sal_min DECIMAL(9,2) NOT NULL,
  sal_max DECIMAL(9,2)
);

/* Load some data */
INSERT INTO job_sal (job, sal_min, sal_max) VALUES ('ANALYST', 3000, 4000);
INSERT INTO job_sal (job, sal_min, sal_max) VALUES ('CLERK', 800, 1500);
INSERT INTO job_sal (job, sal_min, sal_max) VALUES ('MANAGER', 2800, 3500);
INSERT INTO job_sal (job, sal_min, sal_max) VALUES ('SALESMAN', 1250, 1900);
INSERT INTO job_sal (job, sal_min, sal_max) VALUES ('PRESIDENT', 5000, NULL);

/* Select employees with salary out of range */
EXPLAIN FORMAT=TREE
SELECT E.ename, E.sal, JS.sal_min, COALESCE(JS.sal_max, 1000000)
  FROM emp     E,
       job_sal JS
 WHERE E.job = JS.job
   AND E.sal NOT BETWEEN JS.sal_min AND COALESCE(JS.sal_max, 1000000);

/* 0.89 sec for 1M employees */

/* ... and without hash join optimization
 * NO_HASH_JOIN available only in 8.0.18
 * See https://dev.mysql.com/doc/refman/8.0/en/optimizer-hints.html#optimizer-hints-overview
 */
EXPLAIN
SELECT /*+ NO_HASH_JOIN(JS, E) */
       E.ename, E.sal, JS.sal_min, COALESCE(JS.sal_max, 1000000)
  FROM emp     E,
       job_sal JS
 WHERE E.job = JS.job
   AND E.sal NOT BETWEEN JS.sal_min AND COALESCE(JS.sal_max, 1000000);

/* 1.26 sec for 1M employees */

