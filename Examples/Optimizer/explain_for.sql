/* MySQL 8.2.0: EXPLAIN now supports a FOR SCHEMA or FOR DATABASE option
 * which causes the statement to be analyzed as if it had been run in
 * the database specified by the option.
 * See https://dev.mysql.com/doc/refman/8.2/en/explain.html
 */

/* Create dept_emp schema using the script Schema/dep_emp.sql */

EXPLAIN FORMAT=TRADITIONAL
 SELECT E.ename, E.job, D.dname
   FROM dept D,
        emp  E
  WHERE E.deptno = D.deptno
    AND E.job    = 'CLERK';

/* This produces the following plan - note type, possible_keys, rows and filtered:
 *
 * +----+-------------+-------+------------+--------+---------------+---------+---------+-------------------+------+----------+-------------+
 * | id | select_type | table | partitions | type   | possible_keys | key     | key_len | ref               | rows | filtered | Extra       |
 * +----+-------------+-------+------------+--------+---------------+---------+---------+-------------------+------+----------+-------------+
 * |  1 | SIMPLE      | E     | NULL       | ALL    | fk_deptno     | NULL    | NULL    | NULL              |   14 |    10.00 | Using where |
 * |  1 | SIMPLE      | D     | NULL       | eq_ref | PRIMARY       | PRIMARY | 4       | dept_emp.E.deptno |    1 |   100.00 | NULL        |
 * +----+-------------+-------+------------+--------+---------------+---------+---------+-------------------+------+----------+-------------+
 * 2 rows in set, 1 warning (0,00 sec)
 */

/* Create new schema dept_emp_new using the script Schema/dep_emp.sql */

/* Add a new index on column emp.job ... */
ALTER TABLE dept_emp_new.emp
  ADD INDEX idx_job (job ASC);

/* Add a histogram on column emp.job ... *
ANALYZE TABLE dept_emp_new.emp
  UPDATE HISTOGRAM ON job WITH 5 BUCKETS; */

/* ... and explain against the new schema */
EXPLAIN FORMAT=TRADITIONAL FOR SCHEMA dept_emp_new
 SELECT E.ename, E.job, D.dname
   FROM dept D,
        emp  E
  WHERE E.deptno = D.deptno
    AND E.job    = 'CLERK';

/* This produces a slightly different plan, because of the index - note the change
 * in type, possible_keys, key, key_len, ref, rows and filtered for table E:
 *
 * +----+-------------+-------+------------+--------+---------------+---------+---------+-----------------------+------+----------+-------------+
 * | id | select_type | table | partitions | type   | possible_keys | key     | key_len | ref                   | rows | filtered | Extra       |
 * +----+-------------+-------+------------+--------+---------------+---------+---------+-----------------------+------+----------+-------------+
 * |  1 | SIMPLE      | E     | NULL       | ref    | idx_job       | idx_job | 39      | const                 |    4 |   100.00 | Using where |
 * |  1 | SIMPLE      | D     | NULL       | eq_ref | PRIMARY       | PRIMARY | 4       | dept_emp_new.E.deptno |    1 |   100.00 | NULL        |
 * +----+-------------+-------+------------+--------+---------------+---------+---------+-----------------------+------+----------+-------------+
 * 2 rows in set, 1 warning (0,00 sec)
 *
 * So FOR SCHEMA is an excellent way to examine the effect of schema changes
 * (e.g. like adding a new index or histogram) on query execution plans,
 * before applying them for real.
 * Note: Adding histogram does not seem to work... strange.
 *
 */

