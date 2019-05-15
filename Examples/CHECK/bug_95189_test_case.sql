/* CHECK constraint comparing columns is not always enforced with UPDATE queries
 * See https://bugs.mysql.com/bug.php?id=95189
 */

/* 1. Create a table with start and end date */
CREATE TABLE tst (
  id INT,
  start_date DATE,
  end_date DATE,
  PRIMARY KEY (id),
  CONSTRAINT chk_dat CHECK (start_date < end_date)
);
/* Query OK, 0 rows affected */

/* 2. Insert a valid record */
INSERT INTO tst (id, start_date, end_date) VALUES (1, '2019-04-25', '2019-04-30');
/* Query OK, 1 row affected */

/* 3. Try to insert invalid record */
INSERT INTO tst (id, start_date, end_date) VALUES (2, '2019-04-30', '2019-04-25');
/* ERROR: 3819: Check constraint 'chk_dat' is violated. */

/* 4. Try to make a record invalid */
UPDATE tst SET end_date = '2019-04-20' WHERE id = 1;
/* ERROR: 3819: Check constraint 'chk_dat' is violated. */

/* 5. On a replica, or setting one of the following... */
SET binlog_format = 'STATEMENT';
SET binlog_row_image = 'minimal';

/* ...and then try to make the record invalid again... surprise! */
UPDATE tst SET end_date = '2019-04-20' WHERE id = 1; /* Should fail, but suceeds */
/* Query OK, 1 row affected */
