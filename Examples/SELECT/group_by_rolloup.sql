/* Add employee without department
 * INSERT INTO emp
 *   (empno, ename, job, mgr,
 *    hiredate, sal, deptno)
 * VALUES
 *  (9999, 'MULDER', 'SALESMAN', NULL,
 *   '1988-01-01', 1600, NULL);
 */

SELECT CASE GROUPING(D.dname)
         WHEN 1 THEN 'Grand Total'
         ELSE COALESCE(D.dname, 'No department')
       END Dept,
       SUM(COALESCE(E.sal, 0)) Total
  FROM emp  E
       LEFT OUTER JOIN dept D ON E.deptno = D.deptno
 GROUP BY D.dname WITH ROLLUP;
