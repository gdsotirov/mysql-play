/* MySQL 9.0.0: Support for a VECTOR data type.
 * See https://dev.mysql.com/doc/refman/9.6/en/vector.html
 * MariaDB 10.7: Support for VECTOR data, type, index and search
 * See https://mariadb.com/docs/server/reference/sql-structure/vectors
 */

/* Let's create table for employee embeddings */
CREATE TABLE emp_embs (
  empno INTEGER   NOT NULL PRIMARY KEY,
  emb   VECTOR(3) NOT NULL, /* vector with three dimensions */

  FOREIGN KEY (empno) REFERENCES emp (empno),

  VECTOR INDEX (emb) M=8 DISTANCE=cosine
);

/* And populate it based on some criteria */
INSERT INTO emp_embs (empno, emb)
SELECT empno,
       VEC_FromText(CONCAT('[',
       COALESCE(emp.deptno, 0) / 100.0, ',', /* 1st dim - department */
       CASE UPPER(COALESCE(emp.job, ''))     /* 2nd dim - job */
         WHEN 'PRESIDENT' THEN 1.000
         WHEN 'MANAGER'   THEN 0.700
         WHEN 'ANALYST'   THEN 0.500
         WHEN 'SALESMAN'  THEN 0.300
         WHEN 'CLERK'     THEN 0.200
         ELSE 0.100 /* unknown job */
       END, ',',
       COALESCE(emp.sal, 0) / 5000.0,    /* 3rd dim - salary */
       ']')) AS vec
  FROM emp;

/* Then, check what was generated */
SELECT E.empno, E.ename, D.dname, E.job, E.sal, VEC_ToText(EE.emb)
  FROM dept     D,
       emp      E,
       emp_embs EE
 WHERE E.deptno = D.deptno
   AND E.empno  = EE.empno
 ORDER BY EE.emb, E.ename;

/* Now lets see which employees are close to CLARK, a manager in ACCOUNTING department */
WITH mgr AS (
  SELECT emb
    FROM emp_embs
   WHERE empno = (SELECT empno
                    FROM emp
                   WHERE ename = 'CLARK'
                 )
)
SELECT E.empno, E.ename, D.dname, E.job, E.sal
  FROM emp      E,
       dept     D,
       emp_embs EE,
       mgr      M
 WHERE E.deptno = D.deptno
   AND E.empno  = EE.empno
ORDER BY /*VEC_DISTANCE_COSINE*/VEC_DISTANCE_EUCLIDEAN(EE.emb, M.emb) ASC
LIMIT 5;

