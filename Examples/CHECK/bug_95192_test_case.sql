/* CHECK constraint comparing column with default value is not enforced
 * See https://bugs.mysql.com/bug.php?id=95192
 */

/* 1. Create table with start, end and created dates */
CREATE TABLE tst (
  id INT,
  start_date DATE,
  end_date DATE,
  created DATE DEFAULT (CURDATE()),
  PRIMARY KEY (id),
  CONSTRAINT chk_dat CHECK (start_date >= created)
);
/* Query OK, 0 rows affected */

/* 2. Insert a valid record */
INSERT INTO tst (id, start_date) VALUES (1, '2019-04-29');
/* Query OK, 1 row affected */

/* 3. Try to insert an invalid record... suprise! */
INSERT INTO tst (id, start_date) VALUES (2, '2019-04-25'); /* Should fail, but suceeds */
/* Query OK, 1 row affected */
