/* MySQL 8.0.19 supports TABLE statement
 * See https://dev.mysql.com/doc/refman/8.0/en/table.html
 */

CREATE TABLE t1 (n INT, s VARCHAR(10));
CREATE TABLE t2 (n INT, s VARCHAR(10));
CREATE TABLE t3 (n INT);

INSERT INTO t1 VALUES ROW(1, 'A'), ROW(2, 'B'), ROW(3, 'C');
INSERT INTO t2 VALUES ROW(1, 'A'), ROW(4, 'D');
INSERT INTO t3 VALUES ROW(1), ROW(4);

/* TABLE could be used where you could employ SELECT, so it could be used */
/* as standalone statment */

TABLE t1;
TABLE t2;
TABLE t3;

/* with the same meaning as SELECT * FROM t1 */

/* or in unions */

TABLE t1 UNION TABLE t2;

/* or in IN subqueries */

SELECT * FROM t1 WHERE n in (TABLE t3);

