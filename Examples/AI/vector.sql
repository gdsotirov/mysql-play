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

  VECTOR INDEX (emb) M=8 DISTANCE=euclidean /* Commend out for MySQL */
);

/* And populate it based on some criteria */
INSERT INTO emp_embs (empno, emb)
SELECT empno,
       VEC_FromText(CONCAT('[', /* use STRING_TO_VECTOR for MySQL */
       COALESCE(emp.deptno, 0) / 100.0, ',',/* 1st dim - department */
       CASE UPPER(COALESCE(emp.job, ''))    /* 2nd dim - job */
         WHEN 'PRESIDENT' THEN 1.0
         WHEN 'MANAGER'   THEN 0.7
         WHEN 'ANALYST'   THEN 0.5
         WHEN 'SALESMAN'  THEN 0.3
         WHEN 'CLERK'     THEN 0.2
         ELSE 0.1 /* unknown job */
       END, ',',
       COALESCE(emp.sal, 0) / 5000.0,       /* 3rd dim - salary */
       ']')) AS vec
  FROM emp;

/*
Query OK, 14 rows affected (0.0043 sec)

Records: 14  Duplicates: 0  Warnings: 0
*/

/* Then, check what was generated */
/* Use VECTOR_TO_STRING(EE.emb) for MySQL */
SELECT E.empno, E.ename, D.dname, E.job, E.sal, VEC_ToText(EE.emb)
  FROM dept     D,
       emp      E,
       emp_embs EE
 WHERE E.deptno = D.deptno
   AND E.empno  = EE.empno
 ORDER BY EE.emb, E.ename;

/*
+-------+--------+------------+-----------+---------+--------------------+
| empno | ename  | dname      | job       | sal     | VEC_ToText(EE.emb) |
+-------+--------+------------+-----------+---------+--------------------+
|  7698 | BLAKE  | SALES      | MANAGER   | 2850.00 | [0.3,0.7,0.57]     |
|  7654 | MARTIN | SALES      | SALESMAN  | 1250.00 | [0.3,0.3,0.25]     |
|  7521 | WARD   | SALES      | SALESMAN  | 1250.00 | [0.3,0.3,0.25]     |
|  7499 | ALLEN  | SALES      | SALESMAN  | 1600.00 | [0.3,0.3,0.32]     |
|  7844 | TURNER | SALES      | SALESMAN  | 1500.00 | [0.3,0.3,0.3]      |
|  7900 | JAMES  | SALES      | CLERK     |  950.00 | [0.3,0.2,0.19]     |
|  7902 | FORD   | RESEARCH   | ANALYST   | 3000.00 | [0.2,0.5,0.6]      |
|  7788 | SCOTT  | RESEARCH   | ANALYST   | 3000.00 | [0.2,0.5,0.6]      |
|  7566 | JONES  | RESEARCH   | MANAGER   | 2975.00 | [0.2,0.7,0.595]    |
|  7369 | SMITH  | RESEARCH   | CLERK     |  800.00 | [0.2,0.2,0.16]     |
|  7876 | ADAMS  | RESEARCH   | CLERK     | 1100.00 | [0.2,0.2,0.22]     |
|  7839 | KING   | ACCOUNTING | PRESIDENT | 5000.00 | [0.1,1,1]          |
|  7782 | CLARK  | ACCOUNTING | MANAGER   | 2450.00 | [0.1,0.7,0.49]     |
|  7934 | MILLER | ACCOUNTING | CLERK     | 1300.00 | [0.1,0.2,0.26]     |
+-------+--------+------------+-----------+---------+--------------------+
14 rows in set (0.0126 sec)
*/

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
/* Use DISTANCE in MySQL HeatWave or MySQL AI
ORDER BY DISTANCE(EE.emb, M.emb, "COSINE") ASC
ORDER BY DISTANCE(EE.emb, M.emb, "DOT") ASC
ORDER BY DISTANCE(EE.emb, M.emb, "EUCLIDEAN") ASC */
/* Use VEC_DISTANCE* functions in MariaDB
ORDER BY VEC_DISTANCE_COSINE(EE.emb, M.emb) ASC */
ORDER BY VEC_DISTANCE_EUCLIDEAN(EE.emb, M.emb) ASC
LIMIT 5;

/*
+-------+-------+------------+---------+---------+
| empno | ename | dname      | job     | sal     |
+-------+-------+------------+---------+---------+
|  7782 | CLARK | ACCOUNTING | MANAGER | 2450.00 |
|  7566 | JONES | RESEARCH   | MANAGER | 2975.00 |
|  7698 | BLAKE | SALES      | MANAGER | 2850.00 |
|  7788 | SCOTT | RESEARCH   | ANALYST | 3000.00 |
|  7902 | FORD  | RESEARCH   | ANALYST | 3000.00 |
+-------+-------+------------+---------+---------+
5 rows in set (0.0058 sec)
*/

