/* Generate employees for the dept_emp schema */

/* See https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_cte_max_recursion_depth
 *  or https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_max_execution_time
 */
SET cte_max_recursion_depth = 1000000;

INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno)
WITH RECURSIVE gen_emps (empno, ename, job, mgr, hiredate, sal, comm, deptno) AS (
  SELECT 10000                empno,
         gen_rnd_string(10)   ename,
         CASE gen_range(1, 4)
           WHEN 1 THEN 'ANALYST'
           WHEN 2 THEN 'CLERK'
           WHEN 3 THEN 'MANAGER'
           WHEN 4 THEN 'SALESMAN'
         END                   job,
         0                     mgr,
         STR_TO_DATE('1980-01-01', '%Y-%m-%d') + INTERVAL gen_range(1, 4200) DAY
                               hiredate,
         gen_range(1000, 9999) sal,
         NULL                  comm,
         gen_range(1, 4) * 10  deptno
  UNION ALL
  SELECT empno + 1,
         gen_rnd_string(10)   ename,
         CASE gen_range(1, 4)
           WHEN 1 THEN 'ANALYST'
           WHEN 2 THEN 'CLERK'
           WHEN 3 THEN 'MANAGER'
           WHEN 4 THEN 'SALESMAN'
         END                   job,
         0                     mgr,
         STR_TO_DATE('1980-01-01', '%Y-%m-%d') + INTERVAL gen_range(1, 4200) DAY
                               hiredate,
         gen_range(1000, 9999) sal,
         NULL                  comm,
         gen_range(1, 4) * 10  deptno
    FROM gen_emps
   WHERE empno < 1000000 + 10000 - 1 /* For 1m rows */
)
SELECT empno, ename, job, mgr, hiredate, sal, comm, deptno
  FROM gen_emps;

/* Clean up */
DELETE FROM emp WHERE empno >= 10000;

