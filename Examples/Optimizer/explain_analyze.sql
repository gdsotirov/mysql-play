/* Since MySQL 8.0.18 (2019-10-14 GA) it is possible to profile query
 * execution with EXPLAIN ANALYZE
 * See https://dev.mysql.com/doc/refman/8.0/en/explain.html#explain-analyze
 */

/* Explain and analyze a hash join */
EXPLAIN ANALYZE
SELECT E.ename, E.sal, JS.sal_min, JS.sal_max
  FROM emp     E,
       job_sal JS
 WHERE E.job = JS.job
   AND E.sal NOT BETWEEN JS.sal_min AND JS.sal_max;

/*
 * +---------------------------------------------------------------------------------------------+
 * | EXPLAIN                                                                                     |
 * +---------------------------------------------------------------------------------------------+
 * | -> Filter: (e.sal not between js.sal_min and js.sal_max)   (cost=499211.71 rows=442901)
 *        (actual time=0.098..778.486 rows=915166 loops=1)
 *     -> Inner hash join (e.job = js.job)  (cost=499211.71 rows=442901)
 *          (actual time=0.089..568.473 rows=1000014 loops=1)
 *         -> Table scan on E  (cost=1962.39 rows=996514)
 *              (actual time=0.025..288.830 rows=1000014 loops=1)
 *         -> Hash
 *             -> Table scan on JS  (cost=0.75 rows=5) (actual time=0.041..0.048 rows=5 loops=1) |
 * +---------------------------------------------------------------------------------------------+
 * 1 row in set (0.8240 sec)
 */

/* Explain and analyze a nested loop */
EXPLAIN ANALYZE
SELECT E.ename, E.job, D.dname
  FROM dept D,
       emp  E
 WHERE E.deptno = D.deptno
   AND E.job    = 'CLERK';

/*
 * +---------------------------------------------------------------------------------------------+
 * | EXPLAIN                                                                                     |
 * +---------------------------------------------------------------------------------------------+
 * | -> Nested loop inner join  (cost=144308.94 rows=442815)
 *        (actual time=5.904..3281.472 rows=333278 loops=1)
 *     -> Table scan on D  (cost=1.40 rows=4)
 *          (actual time=4.659..4.666 rows=4 loops=1)
 *     -> Filter: (e.job = 'CLERK')  (cost=5627.35 rows=110704)
 *          (actual time=1.016..811.246 rows=83320 loops=4)
 *         -> Index lookup on E using fk_deptno (deptno=d.deptno)  (cost=5627.35 rows=332171)
 *              (actual time=1.013..786.799 rows=250004 loops=4)                                 |
 * +---------------------------------------------------------------------------------------------+
 * 1 row in set (3.3051 sec)
 *
 * first row -> 5.904 ≈ 5.675 = 4.659 + 1.016
 * all rows -> 3 281.472 ≈ 3 249.65 = 4.666 + 4 * 811.246
 */

