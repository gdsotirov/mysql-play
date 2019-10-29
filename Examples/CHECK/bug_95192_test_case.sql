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
INSERT INTO tst (id, start_date) VALUES (1, '2019-10-29');
/* Query OK, 1 row affected */

/* 3. Try to insert an invalid record... suprise! */
INSERT INTO tst (id, start_date) VALUES (5, '2019-10-25');
/* Should fail, but suceeds in MySQL 8.0.16 and MySQL 8.0.17 */
/* Query OK, 1 row affected */
/* Properly fails in MySQL 8.0.18 */
/* Error Code: 3819. Check constraint 'chk_dat' is violated. */

