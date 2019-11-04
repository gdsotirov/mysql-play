/* Since MySQL 5.6.3 (2011-10-03, Milestone 6) it is possible to trace the optimizer
 * See https://dev.mysql.com/doc/relnotes/mysql/5.6/en/news-5-6-3.html#mysqld-5-6-3-optimizer
 * See https://dev.mysql.com/doc/internals/en/optimizer-tracing.html
 */

/* Enable optimizer trace */
SET optimizer_trace="enabled=on";

/* Execute query */
SELECT E.ename, E.job, D.dname
  FROM dept D,
       emp  E
 WHERE E.deptno = D.deptno
   AND E.job    = 'CLERK';

/* View generated trace */
SELECT TRACE
  FROM INFORMATION_SCHEMA.OPTIMIZER_TRACE;

/* or */

SELECT TRACE
  INTO DUMPFILE 'opt_trace.json'
  FROM INFORMATION_SCHEMA.OPTIMIZER_TRACE;

/* Requires setting secure_file_priv - see https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_secure_file_priv */

/* Result (General trace structure)
 * See trace.json
 */

/* Disable optimizer trace */
SET optimizer_trace="enabled=off";

