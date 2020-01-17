/* MySQL 8.0.19 supports VALUES statement
 * See https://dev.mysql.com/doc/refman/8.0/en/values.html
 */

/* VALUES could be used where you could employ SELECT, so it could be used */
/* as standalone statment */

VALUES ROW(1), ROW(2), ROW(3);

/* or in unions */

VALUES ROW(1), ROW(2)
UNION
VALUES ROW(3), ROW(4);

/* or as derrived table */

SELECT num, str
  FROM (VALUES ROW(1, 'A'),
               ROW(2, 'B'),
               ROW(3, 'C')
       ) AS t(num, str);

/* or in joins */

SELECT t1.n, t1.s
  FROM (VALUES ROW(1, 'A'), ROW(2, 'B'), ROW(3, 'C')) AS t1(n, s)
       JOIN
       (VALUES ROW(1, 'A'), ROW(4, 'D')) AS t2(n, s)
       ON t1.n = t2.n;

/* or in place of VALUES keyword in INSERR or REPLACE statments */

INSERT INTO emp
  (empno, ename, job)
VALUES ROW(9998, 'Mulder', 'Agent'),
       ROW(9999, 'Sculy' , 'Agent');

/* or in place of source table in  CREATE TABLE ... SELECT and CREATE VIEW ... SELECT statements */

CREATE TABLE tst (n INT, s VARCHAR(10))
SELECT *
  FROM (VALUES ROW(1, NULL), ROW(NULL, 'B'), ROW(3, NULL)) AS t(n, s);

